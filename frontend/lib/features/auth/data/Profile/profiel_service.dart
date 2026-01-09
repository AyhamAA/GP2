import '../../../../core/api/api_client.dart';
import 'profile_model.dart';
import 'package:dio/dio.dart';

class AdminProfileService {

  Future<AdminProfile> getProfile() async {
    final response = await ApiClient.dio.get('/Auth/ProfileAdmin');
    return AdminProfile.fromJson(response.data);
  }

  Future<void> updateProfile({
    required String fullName,
    required String email,
    MultipartFile? image,
  }) async {

    final formData = FormData.fromMap({
      'fullName': fullName,
      'email': email,
      if (image != null) 'UploadProfileImage': image,
    });

    await ApiClient.dio.put(
      '/Auth/admin',
      data: formData,
    );
  }
}
