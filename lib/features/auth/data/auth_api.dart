import 'package:dio/dio.dart';
import 'package:session.ai/features/auth/models/register_response_model.dart';
import 'package:session.ai/features/auth/models/sign_in_model.dart';
import 'package:session.ai/injection_container.dart';
import 'package:session.ai/utils/constants/api_constants.dart';
import 'package:session.ai/utils/network/dio_client.dart';

class AuthApi {
  final Dio _client = sl<DioClient>().instance;

  Future<SignInResponse> signIn(Map<String, dynamic> map) async {
    final response = await _client.post(ApiConstants.login, data: map);

    return SignInResponse.fromJson(response.data);
  }

  Future<RegisterResponse> register(Map<String, dynamic> map) async {
    final response = await _client.post(
      ApiConstants.register, // make sure this path matches backend
      data: map,
    );

    return RegisterResponse.fromJson(response.data);
  }
}
