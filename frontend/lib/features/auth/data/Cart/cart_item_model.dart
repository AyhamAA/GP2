class CartItemModel {
  final int donationId;
  final String itemName;
  final int quantity;
  final int cartType; // 1 = Equipment, 2 = Medicine

  CartItemModel({
    required this.donationId,
    required this.itemName,
    required this.quantity,
    required this.cartType,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      donationId: json['donationId'],
      itemName: json['itemName'],
      quantity: json['quantity'],
      cartType: json['cartType'],
    );
  }
}
