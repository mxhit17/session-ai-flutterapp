class AllTracksResponse {
  final String id;
  final String eventId;
  final String name;
  final String description;

  AllTracksResponse({
    required this.id,
    required this.eventId,
    required this.name,
    required this.description,
  });

  factory AllTracksResponse.fromJson(Map<String, dynamic> json) {
    return AllTracksResponse(
      id: json['id'] as String,
      eventId: json['event_id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'event_id': eventId,
      'name': name,
      'description': description,
    };
  }

  static List<AllTracksResponse> listFromJson(List<dynamic> jsonList) {
    return jsonList
        .map((json) => AllTracksResponse.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}
