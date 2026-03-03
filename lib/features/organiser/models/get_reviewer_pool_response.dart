class GetReviewerPoolResponse {
  final String id;
  final String eventId;
  final String reviewerId;
  final ReviewerUserModel user;

  GetReviewerPoolResponse({
    required this.id,
    required this.eventId,
    required this.reviewerId,
    required this.user,
  });

  factory GetReviewerPoolResponse.fromJson(Map<String, dynamic> json) {
    return GetReviewerPoolResponse(
      id: json['id'],
      eventId: json['event_id'],
      reviewerId: json['reviewer_id'],
      user: ReviewerUserModel.fromJson(json['users']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'event_id': eventId,
      'reviewer_id': reviewerId,
      'users': user.toJson(),
    };
  }
}

class ReviewerUserModel {
  final String id;
  final String fullName;
  final String email;

  ReviewerUserModel({
    required this.id,
    required this.fullName,
    required this.email,
  });

  factory ReviewerUserModel.fromJson(Map<String, dynamic> json) {
    return ReviewerUserModel(
      id: json['id'],
      fullName: json['full_name'],
      email: json['email'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'full_name': fullName, 'email': email};
  }
}
