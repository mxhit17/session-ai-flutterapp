import 'package:dio/dio.dart';
import 'package:session.ai/features/ai_assistant/model/ai_request_model.dart';
import 'package:session.ai/features/ai_assistant/model/ai_response_model.dart';
import 'package:session.ai/injection_container.dart';
import 'package:session.ai/utils/constants/api_constants.dart';
import 'package:session.ai/utils/network/dio_client.dart';

class AiApi {
  final Dio _client = sl<DioClient>().instance;

  Future<AiChatResponse> sendMessage(AiChatRequest request) async {
    final response = await _client.post(
      ApiConstants.aiChat,
      data: request.toJson(),
    );

    return AiChatResponse.fromJson(response.data);
  }
}
