class AiChatRequest {
  final String message;
  final List<Map<String, dynamic>> history;

  AiChatRequest({required this.message, required this.history});

  Map<String, dynamic> toJson() {
    return {"message": message, "history": history};
  }
}
