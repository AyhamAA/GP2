class AdminDonationRequestModel {
  final int requestId;
  final String itemName;
  final int quantity;
  final int userId;
  final String userName;
  final String userEmail;
  final String type;
  final DateTime? expirationDate;

  AdminDonationRequestModel({
    required this.requestId,
    required this.itemName,
    required this.quantity,
    required this.userId,
    required this.userName,
    required this.userEmail,
    required this.type,
    this.expirationDate,
  });

  factory AdminDonationRequestModel.fromJson(Map<String, dynamic> json) {
    return AdminDonationRequestModel(
      requestId: json['requestId'],
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
