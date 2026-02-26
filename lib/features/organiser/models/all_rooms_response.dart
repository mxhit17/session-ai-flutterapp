class GetAllRoomsResponse {
  final String id;
  final String eventId;
  final String name;
  final int capacity;

  GetAllRoomsResponse({
    required this.id,
    required this.eventId,
    required this.name,
    required this.capacity,
  });

  factory GetAllRoomsResponse.fromJson(Map<String, dynamic> json) {
    return GetAllRoomsResponse(
      id: json['id'] as String,
      eventId: json['event_id'] as String,
      name: json['name'] as String,
      capacity: json['capacity'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'event_id': eventId, 'name': name, 'capacity': capacity};
  }

  static List<GetAllRoomsResponse> listFromJson(List<dynamic> jsonList) {
    return jsonList
        .map(
          (json) => GetAllRoomsResponse.fromJson(json as Map<String, dynamic>),
        )
        .toList();
  }
}
