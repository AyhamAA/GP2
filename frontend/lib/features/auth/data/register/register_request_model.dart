class RegisterRequest {
  final String fullName;
  final String email;
  final String password;
  final String confirmedPassword;

  RegisterRequest({
    required this.fullName,
    required this.email,
    required this.password,
    required this.confirmedPassword,
  });

  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'email': email,
      'password': password,
      'confirmedPassword': confirmedPassword,
    };
  }
}
