import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:session.ai/features/reviewer/data/reviewer_api.dart';
import 'package:session.ai/features/reviewer/models/get_assigned_sessions_response.dart';
import 'package:session.ai/features/reviewer/presentation/helper_screens/detailed_assigned_session_view.dart';

class AssignedSessionsScreen extends StatefulWidget {
  const AssignedSessionsScreen({super.key});

  @override
  State<AssignedSessionsScreen> createState() => _AssignedSessionsScreenState();
}

class _AssignedSessionsScreenState extends State<AssignedSessionsScreen> {
  late Future<List<ReviewerAssignment>> _future;

  @override
  void initState() {
    super.initState();
    _future = ReviewerApi().getAssignedSessions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Assigned Sessions")),
      body: FutureBuilder<List<ReviewerAssignment>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          final responses = snapshot.data ?? [];

          /// flatten assignments
          final assignments = responses;

          if (assignments.isEmpty) {
            return const Center(child: Text("No sessions assigned"));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: assignments.length,
            itemBuilder: (context, index) {
              final assignment = assignments[index];
              // final session = assignment.session;

              return _SessionCard(assignment: assignment);
            },
          );
        },
      ),
    );
  }
}

class _SessionCard extends StatelessWidget {
  final ReviewerAssignment assignment;

  const _SessionCard({required this.assignment});

  @override
  Widget build(BuildContext context) {
    final session = assignment.session;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Title
            Text(
              session.title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            /// Event
            Text(
              "Event: ${session.event.title}",
              style: const TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 4),

            /// Track
            if (session.track != null)
              Text(
                "Track: ${session.track!.name}",
                style: const TextStyle(color: Colors.grey),
              ),

            const SizedBox(height: 12),

            /// Status
            Row(
              children: [
                _StatusChip(status: session.status),

                const Spacer(),

                Text(
                  DateFormat('dd MMM yyyy').format(assignment.assignedAt),
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),

            const SizedBox(height: 12),

            /// View button
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () {
                  // Navigate to details screen later
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (_) => ReviewerSessionDetailsScreen(
                            sessionId: assignment.sessionId,
                          ),
                    ),
                  );
                },
                child: const Text("Review"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String status;

  const _StatusChip({required this.status});

  Color getColor() {
    switch (status) {
      case "UNDER_REVIEW":
        return Colors.orange;

      case "ACCEPTED":
        return Colors.green;

      case "REJECTED":
        return Colors.red;

      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: getColor().withOpacity(.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: getColor(),
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }
}
