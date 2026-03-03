class GetUsersModel {
  final String id;
  final String fullName;
  final String email;
  final List<String> roles;

  GetUsersModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.roles,
  });

  factory GetUsersModel.fromJson(Map<String, dynamic> json) {
    return GetUsersModel(
      id: json['id'] as String,
      fullName: json['full_name'] as String,
      email: json['email'] as String,
      roles: List<String>.from(json['roles'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'full_name': fullName, 'email': email, 'roles': roles};
  }

  /// Optional helper methods (very useful in UI)

  bool get isReviewer => roles.contains('REVIEWER');
  bool get isSpeaker => roles.contains('SPEAKER');
  bool get isOrganiser => roles.contains('ORGANISER');
}
