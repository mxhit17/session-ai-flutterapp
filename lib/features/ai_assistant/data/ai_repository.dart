import 'package:session.ai/features/ai_assistant/data/ai_api.dart';
import 'package:session.ai/features/ai_assistant/model/ai_request_model.dart';
import 'package:session.ai/features/ai_assistant/model/ai_response_model.dart';

class AiRepository {
  final AiApi _api = AiApi();

  Future<AiChatResponse> sendMessage(AiChatRequest request) async {
    try {
      return await _api.sendMessage(request);
    } catch (e) {
      throw Exception("Failed to get AI response");
    }
  }
}
