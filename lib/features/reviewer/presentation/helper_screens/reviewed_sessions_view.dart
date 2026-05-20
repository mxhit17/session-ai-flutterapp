import 'package:flutter/material.dart';
import 'package:session.ai/features/reviewer/data/reviewer_repository.dart';
import 'package:session.ai/features/reviewer/models/get_reviewed_sessions_response.dart';

class ReviewedSessionsScreen extends StatefulWidget {
  const ReviewedSessionsScreen({super.key});

  @override
  State<ReviewedSessionsScreen> createState() => _ReviewedSessionsScreenState();
}

class _ReviewedSessionsScreenState extends State<ReviewedSessionsScreen> {
  final ReviewerRepository _repository = ReviewerRepository();
  late Future<List<ReviewedSessionModel>> _futureSessions;

  @override
  void initState() {
    super.initState();
    _futureSessions = _repository.getReviewedSessions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /// subtle gradient bg (not dark)
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF8FAFF), Color(0xFFEFF3FF)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              /// AppBar (custom, cleaner)
              const Padding(
                padding: EdgeInsets.fromLTRB(16, 10, 16, 6),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Reviewed Sessions",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: FutureBuilder<List<ReviewedSessionModel>>(
                  future: _futureSessions,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const _LoadingState();
                    }

                    if (snapshot.hasError) {
                      return const _ErrorState();
                    }

                    final sessions = snapshot.data ?? [];

                    if (sessions.isEmpty) {
                      return const _EmptyState();
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: sessions.length,
                      itemBuilder: (context, index) {
                        final session = sessions[index];
                        final review =
                            session.sessions.reviews.isNotEmpty == true
                                ? session.sessions.reviews.first
                                : null;

                        return _SessionCard(session: session, review: review);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SessionCard extends StatelessWidget {
  final ReviewedSessionModel session;
  final dynamic review;

  const _SessionCard({required this.session, required this.review});

  Color _getScoreColor(num? score) {
    if (score == null) return Colors.grey;
    if (score >= 4) return Colors.green;
    if (score >= 2.5) return Colors.orange;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    final score = review?.score;
    final scoreColor = _getScoreColor(score);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white.withOpacity(0.75),
        border: Border.all(color: Colors.white.withOpacity(0.6)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 14,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Title + status
            Row(
              children: [
                Expanded(
                  child: Text(
                    session.sessions.title,
                    style: const TextStyle(
                      fontSize: 16.5,
                      fontWeight: FontWeight.w600,
                      height: 1.3,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check, size: 16, color: Colors.green),
                ),
              ],
            ),

            const SizedBox(height: 10),

            /// Metadata
            Text(
              "Event: ${session.sessions.title}",
              style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
            ),

            if (session.sessions.tracks != null)
              Padding(
                padding: const EdgeInsets.only(top: 3),
                child: Text(
                  "Track: ${session.sessions.tracks}",
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                ),
              ),

            const SizedBox(height: 12),

            /// Divider (subtle structure)
            Container(height: 1, color: Colors.grey.withOpacity(0.15)),

            const SizedBox(height: 12),

            /// Score + Comment row
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Score badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: scoreColor.withOpacity(0.12),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.star, size: 15, color: scoreColor),
                      const SizedBox(width: 4),
                      Text(
                        "${score ?? '-'}",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: scoreColor,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 10),

                /// Comment
                Expanded(
                  child: Text(
                    review?.comment ?? "",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.grey.shade700, height: 1.4),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _LoadingState extends StatelessWidget {
  const _LoadingState();

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "Failed to load reviewed sessions",
        style: TextStyle(color: Colors.red.shade400),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("No reviewed sessions yet", style: TextStyle(fontSize: 15)),
    );
  }
}
