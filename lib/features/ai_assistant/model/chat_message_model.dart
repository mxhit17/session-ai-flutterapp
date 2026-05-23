import 'package:session.ai/features/ai_assistant/model/ai_response_model.dart';

class ChatMessage {
  final bool isUser;
  final String message;
  final List<AiEvent> events;

  ChatMessage({
    required this.isUser,
    required this.message,
    this.events = const [],
  });
}
