import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/storage/token_storage.dart';
import 'add_to_cart_dto.dart';
import 'cart_response_model.dart';

class CartService {
  final String baseUrl = 'http://10.0.2.2:5149/api/Requests';

  Future<CartResponseModel> getMyCart() async {
    print('🟡 getMyCart called');

    final token = await TokenStorage.getAccessToken();
    print('🟡 token: $token');

    if (token == null) {
      throw Exception('Access token not found');
    }

    final url = '$baseUrl/myCart';
    print('🟡 URL: $url');

    late http.Response response;
    try {
      response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
    } catch (e) {
      print('🔴 NETWORK ERROR: $e');
      rethrow;
    }

    print('🟢 STATUS: ${response.statusCode}');
    print('🟢 BODY: ${response.body}');

    if (response.statusCode == 200) {
      return CartResponseModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(
        'Failed to load cart (${response.statusCode})\n${response.body}',
      );
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

    final response = await http.put(
      Uri.parse('$baseUrl/$endpoint'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(dto.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Failed to add item to cart (${response.statusCode})',
      );
    }
  }

  Future<void> removeFromCart(AddToCartDto dto) async {
    final token = await TokenStorage.getAccessToken();
    if (token == null) {
      throw Exception('Access token not found');
    }

    final response = await http.put(
      Uri.parse('$baseUrl/removeFromCart'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(dto.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Failed to remove item from cart (${response.statusCode})',
      );
    }
  }

  Future<void> checkout() async {
    final token = await TokenStorage.getAccessToken();
    if (token == null) {
      throw Exception('Access token not found');
    }

    final response = await http.put(
      Uri.parse('$baseUrl/checkoutMyCart'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Checkout failed (${response.statusCode})',
      );
    }
  }
}
