class CreateSessionResponse {
  final String message;
  final Session session;

  CreateSessionResponse({required this.message, required this.session});

  factory CreateSessionResponse.fromJson(Map<String, dynamic> json) {
    return CreateSessionResponse(
      message: json['message'],
      session: Session.fromJson(json['session']),
    );
  }

  Map<String, dynamic> toJson() {
    return {'message': message, 'session': session.toJson()};
  }
}

class Session {
  final String id;
  final String title;
  final String description;
  final String? speakerId;
  final String? categoryId;
  final String startTime;
  final String endTime;
  final String location;
  final int? capacity;
  final String status;
  final String? meetingUrl;
  final String? materialsUrl;
  final List<dynamic> tags;
  final bool isFeatured;
  final String createdBy;
  final String createdAt;
  final String updatedAt;
  final String callForSpeakerStartDate;
  final String callForSpeakerEndDate;
  final dynamic speakers;
  final dynamic categories;

  Session({
    required this.id,
    required this.title,
    required this.description,
    this.speakerId,
    this.categoryId,
    required this.startTime,
    required this.endTime,
    required this.location,
    required this.capacity,
    required this.status,
    this.meetingUrl,
    this.materialsUrl,
    required this.tags,
    required this.isFeatured,
    required this.createdBy,
    required this.createdAt,
    required this.updatedAt,
    required this.callForSpeakerStartDate,
    required this.callForSpeakerEndDate,
    this.speakers,
    this.categories,
  });

  factory Session.fromJson(Map<String, dynamic> json) {
    return Session(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      speakerId: json['speaker_id'],
      categoryId: json['category_id'],
      startTime: json['start_time'],
      endTime: json['end_time'],
      location: json['location'],
      capacity: json['capacity'],
      status: json['status'],
      meetingUrl: json['meeting_url'],
      materialsUrl: json['materials_url'],
      tags: json['tags'] ?? [],
      isFeatured: json['is_featured'],
      createdBy: json['created_by'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      callForSpeakerStartDate: json['call_for_speaker_start_date'],
      callForSpeakerEndDate: json['call_for_speaker_end_date'],
      speakers: json['speakers'],
      categories: json['categories'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
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
      'speakers': speakers,
      'categories': categories,
    };
  }
}
