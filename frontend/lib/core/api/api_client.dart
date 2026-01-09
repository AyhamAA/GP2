import 'package:dio/dio.dart';
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
  )..interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await TokenStorage.getAccessToken();
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
    ),
  );

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
