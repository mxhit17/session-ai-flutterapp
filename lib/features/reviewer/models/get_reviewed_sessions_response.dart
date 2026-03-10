class ReviewedSessionModel {
  final String id;
  final String sessionId;
  final String reviewerId;
  final DateTime assignedAt;
  final Session sessions;

  ReviewedSessionModel({
    required this.id,
    required this.sessionId,
    required this.reviewerId,
    required this.assignedAt,
    required this.sessions,
  });

  factory ReviewedSessionModel.fromJson(Map<String, dynamic> json) {
    return ReviewedSessionModel(
      id: json['id'],
      sessionId: json['session_id'],
      reviewerId: json['reviewer_id'],
      assignedAt: DateTime.parse(json['assigned_at']),
      sessions: Session.fromJson(json['sessions']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "session_id": sessionId,
      "reviewer_id": reviewerId,
      "assigned_at": assignedAt.toIso8601String(),
      "sessions": sessions.toJson(),
    };
  }
}

class Session {
  final String id;
  final String eventId;
  final String? trackId;
  final String title;
  final String abstract;
  final String level;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Event events;
  final dynamic tracks;
  final List<Review> reviews;

  Session({
    required this.id,
    required this.eventId,
    this.trackId,
    required this.title,
    required this.abstract,
    required this.level,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.events,
    this.tracks,
    required this.reviews,
  });

  factory Session.fromJson(Map<String, dynamic> json) {
    return Session(
      id: json['id'],
      eventId: json['event_id'],
      trackId: json['track_id'],
      title: json['title'],
      abstract: json['abstract'],
      level: json['level'],
      status: json['status'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      events: Event.fromJson(json['events']),
      tracks: json['tracks'],
      reviews:
          (json['reviews'] as List).map((e) => Review.fromJson(e)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "event_id": eventId,
      "track_id": trackId,
      "title": title,
      "abstract": abstract,
      "level": level,
      "status": status,
      "created_at": createdAt.toIso8601String(),
      "updated_at": updatedAt.toIso8601String(),
      "events": events.toJson(),
      "tracks": tracks,
      "reviews": reviews.map((e) => e.toJson()).toList(),
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
  final String createdBy;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool cfpOpen;
  final DateTime cfpStart;
  final DateTime cfpEnd;
  final int reviewersPerSession;

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
    required this.cfpOpen,
    required this.cfpStart,
    required this.cfpEnd,
    required this.reviewersPerSession,
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
      cfpOpen: json['cfp_open'],
      cfpStart: DateTime.parse(json['cfp_start']),
      cfpEnd: DateTime.parse(json['cfp_end']),
      reviewersPerSession: json['reviewers_per_session'],
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
      "created_by": createdBy,
      "created_at": createdAt.toIso8601String(),
      "updated_at": updatedAt.toIso8601String(),
      "cfp_open": cfpOpen,
      "cfp_start": cfpStart.toIso8601String(),
      "cfp_end": cfpEnd.toIso8601String(),
      "reviewers_per_session": reviewersPerSession,
    };
  }
}

class Review {
  final String id;
  final String sessionId;
  final String reviewerId;
  final int score;
  final String comment;
  final String? aiAnalysis;
  final bool isAiGenerated;
  final DateTime createdAt;

  Review({
    required this.id,
    required this.sessionId,
    required this.reviewerId,
    required this.score,
    required this.comment,
    this.aiAnalysis,
    required this.isAiGenerated,
    required this.createdAt,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'],
      sessionId: json['session_id'],
      reviewerId: json['reviewer_id'],
      score: json['score'],
      comment: json['comment'],
      aiAnalysis: json['ai_analysis'],
      isAiGenerated: json['is_ai_generated'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "session_id": sessionId,
      "reviewer_id": reviewerId,
      "score": score,
      "comment": comment,
      "ai_analysis": aiAnalysis,
      "is_ai_generated": isAiGenerated,
      "created_at": createdAt.toIso8601String(),
    };
  }
}
