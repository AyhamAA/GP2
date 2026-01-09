import 'package:dio/dio.dart';
import '../storage/token_storage.dart';

class ApiClient {
  static final Dio dio = Dio(
    BaseOptions(
      // Use localhost for Mac/Desktop or 10.0.2.2 for Android Emulator
      baseUrl: 'http://localhost:5149/api', // Mac/iOS: localhost, Android Emulator: 10.0.2.2
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

}
