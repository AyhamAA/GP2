class LoginResponse {
  final int userId;
  final String fullName;
  final String email;
  final int role;
  final String accessToken;
  final String refreshToken;

  LoginResponse({
    required this.userId,
    required this.fullName,
    required this.email,
    required this.role,
    required this.accessToken,
    required this.refreshToken,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      userId: json['userId'],
      fullName: json['fullName'],
      email: json['email'],
      role: json['role'],
      accessToken: json['accessToken'],
      refreshToken: json['refreshToken'],
    );
  }
}
