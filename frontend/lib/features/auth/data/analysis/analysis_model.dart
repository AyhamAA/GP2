class AnalysisModel {
  final int users;
  final int donations;
  final int requests;
  final int userRequests;

  AnalysisModel({
    required this.users,
    required this.donations,
    required this.requests,
    required this.userRequests,
  });
  factory AnalysisModel.fromJson(Map<String, dynamic> json) {
    return AnalysisModel(
      users: json['users'],
      donations: json['donations'],
      requests: json['requests'],
      userRequests: json['userRequests'],
    );
  }
}
