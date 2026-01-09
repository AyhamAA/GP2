class AdminTakeDonationRequestModel {
  final int donationId;
  final String itemName;
  final int quantity;
  final int userId;
  final String userName;
  final String userEmail;
  final String type;
  final DateTime? expirationDate;

  AdminTakeDonationRequestModel({
    required this.donationId,
    required this.itemName,
    required this.quantity,
    required this.userId,
    required this.userName,
    required this.userEmail,
    required this.type,
    this.expirationDate,
  });

  factory AdminTakeDonationRequestModel.fromJson(Map<String, dynamic> json) {
    return AdminTakeDonationRequestModel(
      donationId: json['donationId'],
      itemName: json['itemName'],
      quantity: json['quantity'],
      userId: json['userId'],
      userName: json['userName'],
      userEmail: json['userEmail'],
      type: json['type'],
      expirationDate: json['expirationDate'] != null
          ? DateTime.parse(json['expirationDate'])
          : null,
    );
  }
}
