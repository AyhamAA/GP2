import '../../../../core/api/api_client.dart';
import 'package:dio/dio.dart';

import 'dr_profile_model.dart';

class DrProfileService {

  Future<DrProfile> getProfile() async {
    final response = await ApiClient.dio.get('/Auth/ProfileUser');
    return DrProfile.fromJson(response.data);
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
      '/Auth/user',
      data: formData,
    );
  }
}
