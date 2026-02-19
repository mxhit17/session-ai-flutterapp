class CreateEventResponse {
  final String id;
  final String title;
  final String? description;
  final DateTime startDate;
  final DateTime endDate;
  final String? location;
  final String timezone;
  final bool isPublic;
  final String createdBy;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;

  CreateEventResponse({
    required this.id,
    required this.title,
    this.description,
    required this.startDate,
    required this.endDate,
    this.location,
    required this.timezone,
    required this.isPublic,
    required this.createdBy,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });

  factory CreateEventResponse.fromJson(Map<String, dynamic> json) {
    return CreateEventResponse(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      startDate: DateTime.parse(json['start_date']),
      endDate: DateTime.parse(json['end_date']),
      location: json['location'],
      timezone: json['timezone'],
      isPublic: json['is_public'],
      createdBy: json['created_by'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      deletedAt:
          json['deleted_at'] != null
              ? DateTime.parse(json['deleted_at'])
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "title": title,
      "description": description,
      "start_date": startDate.toUtc().toIso8601String(),
      "end_date": endDate.toUtc().toIso8601String(),
      "location": location,
      "timezone": timezone,
      "is_public": isPublic,
      "created_by": createdBy,
      "created_at": createdAt.toUtc().toIso8601String(),
      "updated_at": updatedAt.toUtc().toIso8601String(),
      "deleted_at":
          deletedAt != null ? deletedAt!.toUtc().toIso8601String() : null,
    };
  }
}
