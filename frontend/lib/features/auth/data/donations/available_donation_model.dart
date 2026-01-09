class AvailableDonation {
  final int donationId;
  final String itemName;
  final String? itemDesc;
  final int quantity;
  final String? image1;
  final String? image2;
  final String? image3;
  final DateTime? expirationDate;
  final bool addedToCart;
  final DateTime creationDate;
  final String? strength; // For medicines

  AvailableDonation({
    required this.donationId,
    required this.itemName,
    this.itemDesc,
    required this.quantity,
    this.image1,
    this.image2,
    this.image3,
    this.expirationDate,
    required this.addedToCart,
    required this.creationDate,
    this.strength,
  });

  factory AvailableDonation.fromJson(Map<String, dynamic> json) {
    return AvailableDonation(
      donationId: json['donationId'] ?? 0,
      itemName: json['itemName'] ?? '',
      itemDesc: json['itemDesc'],
      quantity: json['quantity'] ?? 0,
      image1: json['image1'],
      image2: json['image2'],
      image3: json['image3'],
      expirationDate: json['expirationDate'] != null && json['expirationDate'].toString().isNotEmpty
          ? DateTime.tryParse(json['expirationDate'].toString())
          : null,
      addedToCart: json['addedToCart'] ?? false,
      creationDate: json['creationDate'] != null && json['creationDate'].toString().isNotEmpty
          ? (DateTime.tryParse(json['creationDate'].toString()) ?? DateTime.now())
          : DateTime.now(),
      strength: json['strength'],
    );
  }

  String get displayImage {
    if (image1 != null && image1!.isNotEmpty) return image1!;
    if (image2 != null && image2!.isNotEmpty) return image2!;
    if (image3 != null && image3!.isNotEmpty) return image3!;
    return '';
  }

  String get formattedExpiryDate {
    if (expirationDate == null) return 'N/A';
    final date = expirationDate!;
    return '${date.day}/${date.month}/${date.year}';
  }

  bool get isExpiringSoon {
    if (expirationDate == null) return false;
    final now = DateTime.now();
    final difference = expirationDate!.difference(now).inDays;
    return difference >= 0 && difference <= 30;
  }
}

