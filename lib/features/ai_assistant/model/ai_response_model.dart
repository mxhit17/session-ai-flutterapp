class AiChatResponse {
  final String role;
  final String content;
  final List<dynamic> toolCalls;
  final List<AiEvent> events;

  AiChatResponse({
    required this.role,
    required this.content,
    required this.toolCalls,
    required this.events,
  });

  factory AiChatResponse.fromJson(Map<String, dynamic> json) {
    return AiChatResponse(
      role: json["role"] ?? "",

      content: json["content"] ?? "",

      toolCalls: json["tool_calls"] ?? [],

      events:
          json["events"] != null
              ? List<AiEvent>.from(
                json["events"].map((x) => AiEvent.fromJson(x)),
              )
              : [],
    );
  }
}

class AiEvent {
  final String id;
  final String title;
  final String? description;
  final String? location;

  final String? startDate;
  final String? endDate;

  final String? cfpStart;
  final String? cfpEnd;

  final int matchScore;

  AiEvent({
    required this.id,
    required this.title,
    this.description,
    this.location,
    this.startDate,
    this.endDate,
    this.cfpStart,
    this.cfpEnd,
    required this.matchScore,
  });

  factory AiEvent.fromJson(Map<String, dynamic> json) {
    return AiEvent(
      id: json["id"] ?? "",

      title: json["title"] ?? "",

      description: json["description"],

      location: json["location"],

      startDate: json["startDate"],

      endDate: json["endDate"],

      cfpStart: json["cfpStart"],

      cfpEnd: json["cfpEnd"],

      matchScore: (json["matchScore"] ?? 0) is int ? json["matchScore"] : 0,
    );
  }
}
