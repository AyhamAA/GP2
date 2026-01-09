class AdminProfile {
  final String fullName;
  final String email;
  final String? profileImageUrl;

  AdminProfile({
    required this.fullName,
    required this.email,
    this.profileImageUrl,
  });

  factory AdminProfile.fromJson(Map<String, dynamic> json) {
    return AdminProfile(
      fullName: json['fullName'],
      email: json['email'],
      profileImageUrl: json['getProfileImage'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'email': email,
    };
  }
}
