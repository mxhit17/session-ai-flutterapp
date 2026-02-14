import 'package:session.ai/features/auth/data/auth_api.dart';
import 'package:session.ai/features/auth/models/register_response_model.dart';
import 'package:session.ai/features/auth/models/sign_in_model.dart';

class AuthRepository {
  final AuthApi _api = AuthApi();

  Future<SignInResponse> signIn(Map<String, dynamic> map) async {
    try {
      return await _api.signIn(map);
    } catch (e) {
      throw Exception("Failed to sign in.");
    }
  }

  Future<RegisterResponse> register(Map<String, dynamic> map) async {
    try {
      return await _api.register(map);
    } catch (e) {
      throw Exception("Failed to register.");
    }
  }
}
