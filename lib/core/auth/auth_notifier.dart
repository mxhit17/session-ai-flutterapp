import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:session.ai/injection_container.dart';
import 'package:session.ai/utils/storage/preference_manager.dart';
import 'auth_state.dart';

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(AuthState.initial()) {
    _init();
  }

  Future<void> _init() async {
    await loadFromStorage();
  }

  Future<void> loadFromStorage() async {
    final prefs = sl<PreferencesManager>();

    final token = prefs.getAccessToken();
    final roles = prefs.getUserRoles();
    final activeRole = prefs.getActiveRole();

    // CRITICAL FIX
    // If already logged in during this session, don't overwrite state
    if (state.token != null) return;

    if (token != null && roles != null && roles.isNotEmpty) {
      state = AuthState(
        token: token,
        roles: roles,
        activeRole: activeRole ?? (roles.length == 1 ? roles.first : null),
      );
    }
  }

  Future<void> login(String token, List<String> roles) async {
    print("AuthNotifier login triggered");

    final prefs = sl<PreferencesManager>();

    await prefs.setAccessToken(token);
    await prefs.setUserRoles(roles);

    state = AuthState(
      token: token,
      roles: roles,
      activeRole: roles.length == 1 ? roles.first : null,
    );
  }

  Future<void> switchRole(String? role) async {
    final prefs = sl<PreferencesManager>();

    // If role is null → return to Role Selection
    if (role == null) {
      await prefs.clearActiveRole();
      state = state.copyWith(activeRole: null);
      return;
    }

    // If role is invalid → ignore
    if (!state.roles.contains(role)) return;

    await prefs.setActiveRole(role);

    state = state.copyWith(activeRole: role);
  }

  Future<void> logout() async {
    final prefs = sl<PreferencesManager>();
    await prefs.clearAllUserData();
    state = AuthState.initial();
  }
}
