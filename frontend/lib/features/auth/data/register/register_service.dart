import 'package:dio/dio.dart';
import '../../../../../core/api/api_client.dart';
import 'register_request_model.dart';
import 'register_response_model.dart';

class RegisterService {
  Future<RegisterResponse> register({
    required String fullName,
    required String email,
    required String password,
    required String confirmedPassword,
  }) async {
    final request = RegisterRequest(
      fullName: fullName,
      email: email,
      password: password,
      confirmedPassword: confirmedPassword,
    );

    try {
      final response = await ApiClient.dio.post(
        '/Auth/Register',
        data: request.toJson(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return RegisterResponse.fromJson(response.data);
      }

      throw Exception('Register failed');
    } on DioException catch (e) {
      if (e.response?.statusCode == 409) {
        throw Exception('Email already exists');
      }
      if (e.response?.statusCode == 400) {
        throw Exception('Invalid input data');
      }
      throw Exception('Register error');
    }
  }
}
