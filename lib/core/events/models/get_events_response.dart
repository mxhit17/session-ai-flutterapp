class GetEventsResponse {
  final String id;
  final String title;
  final String description;
  final DateTime startDate;
  final DateTime endDate;
  final String location;
  final String timezone;
  final bool isPublic;
  final DateTime createdAt;

  GetEventsResponse({
    required this.id,
    required this.title,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.location,
    required this.timezone,
    required this.isPublic,
    required this.createdAt,
  });

  factory GetEventsResponse.fromJson(Map<String, dynamic> json) {
    return GetEventsResponse(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      startDate: DateTime.parse(json['start_date']),
      endDate: DateTime.parse(json['end_date']),
      location: json['location'],
      timezone: json['timezone'],
      isPublic: json['is_public'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "title": title,
      "description": description,
      "start_date": startDate.toIso8601String(),
      "end_date": endDate.toIso8601String(),
      "location": location,
      "timezone": timezone,
      "is_public": isPublic,
      "created_at": createdAt.toIso8601String(),
    };
  }
}
