import 'cart_item_model.dart';

class CartResponseModel {
  final List<CartItemModel> equipment;
  final List<CartItemModel> medicine;

  CartResponseModel({
    required this.equipment,
    required this.medicine,
  });

  factory CartResponseModel.fromJson(Map<String, dynamic> json) {
    return CartResponseModel(
      equipment: (json['equipment'] as List)
          .map((e) => CartItemModel.fromJson(e))
          .toList(),
      medicine: (json['medicine'] as List)
          .map((e) => CartItemModel.fromJson(e))
          .toList(),
    );
  }
}
