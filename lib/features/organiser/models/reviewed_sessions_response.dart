class ReviewedSession {
  final String sessionId;
  final String title;
  final String? trackId;
  final String status;
  final int reviewCount;
  final double averageScore;

  ReviewedSession({
    required this.sessionId,
    required this.title,
    required this.trackId,
    required this.status,
    required this.reviewCount,
    required this.averageScore,
  });

  factory ReviewedSession.fromJson(Map<String, dynamic> json) {
    return ReviewedSession(
      sessionId: json['sessionId'],
      title: json['title'],
      trackId: json['trackId'],
      status: json['status'],
      reviewCount: json['reviewCount'],
      averageScore: (json['averageScore'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sessionId': sessionId,
      'title': title,
      'trackId': trackId,
      'status': status,
      'reviewCount': reviewCount,
      'averageScore': averageScore,
    };
  }

  static List<ReviewedSession> listFromJson(List<dynamic> jsonList) {
    return jsonList.map((e) => ReviewedSession.fromJson(e)).toList();
  }
}
