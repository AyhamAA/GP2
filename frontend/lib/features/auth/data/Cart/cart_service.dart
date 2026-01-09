import 'package:dio/dio.dart';
import '../../../../core/api/api_client.dart';
import '../../../../core/storage/token_storage.dart';
import 'add_to_cart_dto.dart';
import 'cart_response_model.dart';

class CartService {
  Future<CartResponseModel> getMyCart() async {
    final token = await TokenStorage.getAccessToken();

    if (token == null) {
      throw Exception('Access token not found');
    }

    try {
      final response = await ApiClient.dio.get('/requests/myCart');
      return CartResponseModel.fromJson(response.data);
    } on DioException catch (e) {
      final status = e.response?.statusCode;
      if (status == 401 || status == 403) {
        throw Exception('Unauthorized. Please login again.');
      }
      throw Exception(e.response?.data?.toString() ?? 'Failed to load cart');
    }
  }


  Future<void> addToCart(AddToCartDto dto) async {
    final token = await TokenStorage.getAccessToken();
    if (token == null) {
      throw Exception('Access token not found');
    }

    late String endpoint;
    if (dto.cartType == 1) {
      endpoint = 'addEquipmentToCart';
    } else if (dto.cartType == 2) {
      endpoint = 'addMedicineToCart';
    } else {
      throw Exception('Invalid cart type');
    }

    try {
      await ApiClient.dio.put('/requests/$endpoint', data: dto.toJson());
    } on DioException catch (e) {
      throw Exception(e.response?.data?.toString() ?? 'Failed to add item to cart');
    }
  }

  Future<void> removeFromCart(AddToCartDto dto) async {
    final token = await TokenStorage.getAccessToken();
    if (token == null) {
      throw Exception('Access token not found');
    }

    try {
      await ApiClient.dio.put('/requests/removeFromCart', data: dto.toJson());
    } on DioException catch (e) {
      throw Exception(e.response?.data?.toString() ?? 'Failed to remove item from cart');
    }
  }

  Future<void> checkout() async {
    final token = await TokenStorage.getAccessToken();
    if (token == null) {
      throw Exception('Access token not found');
    }

    try {
      await ApiClient.dio.put('/requests/checkoutMyCart');
    } on DioException catch (e) {
      throw Exception(e.response?.data?.toString() ?? 'Checkout failed');
    }
  }
}
