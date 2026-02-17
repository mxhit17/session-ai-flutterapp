class MySessionsResponse {
  final String id;
  final String eventId;
  final String? trackId;
  final String title;
  final String abstract;
  final String level;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final Event event;
  final List<Review> reviews;

  MySessionsResponse({
    required this.id,
    required this.eventId,
    required this.trackId,
    required this.title,
    required this.abstract,
    required this.level,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
    required this.event,
    required this.reviews,
  });

  factory MySessionsResponse.fromJson(Map<String, dynamic> json) {
    return MySessionsResponse(
      id: json['id'],
      eventId: json['event_id'],
      trackId: json['track_id'],
      title: json['title'],
      abstract: json['abstract'],
      level: json['level'],
      status: json['status'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      deletedAt:
          json['deleted_at'] != null
              ? DateTime.parse(json['deleted_at'])
              : null,
      event: Event.fromJson(json['events']),
      reviews:
          (json['reviews'] as List).map((e) => Review.fromJson(e)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'event_id': eventId,
      'track_id': trackId,
      'title': title,
      'abstract': abstract,
      'level': level,
      'status': status,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'deleted_at': deletedAt?.toIso8601String(),
      'events': event.toJson(),
      'reviews': reviews.map((e) => e.toJson()).toList(),
    };
  }
}

class Event {
  final String id;
  final String title;
  final String description;
  final DateTime startDate;
  final DateTime endDate;
  final String location;
  final String timezone;
  final bool isPublic;
  final String? createdBy;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;

  Event({
    required this.id,
    required this.title,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.location,
    required this.timezone,
    required this.isPublic,
    required this.createdBy,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
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
      'id': id,
      'title': title,
      'description': description,
      'start_date': startDate.toIso8601String(),
      'end_date': endDate.toIso8601String(),
      'location': location,
      'timezone': timezone,
      'is_public': isPublic,
      'created_by': createdBy,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'deleted_at': deletedAt?.toIso8601String(),
    };
  }
}

/// Empty for now since your API returns []
/// Add fields later when backend provides them
class Review {
  Review();

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review();
  }

  Map<String, dynamic> toJson() {
    return {};
  }
}
