// auth_state.dart

class AuthState {
  final String? token;
  final List<String> roles;
  final String? activeRole;

  const AuthState({this.token, this.roles = const [], this.activeRole});

  bool get isLoggedIn => token != null;

  AuthState copyWith({String? token, List<String>? roles, String? activeRole}) {
    return AuthState(
      token: token ?? this.token,
      roles: roles ?? this.roles,
      activeRole: activeRole,
    );
  }

  factory AuthState.initial() => const AuthState();
}
