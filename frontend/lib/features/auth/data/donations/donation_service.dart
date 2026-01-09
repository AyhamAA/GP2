import 'package:dio/dio.dart';
import '../../../../core/api/api_client.dart';
import 'available_donation_model.dart';

class DonationService {
  Future<List<AvailableDonation>> getAvailableEquipmentDonations() async {
    try {
      final response = await ApiClient.dio.get('/donations/available-equipment');
      if (response.data == null) {
        return [];
      }
      if (response.data is! List) {
        throw Exception('Invalid response format: expected List');
      }
      final List<dynamic> data = response.data as List;
      return data.map((json) {
        try {
          return AvailableDonation.fromJson(json as Map<String, dynamic>);
        } catch (e) {
          print('Error parsing donation item: $e');
          print('Item data: $json');
          rethrow;
        }
      }).toList();
    } on DioException catch (e) {
      print('Error fetching equipment donations: $e');
      print('Response: ${e.response?.data}');
      if (e.response?.statusCode == 401) {
        throw Exception('Unauthorized. Please login again.');
      } else if (e.response?.statusCode == 404) {
        throw Exception('Endpoint not found. Please check API configuration.');
      }
      rethrow;
    } catch (e) {
      print('Unexpected error fetching equipment donations: $e');
      rethrow;
    }
  }

  Future<List<AvailableDonation>> getAvailableMedicineDonations() async {
    try {
      final response = await ApiClient.dio.get('/donations/available-medicine');
      if (response.data == null) {
        return [];
      }
      if (response.data is! List) {
        throw Exception('Invalid response format: expected List');
      }
      final List<dynamic> data = response.data as List;
      return data.map((json) {
        try {
          return AvailableDonation.fromJson(json as Map<String, dynamic>);
        } catch (e) {
          print('Error parsing donation item: $e');
          print('Item data: $json');
          rethrow;
        }
      }).toList();
    } on DioException catch (e) {
      print('Error fetching medicine donations: $e');
      print('Response: ${e.response?.data}');
      if (e.response?.statusCode == 401) {
        throw Exception('Unauthorized. Please login again.');
      } else if (e.response?.statusCode == 404) {
        throw Exception('Endpoint not found. Please check API configuration.');
      }
      rethrow;
    } catch (e) {
      print('Unexpected error fetching medicine donations: $e');
      rethrow;
    }
  }
}

