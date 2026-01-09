class RegisterResponse {
  final int userId;
  final String fullName;
  final String email;
  final int role;

  RegisterResponse({
    required this.userId,
    required this.fullName,
    required this.email,
    required this.role,
  });

  factory RegisterResponse.fromJson(Map<String, dynamic> json) {
    return RegisterResponse(
      userId: json['userId'],
      fullName: json['fullName'],
      email: json['email'],
      role: json['role'],
    );
  }
}
