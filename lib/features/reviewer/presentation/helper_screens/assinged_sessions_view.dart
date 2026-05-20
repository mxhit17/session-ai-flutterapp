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
      body: Container(
        /// 🌈 soft gradient background (light futuristic)
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF8FAFF), Color(0xFFF1F4FF)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              /// 🔥 custom app bar (clean + modern)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                child: Row(
                  children: [
                    const Text(
                      "Assigned Sessions",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(.05),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: const Icon(Icons.tune, size: 18),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: FutureBuilder<List<ReviewerAssignment>>(
                  future: _future,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return Center(child: Text("Error: ${snapshot.error}"));
                    }

                    final assignments = snapshot.data ?? [];

                    if (assignments.isEmpty) {
                      return const Center(child: Text("No sessions assigned"));
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: assignments.length,
                      itemBuilder: (context, index) {
                        return _SessionCard(assignment: assignments[index]);
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
  final ReviewerAssignment assignment;

  const _SessionCard({required this.assignment});

  @override
  Widget build(BuildContext context) {
    final session = assignment.session;

    return Container(
      margin: const EdgeInsets.only(bottom: 18),

      /// ✨ glassy + soft glow card
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [Colors.white, Colors.white.withOpacity(0.92)],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6C63FF).withOpacity(0.08), // subtle glow
            blurRadius: 25,
            offset: const Offset(0, 10),
          ),
        ],
      ),

      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 🔥 Title
            Text(
              session.title,
              style: const TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.w700,
                height: 1.3,
              ),
            ),

            const SizedBox(height: 12),

            /// Event
            _InfoRow(icon: Icons.event, text: session.event.title),

            if (session.track != null)
              _InfoRow(icon: Icons.layers, text: session.track!.name),

            const SizedBox(height: 14),

            /// Status + Date
            Row(
              children: [
                _StatusChip(status: session.status),
                const Spacer(),
                Text(
                  DateFormat('dd MMM').format(assignment.assignedAt),
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
              ],
            ),

            const SizedBox(height: 16),

            /// Button
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: const Color(0xFF6C63FF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 22,
                    vertical: 12,
                  ),
                ),
                onPressed: () {
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
                child: const Text(
                  "Review",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InfoRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey[600]),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(color: Colors.grey[700]),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
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
    final color = getColor();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        gradient: LinearGradient(
          colors: [color.withOpacity(.15), color.withOpacity(.08)],
        ),
      ),
      child: Text(
        status.replaceAll("_", " "),
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
    );
  }
}
