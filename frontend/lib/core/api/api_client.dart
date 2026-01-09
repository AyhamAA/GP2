import 'package:dio/dio.dart';
import 'auth_refresh_service.dart';
import '../storage/token_storage.dart';

class ApiClient {
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:5149/api',
  );

  static final Dio dio = Dio(
    BaseOptions(
      // Use localhost for Mac/Desktop or 10.0.2.2 for Android Emulator
      baseUrl: apiBaseUrl,
      connectTimeout: const Duration(seconds: 10),
      sendTimeout: const Duration(seconds: 20),
      receiveTimeout: const Duration(seconds: 20),
    ),
  );

  // A separate client without auth-refresh interception to avoid recursion.
  static final Dio _authDio = Dio(
    BaseOptions(
      baseUrl: apiBaseUrl,
      connectTimeout: const Duration(seconds: 10),
      sendTimeout: const Duration(seconds: 20),
      receiveTimeout: const Duration(seconds: 20),
    ),
  );

  static bool _initialized = false;
  static Future<String?>? _refreshInFlight;

  static void ensureInitialized() {
    if (_initialized) return;
    _initialized = true;

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await TokenStorage.getAccessToken();
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (err, handler) async {
          final status = err.response?.statusCode;
          final requestOptions = err.requestOptions;

          // Only attempt a refresh on 401 and only once per request.
          final alreadyRetried = requestOptions.extra['__retried'] == true;
          if (status != 401 || alreadyRetried) {
            return handler.next(err);
          }

          _refreshInFlight ??= AuthRefreshService(_authDio).refresh();
          final newAccessToken = await _refreshInFlight;
          _refreshInFlight = null;

          if (newAccessToken == null || newAccessToken.isEmpty) {
            return handler.next(err);
          }

          // Retry original request with new token.
          requestOptions.extra['__retried'] = true;
          requestOptions.headers['Authorization'] = 'Bearer $newAccessToken';

          try {
            final response = await dio.fetch(requestOptions);
            return handler.resolve(response);
          } on DioException catch (e) {
            return handler.next(e);
          }
        },
      ),
    );
  }

  /// Converts an API base url like `http://host:5149/api` to server url `http://host:5149`.
  static String get serverBaseUrl {
    final base = dio.options.baseUrl;
    if (base.endsWith('/api')) return base.substring(0, base.length - 4);
    if (base.endsWith('/api/')) return base.substring(0, base.length - 5);
    return base;
  }

  /// Builds a public absolute URL for server-hosted assets such as `/Uploads/...`.
  /// Accepts `Uploads/...` or `/Uploads/...`.
  static String publicUrl(String? path) {
    if (path == null || path.trim().isEmpty) return '';
    final trimmed = path.trim();
    final normalized = trimmed.startsWith('/') ? trimmed : '/$trimmed';
    return '$serverBaseUrl$normalized';
  }
}
