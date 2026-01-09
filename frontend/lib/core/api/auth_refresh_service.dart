import 'package:dio/dio.dart';
import '../storage/token_storage.dart';
import '../storage/user_storage.dart';

class AuthRefreshService {
  AuthRefreshService(this._dio);

  final Dio _dio;

  /// Calls `POST /Auth/RefreshToken` and updates stored tokens.
  /// Returns the new access token if refresh succeeded; otherwise `null`.
  Future<String?> refresh() async {
    final userId = await UserStorage.getUserId();
    final refreshToken = await TokenStorage.getRefreshToken();

    if (userId == null || refreshToken == null || refreshToken.isEmpty) {
      return null;
    }

    try {
      final res = await _dio.post(
        '/Auth/RefreshToken',
        data: {
          'userId': userId,
          'refreshToken': refreshToken,
        },
      );

      final data = res.data;
      if (data is! Map) return null;

      final accessToken = data['accessToken']?.toString();
      final newRefreshToken = data['refreshToken']?.toString();

      if (accessToken == null ||
          accessToken.isEmpty ||
          newRefreshToken == null ||
          newRefreshToken.isEmpty) {
        return null;
      }

      await TokenStorage.saveTokens(
        accessToken: accessToken,
        refreshToken: newRefreshToken,
      );

      return accessToken;
    } on DioException {
      return null;
    }
  }
}


