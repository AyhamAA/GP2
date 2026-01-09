import 'package:dio/dio.dart';
import '../../../../core/api/api_client.dart';
import 'reset_password_request_model.dart';

class ResetPasswordService {
  Future<void> resetPassword({
    required String oldPassword,
    required String newPassword,
  }) async {

    final request = ResetPasswordRequest(
      oldPassword: oldPassword,
      newPassword: newPassword,
    );

    try {
      final response = await ApiClient.dio.post(
        '/Auth/ResetPassword',
        data: request.toJson(),
      );

      if (response.statusCode == 200) {
        return;
      }

      throw Exception('Reset password failed');
    } on DioException catch (e) {
      final status = e.response?.statusCode;

      if (status == 401) {
        throw Exception('Old password is incorrect');
      }

      throw Exception(
        e.response?.data?.toString() ?? 'Reset password error',
      );
    }
  }
}
