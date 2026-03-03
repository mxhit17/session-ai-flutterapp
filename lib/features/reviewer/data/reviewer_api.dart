import 'package:dio/dio.dart';
import 'package:session.ai/features/reviewer/models/get_assigned_session_details.dart';
import 'package:session.ai/features/reviewer/models/get_assigned_sessions_response.dart';
import 'package:session.ai/features/reviewer/models/get_final_score_response.dart';
import 'package:session.ai/features/reviewer/models/reviewer_dashboard_stats_response.dart';
import 'package:session.ai/features/reviewer/models/submit_review_response.dart';
import 'package:session.ai/injection_container.dart';
import 'package:session.ai/utils/constants/api_constants.dart';
import 'package:session.ai/utils/network/dio_client.dart';

class ReviewerApi {
  final Dio _client = sl<DioClient>().instance;

  /// 1️⃣ Get Assigned Sessions
  Future<List<GetAssignedSessionsResponse>> getAssignedSessions({
    String? eventId,
    String? status,
  }) async {
    final response = await _client.get(
      ApiConstants.reviewerSessions,
      queryParameters: {
        if (eventId != null) 'eventId': eventId,
        if (status != null) 'status': status,
      },
    );

    final List data = response.data;
    return data.map((e) => GetAssignedSessionsResponse.fromJson(e)).toList();
  }

  /// 2️⃣ Get Session Detail
  Future<GetAssignedSessionDetails> getSessionDetails(String sessionId) async {
    final response = await _client.get(
      "${ApiConstants.reviewerSessions}/$sessionId",
    );

    return GetAssignedSessionDetails.fromJson(response.data);
  }

  /// 3️⃣ Submit Review
  Future<SubmitOrGetReviewResponse> submitReview({
    required String sessionId,
    required int score,
    required String comment,
  }) async {
    final response = await _client.post(
      "${ApiConstants.reviewerSessions}/$sessionId/review",
      data: {"score": score, "comment": comment},
    );

    return SubmitOrGetReviewResponse.fromJson(response.data);
  }

  /// 4️⃣ Get My Review
  Future<SubmitOrGetReviewResponse> getMyReview(String sessionId) async {
    final response = await _client.get(
      "${ApiConstants.reviewerSessions}/$sessionId/my-review",
    );

    return SubmitOrGetReviewResponse.fromJson(response.data);
  }

  /// 5️⃣ Dashboard Stats
  Future<ReviewerDashboardStatsResponse> getDashboardStats() async {
    final response = await _client.get(ApiConstants.reviewerDashboardStats);

    return ReviewerDashboardStatsResponse.fromJson(response.data);
  }

  /// 6️⃣ Get Final Score
  Future<GetFinalScoreResponse> getFinalScore(String sessionId) async {
    final response = await _client.get(
      "${ApiConstants.reviewerSessions}/$sessionId/final-score",
    );

    return GetFinalScoreResponse.fromJson(response.data);
  }
}
