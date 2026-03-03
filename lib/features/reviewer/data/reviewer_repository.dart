import 'package:session.ai/features/reviewer/data/reviewer_api.dart';
import 'package:session.ai/features/reviewer/models/get_assigned_session_details.dart';
import 'package:session.ai/features/reviewer/models/get_assigned_sessions_response.dart';
import 'package:session.ai/features/reviewer/models/get_final_score_response.dart';
import 'package:session.ai/features/reviewer/models/reviewer_dashboard_stats_response.dart';
import 'package:session.ai/features/reviewer/models/submit_review_response.dart';

class ReviewerRepository {
  final ReviewerApi _api = ReviewerApi();

  /// 1️⃣ Get Assigned Sessions
  Future<List<GetAssignedSessionsResponse>> getAssignedSessions({
    String? eventId,
    String? status,
  }) async {
    try {
      return await _api.getAssignedSessions(eventId: eventId, status: status);
    } catch (e) {
      throw Exception("Failed to fetch assigned sessions.");
    }
  }

  /// 2️⃣ Get Session Detail
  Future<GetAssignedSessionDetails> getSessionDetails(String sessionId) async {
    try {
      return await _api.getSessionDetails(sessionId);
    } catch (e) {
      throw Exception("Failed to fetch session details.");
    }
  }

  /// 3️⃣ Submit Review
  Future<SubmitOrGetReviewResponse> submitReview({
    required String sessionId,
    required int score,
    required String comment,
  }) async {
    try {
      return await _api.submitReview(
        sessionId: sessionId,
        score: score,
        comment: comment,
      );
    } catch (e) {
      throw Exception("Failed to submit review.");
    }
  }

  /// 4️⃣ Get My Review
  Future<SubmitOrGetReviewResponse> getMyReview(String sessionId) async {
    try {
      return await _api.getMyReview(sessionId);
    } catch (e) {
      throw Exception("Failed to fetch your review.");
    }
  }

  /// 5️⃣ Dashboard Stats
  Future<ReviewerDashboardStatsResponse> getDashboardStats() async {
    try {
      return await _api.getDashboardStats();
    } catch (e) {
      throw Exception("Failed to fetch dashboard stats.");
    }
  }

  /// 6️⃣ Get Final Score
  Future<GetFinalScoreResponse> getFinalScore(String sessionId) async {
    try {
      return await _api.getFinalScore(sessionId);
    } catch (e) {
      throw Exception("Failed to fetch final score.");
    }
  }
}
