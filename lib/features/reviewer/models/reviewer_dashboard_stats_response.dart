class ReviewerDashboardStatsResponse {
  final int totalAssigned;
  final int completed;
  final int pending;

  ReviewerDashboardStatsResponse({
    required this.totalAssigned,
    required this.completed,
    required this.pending,
  });

  factory ReviewerDashboardStatsResponse.fromJson(Map<String, dynamic> json) {
    return ReviewerDashboardStatsResponse(
      totalAssigned: json['totalAssigned'] ?? 0,
      completed: json['completed'] ?? 0,
      pending: json['pending'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalAssigned': totalAssigned,
      'completed': completed,
      'pending': pending,
    };
  }
}
