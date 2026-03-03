class GetFinalScoreResponse {
  final double finalScore;

  GetFinalScoreResponse({required this.finalScore});

  factory GetFinalScoreResponse.fromJson(Map<String, dynamic> json) {
    return GetFinalScoreResponse(
      finalScore: (json['finalScore'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'finalScore': finalScore};
  }
}
