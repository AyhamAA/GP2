class DrProfile {
  final String fullName;
  final String email;
  final String? profileImageUrl;

  DrProfile({
    required this.fullName,
    required this.email,
    this.profileImageUrl,
  });

  factory DrProfile.fromJson(Map<String, dynamic> json) {
    return DrProfile(
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
