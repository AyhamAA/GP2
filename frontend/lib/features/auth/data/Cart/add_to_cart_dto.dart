class AddToCartDto {
  final int donationId;
  final String itemName;
  final int quantity;
  final int cartType; // 1 = Equipment, 2 = Medicine

  AddToCartDto({
    required this.donationId,
    required this.itemName,
    required this.quantity,
    required this.cartType,
  });

  Map<String, dynamic> toJson() {
    return {
      "donationId": donationId,
      "itemName": itemName,
      "quantity": quantity,
      "cartType": cartType,
    };
  }
}
