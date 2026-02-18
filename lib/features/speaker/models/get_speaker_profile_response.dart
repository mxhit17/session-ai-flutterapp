class GetSpeakerProfile {
  final String id;
  final String userId;
  final String bio;
  final String organization;
  final String experienceLevel;
  final String? profilePhotoUrl;

  GetSpeakerProfile({
    required this.id,
    required this.userId,
    required this.bio,
    required this.organization,
    required this.experienceLevel,
    required this.profilePhotoUrl,
  });

  factory GetSpeakerProfile.fromJson(Map<String, dynamic> json) {
    return GetSpeakerProfile(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      bio: json['bio'] ?? '',
      organization: json['organization'] ?? '',
      experienceLevel: json['experience_level'] ?? '',
      profilePhotoUrl: json['profile_photo_url'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'bio': bio,
      'organization': organization,
      'experience_level': experienceLevel,
      'profile_photo_url': profilePhotoUrl,
    };
  }

  GetSpeakerProfile copyWith({
    String? id,
    String? userId,
    String? bio,
    String? organization,
    String? experienceLevel,
    String? profilePhotoUrl,
  }) {
    return GetSpeakerProfile(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      bio: bio ?? this.bio,
      organization: organization ?? this.organization,
      experienceLevel: experienceLevel ?? this.experienceLevel,
      profilePhotoUrl: profilePhotoUrl ?? this.profilePhotoUrl,
    );
  }
}
