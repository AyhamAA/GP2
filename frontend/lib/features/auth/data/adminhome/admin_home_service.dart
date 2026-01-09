import '../../../../core/api/api_client.dart';
import 'admin_donation_request_model.dart';
import 'admin_take_donation_request_model.dart';

class AdminHomeService {
  // رفع donation
  Future<List<AdminDonationRequestModel>> getPendingEquipmentRequests() async {
    final res = await ApiClient.dio.get('/requests/admin/pending-requests');
    return (res.data as List)
        .map((e) => AdminDonationRequestModel.fromJson(e))
        .where((e) => e.type == 'Equipment')
        .toList();
  }

  Future<List<AdminDonationRequestModel>> getPendingMedicineRequests() async {
    final res = await ApiClient.dio.get('/requests/admin/pending-requests');
    return (res.data as List)
        .map((e) => AdminDonationRequestModel.fromJson(e))
        .where((e) => e.type == 'Medicine')
        .toList();
  }

  // أخذ donation
  Future<List<AdminTakeDonationRequestModel>>
  getPendingTakeEquipmentRequests() async {
    final res =
    await ApiClient.dio.get('/donations/admin/pending-equipmenttake');
    return (res.data as List)
        .map((e) => AdminTakeDonationRequestModel.fromJson(e))
        .toList();
  }

  Future<List<AdminTakeDonationRequestModel>>
  getPendingTakeMedicineRequests() async {
    final res =
    await ApiClient.dio.get('/donations/admin/pending-medicinetake');
    return (res.data as List)
        .map((e) => AdminTakeDonationRequestModel.fromJson(e))
        .toList();
  }
}
