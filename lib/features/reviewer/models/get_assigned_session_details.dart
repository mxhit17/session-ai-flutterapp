class GetAssignedSessionDetails {
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
  final Track? track;
  final Event event;
  final List<Review> reviews;
  final List<SessionSpeaker> sessionSpeakers;

  GetAssignedSessionDetails({
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
    required this.track,
    required this.event,
    required this.reviews,
    required this.sessionSpeakers,
  });

  factory GetAssignedSessionDetails.fromJson(Map<String, dynamic> json) {
    return GetAssignedSessionDetails(
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
      track: json['tracks'] != null ? Track.fromJson(json['tracks']) : null,
      event: Event.fromJson(json['events']),
      reviews:
          (json['reviews'] as List).map((e) => Review.fromJson(e)).toList(),
      sessionSpeakers:
          (json['session_speakers'] as List)
              .map((e) => SessionSpeaker.fromJson(e))
              .toList(),
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

class SessionSpeaker {
  final String sessionId;
  final String speakerId;
  final SpeakerProfile speakerProfile;

  SessionSpeaker({
    required this.sessionId,
    required this.speakerId,
    required this.speakerProfile,
  });

  factory SessionSpeaker.fromJson(Map<String, dynamic> json) {
    return SessionSpeaker(
      sessionId: json['session_id'],
      speakerId: json['speaker_id'],
      speakerProfile: SpeakerProfile.fromJson(json['speaker_profiles']),
    );
  }
}

class SpeakerProfile {
  final String id;
  final String userId;
  final String bio;
  final String organization;
  final String experienceLevel;
  final String? profilePhotoUrl;
  final User user;

  SpeakerProfile({
    required this.id,
    required this.userId,
    required this.bio,
    required this.organization,
    required this.experienceLevel,
    required this.profilePhotoUrl,
    required this.user,
  });

  factory SpeakerProfile.fromJson(Map<String, dynamic> json) {
    return SpeakerProfile(
      id: json['id'],
      userId: json['user_id'],
      bio: json['bio'],
      organization: json['organization'],
      experienceLevel: json['experience_level'],
      profilePhotoUrl: json['profile_photo_url'],
      user: User.fromJson(json['users']),
    );
  }
}

class User {
  final String id;
  final String fullName;
  final String email;
  final bool isActive;

  User({
    required this.id,
    required this.fullName,
    required this.email,
    required this.isActive,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      fullName: json['full_name'],
      email: json['email'],
      isActive: json['is_active'],
    );
  }
}
