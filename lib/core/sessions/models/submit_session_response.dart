class SubmitSessionResponse {
  final String id;
  final String eventId;
  final String? trackId;
  final String title;
  final String abstractText;
  final String level;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;

  SubmitSessionResponse({
    required this.id,
    required this.eventId,
    required this.trackId,
    required this.title,
    required this.abstractText,
    required this.level,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
  });

  factory SubmitSessionResponse.fromJson(Map<String, dynamic> json) {
    return SubmitSessionResponse(
      id: json['id'] as String,
      eventId: json['event_id'] as String,
      trackId: json['track_id'] as String?,
      title: json['title'] as String,
      abstractText: json['abstract'] as String,
      level: json['level'] as String,
      status: json['status'] as String,
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
      'event_id': eventId,
      'track_id': trackId,
      'title': title,
      'abstract': abstractText,
      'level': level,
      'status': status,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'deleted_at': deletedAt?.toIso8601String(),
    };
  }

  SubmitSessionResponse copyWith({
    String? id,
    String? eventId,
    String? trackId,
    String? title,
    String? abstractText,
    String? level,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
  }) {
    return SubmitSessionResponse(
      id: id ?? this.id,
      eventId: eventId ?? this.eventId,
      trackId: trackId ?? this.trackId,
      title: title ?? this.title,
      abstractText: abstractText ?? this.abstractText,
      level: level ?? this.level,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }
}
