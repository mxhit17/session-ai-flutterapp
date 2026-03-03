class GetAssignedSessionsResponse {
  final List<ReviewerAssignment> assignments;

  GetAssignedSessionsResponse({required this.assignments});

  factory GetAssignedSessionsResponse.fromJson(List<dynamic> json) {
    return GetAssignedSessionsResponse(
      assignments: json.map((e) => ReviewerAssignment.fromJson(e)).toList(),
    );
  }
}

class ReviewerAssignment {
  final String id;
  final String sessionId;
  final String reviewerId;
  final DateTime assignedAt;
  final Session session;

  ReviewerAssignment({
    required this.id,
    required this.sessionId,
    required this.reviewerId,
    required this.assignedAt,
    required this.session,
  });

  factory ReviewerAssignment.fromJson(Map<String, dynamic> json) {
    return ReviewerAssignment(
      id: json['id'],
      sessionId: json['session_id'],
      reviewerId: json['reviewer_id'],
      assignedAt: DateTime.parse(json['assigned_at']),
      session: Session.fromJson(json['sessions']),
    );
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
  final Event event;
  final Track? track;
  final List<Review> reviews;

  Session({
    required this.id,
    required this.eventId,
    required this.trackId,
    required this.title,
    required this.abstract,
    required this.level,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.event,
    required this.track,
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
      event: Event.fromJson(json['events']),
      track: json['tracks'] != null ? Track.fromJson(json['tracks']) : null,
      reviews:
          (json['reviews'] as List).map((e) => Review.fromJson(e)).toList(),
    );
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
  final bool cfpOpen;
  final DateTime? cfpStart;
  final DateTime? cfpEnd;
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
      cfpOpen: json['cfp_open'],
      cfpStart:
          json['cfp_start'] != null ? DateTime.parse(json['cfp_start']) : null,
      cfpEnd: json['cfp_end'] != null ? DateTime.parse(json['cfp_end']) : null,
      reviewersPerSession: json['reviewers_per_session'],
    );
  }
}

class Track {
  final String id;
  final String name;

  Track({required this.id, required this.name});

  factory Track.fromJson(Map<String, dynamic> json) {
    return Track(id: json['id'], name: json['name']);
  }
}

class Review {
  final String id;
  final String sessionId;
  final String? reviewerId;
  final int score;
  final String comment;
  final AiAnalysis? aiAnalysis;
  final bool isAiGenerated;
  final DateTime createdAt;

  Review({
    required this.id,
    required this.sessionId,
    required this.reviewerId,
    required this.score,
    required this.comment,
    required this.aiAnalysis,
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
      aiAnalysis:
          json['ai_analysis'] != null
              ? AiAnalysis.fromJson(json['ai_analysis'])
              : null,
      isAiGenerated: json['is_ai_generated'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}

class AiAnalysis {
  final int depth;
  final int clarity;
  final int novelty;
  final String reasoning;
  final double relevance;
  final double overallScore;

  AiAnalysis({
    required this.depth,
    required this.clarity,
    required this.novelty,
    required this.reasoning,
    required this.relevance,
    required this.overallScore,
  });

  factory AiAnalysis.fromJson(Map<String, dynamic> json) {
    return AiAnalysis(
      depth: json['depth'],
      clarity: json['clarity'],
      novelty: json['novelty'],
      reasoning: json['reasoning'],
      relevance: (json['relevance'] as num).toDouble(),
      overallScore: (json['overall_score'] as num).toDouble(),
    );
  }
}
