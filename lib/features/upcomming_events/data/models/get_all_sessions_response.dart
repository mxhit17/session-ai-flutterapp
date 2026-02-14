class GetAllSessionsResponse {
  final List<Session> sessions;
  final Pagination pagination;

  GetAllSessionsResponse({required this.sessions, required this.pagination});

  factory GetAllSessionsResponse.fromJson(Map<String, dynamic> json) {
    return GetAllSessionsResponse(
      sessions:
          (json['sessions'] as List<dynamic>?)
              ?.map((e) => Session.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      pagination: Pagination.fromJson(
        json['pagination'] as Map<String, dynamic>,
      ),
    );
  }

  Map<String, dynamic> toJson() => {
    'sessions': sessions.map((e) => e.toJson()).toList(),
    'pagination': pagination.toJson(),
  };
}

class Session {
  final String id;
  final String title;
  final String description;
  final String? speakerId;
  final String? categoryId;
  final String startTime;
  final String endTime;
  final String? location;
  final int? capacity;
  final String status;
  final String? meetingUrl;
  final String? materialsUrl;
  final List<dynamic> tags;
  final bool isFeatured;
  final String createdBy;
  final String createdAt;
  final String updatedAt;
  final String? callForSpeakerStartDate;
  final String? callForSpeakerEndDate;

  // New / additional fields from the JSON
  final bool accommodationCovered;
  final bool travelCovered;
  final bool conferenceFeeCovered;
  final String? mode;
  final String? twitter;
  final String? linkedin;
  final String? facebook;
  final String? instagram;
  final String? eventWebsite;
  final String? eventLogoUrl;
  final List<dynamic> eventCategories;
  final List<dynamic> eventTopics;

  final String? sessionTitle; // note: JSON has these as null in your example
  final String? sessionDescription;
  final String? sessionFormat;
  final String? language;
  final String? level;
  final String? track;

  // speaker requirement flags
  final bool requireSpeakerPhoto;
  final bool requireSpeakerTwitter;
  final bool requireSpeakerLinkedin;
  final bool requireSpeakerFacebook;
  final bool requireSpeakerInstagram;
  final bool requireSpeakerBlog;
  final bool requireSpeakerCompany;
  final bool requireSpeakerShirtSize;

  // nested objects
  final dynamic
  speakers; // could be List<Speaker> or object; kept dynamic to match varied payloads
  final Category? categories;
  final List<Registration> registrations;

  Session({
    required this.id,
    required this.title,
    required this.description,
    this.speakerId,
    this.categoryId,
    required this.startTime,
    required this.endTime,
    this.location,
    this.capacity,
    required this.status,
    this.meetingUrl,
    this.materialsUrl,
    required this.tags,
    required this.isFeatured,
    required this.createdBy,
    required this.createdAt,
    required this.updatedAt,
    this.callForSpeakerStartDate,
    this.callForSpeakerEndDate,
    required this.accommodationCovered,
    required this.travelCovered,
    required this.conferenceFeeCovered,
    this.mode,
    this.twitter,
    this.linkedin,
    this.facebook,
    this.instagram,
    this.eventWebsite,
    this.eventLogoUrl,
    required this.eventCategories,
    required this.eventTopics,
    this.sessionTitle,
    this.sessionDescription,
    this.sessionFormat,
    this.language,
    this.level,
    this.track,
    required this.requireSpeakerPhoto,
    required this.requireSpeakerTwitter,
    required this.requireSpeakerLinkedin,
    required this.requireSpeakerFacebook,
    required this.requireSpeakerInstagram,
    required this.requireSpeakerBlog,
    required this.requireSpeakerCompany,
    required this.requireSpeakerShirtSize,
    this.speakers,
    this.categories,
    required this.registrations,
  });

  factory Session.fromJson(Map<String, dynamic> json) {
    return Session(
      id: json['id'] as String,
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      speakerId: json['speaker_id'] as String?,
      categoryId: json['category_id'] as String?,
      startTime: json['start_time'] as String? ?? '',
      endTime: json['end_time'] as String? ?? '',
      location: json['location'] as String?,
      capacity:
          (json['capacity'] is int)
              ? json['capacity'] as int
              : (json['capacity'] == null
                  ? null
                  : int.tryParse(json['capacity'].toString())),
      status: json['status'] as String? ?? '',
      meetingUrl: json['meeting_url'] as String?,
      materialsUrl: json['materials_url'] as String?,
      tags: (json['tags'] as List<dynamic>?) ?? [],
      isFeatured: json['is_featured'] as bool? ?? false,
      createdBy: json['created_by'] as String? ?? '',
      createdAt: json['created_at'] as String? ?? '',
      updatedAt: json['updated_at'] as String? ?? '',
      callForSpeakerStartDate: json['call_for_speaker_start_date'] as String?,
      callForSpeakerEndDate: json['call_for_speaker_end_date'] as String?,
      accommodationCovered: json['accommodation_covered'] as bool? ?? false,
      travelCovered: json['travel_covered'] as bool? ?? false,
      conferenceFeeCovered: json['conference_fee_covered'] as bool? ?? false,
      mode: json['mode'] as String?,
      twitter: json['twitter'] as String?,
      linkedin: json['linkedin'] as String?,
      facebook: json['facebook'] as String?,
      instagram: json['instagram'] as String?,
      eventWebsite: json['event_website'] as String?,
      eventLogoUrl: json['event_logo_url'] as String?,
      eventCategories: (json['event_categories'] as List<dynamic>?) ?? [],
      eventTopics: (json['event_topics'] as List<dynamic>?) ?? [],
      sessionTitle: json['session_title'] as String?,
      sessionDescription: json['session_description'] as String?,
      sessionFormat: json['session_format'] as String?,
      language: json['language'] as String?,
      level: json['level'] as String?,
      track: json['track'] as String?,
      requireSpeakerPhoto: json['require_speaker_photo'] as bool? ?? false,
      requireSpeakerTwitter: json['require_speaker_twitter'] as bool? ?? false,
      requireSpeakerLinkedin:
          json['require_speaker_linkedin'] as bool? ?? false,
      requireSpeakerFacebook:
          json['require_speaker_facebook'] as bool? ?? false,
      requireSpeakerInstagram:
          json['require_speaker_instagram'] as bool? ?? false,
      requireSpeakerBlog: json['require_speaker_blog'] as bool? ?? false,
      requireSpeakerCompany: json['require_speaker_company'] as bool? ?? false,
      requireSpeakerShirtSize:
          json['require_speaker_shirt_size'] as bool? ?? false,
      speakers: json['speakers'],
      categories:
          json['categories'] != null
              ? Category.fromJson(json['categories'] as Map<String, dynamic>)
              : null,
      registrations:
          (json['registrations'] as List<dynamic>?)
              ?.map((e) => Registration.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'speaker_id': speakerId,
    'category_id': categoryId,
    'start_time': startTime,
    'end_time': endTime,
    'location': location,
    'capacity': capacity,
    'status': status,
    'meeting_url': meetingUrl,
    'materials_url': materialsUrl,
    'tags': tags,
    'is_featured': isFeatured,
    'created_by': createdBy,
    'created_at': createdAt,
    'updated_at': updatedAt,
    'call_for_speaker_start_date': callForSpeakerStartDate,
    'call_for_speaker_end_date': callForSpeakerEndDate,
    'accommodation_covered': accommodationCovered,
    'travel_covered': travelCovered,
    'conference_fee_covered': conferenceFeeCovered,
    'mode': mode,
    'twitter': twitter,
    'linkedin': linkedin,
    'facebook': facebook,
    'instagram': instagram,
    'event_website': eventWebsite,
    'event_logo_url': eventLogoUrl,
    'event_categories': eventCategories,
    'event_topics': eventTopics,
    'session_title': sessionTitle,
    'session_description': sessionDescription,
    'session_format': sessionFormat,
    'language': language,
    'level': level,
    'track': track,
    'require_speaker_photo': requireSpeakerPhoto,
    'require_speaker_twitter': requireSpeakerTwitter,
    'require_speaker_linkedin': requireSpeakerLinkedin,
    'require_speaker_facebook': requireSpeakerFacebook,
    'require_speaker_instagram': requireSpeakerInstagram,
    'require_speaker_blog': requireSpeakerBlog,
    'require_speaker_company': requireSpeakerCompany,
    'require_speaker_shirt_size': requireSpeakerShirtSize,
    'speakers': speakers,
    'categories': categories?.toJson(),
    'registrations': registrations.map((e) => e.toJson()).toList(),
  };
}

class Category {
  final String id;
  final String name;
  final String color;
  final String createdAt;
  final String updatedAt;
  final String? description;

  Category({
    required this.id,
    required this.name,
    required this.color,
    required this.createdAt,
    required this.updatedAt,
    this.description,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] as String,
      name: json['name'] as String? ?? '',
      color: json['color'] as String? ?? '',
      createdAt: json['created_at'] as String? ?? '',
      updatedAt: json['updated_at'] as String? ?? '',
      description: json['description'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'color': color,
    'created_at': createdAt,
    'updated_at': updatedAt,
    'description': description,
  };
}

class Registration {
  final int count;

  Registration({required this.count});

  factory Registration.fromJson(Map<String, dynamic> json) {
    return Registration(
      count:
          json['count'] is int
              ? json['count'] as int
              : int.tryParse(json['count'].toString()) ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {'count': count};
}

class Pagination {
  final int page;
  final int limit;
  final int total;
  final int pages;

  Pagination({
    required this.page,
    required this.limit,
    required this.total,
    required this.pages,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      page: json['page'] as int,
      limit: json['limit'] as int,
      total: json['total'] as int,
      pages: json['pages'] as int,
    );
  }

  Map<String, dynamic> toJson() => {
    'page': page,
    'limit': limit,
    'total': total,
    'pages': pages,
  };
}
