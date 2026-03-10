import 'package:flutter/material.dart';
import 'package:session.ai/features/organiser/data/organiser_repository.dart';
import 'package:session.ai/features/organiser/models/reviewed_sessions_response.dart';

class ReviewedSessionsTab extends StatefulWidget {
  final String eventId;

  const ReviewedSessionsTab({super.key, required this.eventId});

  @override
  State<ReviewedSessionsTab> createState() => _ReviewedSessionsTabState();
}

class _ReviewedSessionsTabState extends State<ReviewedSessionsTab> {
  bool loading = true;
  final OrganiserRepository _repo = OrganiserRepository();

  List<ReviewedSession> sessions = [];

  @override
  void initState() {
    super.initState();
    fetchSessions();
  }

  Future<void> fetchSessions() async {
    try {
      final result = await _repo.getReviewedSessions(widget.eventId);

      setState(() {
        sessions = result;
        loading = false;
      });
    } catch (e) {
      setState(() {
        loading = false;
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Failed to load sessions")));
    }
  }

  Future<void> updateStatus(String id, String status) async {
    try {
      await _repo.updateSessionStatus(id, status);

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Session $status")));

      fetchSessions(); // refresh list
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Failed to update session")));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (sessions.isEmpty) {
      return const Center(child: Text("No reviewed sessions yet"));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: sessions.length,
      itemBuilder: (context, index) {
        final session = sessions[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  session.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 6),

                Row(
                  children: [
                    const Icon(Icons.star, size: 16, color: Colors.amber),
                    const SizedBox(width: 4),
                    Text("Avg Score: ${session.averageScore}"),
                  ],
                ),

                const SizedBox(height: 4),

                Text("Reviews: ${session.reviewCount}"),

                const SizedBox(height: 4),

                Text("Status: ${session.status}"),

                const SizedBox(height: 12),

                // if (session.status == "UNDER_REVIEW")
                Row(
                  children: [
                    ElevatedButton(
                      onPressed:
                          () => updateStatus(session.sessionId, "ACCEPTED"),
                      child: const Text("Accept"),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      onPressed:
                          () => updateStatus(session.sessionId, "REJECTED"),
                      child: const Text(
                        "Reject",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
