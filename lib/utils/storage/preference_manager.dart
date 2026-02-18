import 'package:shared_preferences/shared_preferences.dart';

class PreferencesManager {
  // keys for storing data
  static const ACCESS_TOKEN = "access_token";
  static const REFRESH_TOKEN = "refresh_token";
  static const USER_ID = "userId";
  static const USER_NAME = "user_name";
  static const USER_ROLES = "user_roles"; // changed
  static const ACTIVE_ROLE = "active_role";

  static final PreferencesManager _instance = PreferencesManager._internal();
  late final SharedPreferences _prefs;

  PreferencesManager._internal();

  static Future<PreferencesManager> create(SharedPreferences prefs) async {
    _instance._prefs = prefs;
    return _instance;
  }

  // ---------------- Tokens ----------------

  Future<void> setAccessToken(String tkn) async {
    await _prefs.setString(ACCESS_TOKEN, tkn);
  }

  Future<void> setRefreshToken(String tkn) async {
    await _prefs.setString(REFRESH_TOKEN, tkn);
  }

  String? getAccessToken() {
    return _prefs.getString(ACCESS_TOKEN);
  }

  String? getRefreshToken() {
    return _prefs.getString(REFRESH_TOKEN);
  }

  // ---------------- User ----------------

  Future<void> setUserId(String userId) async {
    await _prefs.setString(USER_ID, userId);
  }

  String? getUserId() {
    return _prefs.getString(USER_ID);
  }

  Future<void> setUserName(String userName) async {
    await _prefs.setString(USER_NAME, userName);
  }

  String? getUserName() {
    return _prefs.getString(USER_NAME);
  }

  // ---------------- Roles (NEW) ----------------

  Future<void> setUserRoles(List<String> roles) async {
    await _prefs.setStringList(USER_ROLES, roles);
  }

  List<String> getUserRoles() {
    return _prefs.getStringList(USER_ROLES) ?? [];
  }

  Future<void> clear(String key) async {
    await _prefs.remove(key);
  }

  Future<void> setActiveRole(String role) async {
    await _prefs.setString(ACTIVE_ROLE, role);
  }

  String? getActiveRole() {
    return _prefs.getString(ACTIVE_ROLE);
  }

  Future<void> clearActiveRole() async {
    await _prefs.remove(ACTIVE_ROLE);
  }

  Future<void> clearAllUserData() async {
    await _prefs.remove(ACCESS_TOKEN);
    await _prefs.remove(REFRESH_TOKEN);
    await _prefs.remove(USER_ID);
    await _prefs.remove(USER_NAME);
    await _prefs.remove(USER_ROLES);
    await _prefs.remove(ACTIVE_ROLE);
  }

  Future<void> clearAll() async {
    await _prefs.clear();
  }
}
