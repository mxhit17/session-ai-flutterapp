import 'package:session.ai/features/reviewer/models/get_assigned_sessions_response.dart';

class SubmitOrGetReviewResponse {
  final String id;
  final String sessionId;
  final String reviewerId;
  final int score;
  final String comment;
  final AiAnalysis? aiAnalysis;
  final bool isAiGenerated;
  final DateTime createdAt;

  SubmitOrGetReviewResponse({
    required this.id,
    required this.sessionId,
    required this.reviewerId,
    required this.score,
    required this.comment,
    required this.aiAnalysis,
    required this.isAiGenerated,
    required this.createdAt,
  });

  factory SubmitOrGetReviewResponse.fromJson(Map<String, dynamic> json) {
    return SubmitOrGetReviewResponse(
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
