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
      appBar: AppBar(title: const Text("Reviewed Sessions")),
      body: FutureBuilder<List<ReviewedSessionModel>>(
        future: _futureSessions,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                "Failed to load reviewed sessions",
                style: TextStyle(color: Colors.red.shade400),
              ),
            );
          }

          final sessions = snapshot.data ?? [];

          if (sessions.isEmpty) {
            return const Center(child: Text("No reviewed sessions yet"));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: sessions.length,
            itemBuilder: (context, index) {
              final session = sessions[index];
              final review =
                  session.sessions?.reviews?.isNotEmpty == true
                      ? session.sessions!.reviews!.first
                      : null;

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),

                  title: Text(
                    session.sessions.title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),

                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 6),

                      if (session.sessions.title != null)
                        Text("Event: ${session.sessions.title}"),

                      if (session.sessions.tracks != null)
                        Text("Track: ${session.sessions.tracks}"),

                      const SizedBox(height: 6),

                      Row(
                        children: [
                          const Icon(Icons.star, size: 16, color: Colors.amber),
                          const SizedBox(width: 4),
                          Text("Score: ${review?.score ?? '-'}"),
                        ],
                      ),

                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          review?.comment ?? "",
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),

                  trailing: const Icon(Icons.check_circle, color: Colors.green),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
