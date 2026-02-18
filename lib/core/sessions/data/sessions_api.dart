import 'package:dio/dio.dart';
import 'package:session.ai/core/sessions/models/submit_session_response.dart';
import 'package:session.ai/injection_container.dart';
import 'package:session.ai/utils/constants/api_constants.dart';
import 'package:session.ai/utils/network/dio_client.dart';

class SessionsApi {
  final Dio _client = sl<DioClient>().instance;

  Future<SubmitSessionResponse> submitSession(
    Map<String, dynamic> sessionMap,
  ) async {
    final response = await _client.post(
      ApiConstants.submitSession,
      data: sessionMap,
    );

    return SubmitSessionResponse.fromJson(response.data);
  }
}
