class RegisterResponse {
  final String token;
  final RegisterUser user;

  RegisterResponse({required this.token, required this.user});

  factory RegisterResponse.fromJson(Map<String, dynamic> json) {
    return RegisterResponse(
      token: json['token'] as String,
      user: RegisterUser.fromJson(json['user']),
    );
  }

  Map<String, dynamic> toJson() {
    return {'token': token, 'user': user.toJson()};
  }
}

class RegisterUser {
  final String id;
  final String fullName;
  final String email;
  final String role;
  final DateTime createdAt;

  RegisterUser({
    required this.id,
    required this.fullName,
    required this.email,
    required this.role,
    required this.createdAt,
  });

  factory RegisterUser.fromJson(Map<String, dynamic> json) {
    return RegisterUser(
      id: json['id'],
      fullName: json['full_name'],
      email: json['email'],
      role: json['role'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': fullName,
      'email': email,
      'role': role,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
