import 'package:flutter/material.dart';
import 'package:session.ai/features/reviewer/data/reviewer_repository.dart';
import 'package:session.ai/features/reviewer/models/reviewer_dashboard_stats_response.dart';

class ReviewerDashboardScreen extends StatefulWidget {
  const ReviewerDashboardScreen({super.key});

  @override
  State<ReviewerDashboardScreen> createState() =>
      _ReviewerDashboardScreenState();
}

class _ReviewerDashboardScreenState extends State<ReviewerDashboardScreen> {
  late Future<ReviewerDashboardStatsResponse> _statsFuture;

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  void _loadStats() {
    _statsFuture = ReviewerRepository().getDashboardStats();
  }

  Future<void> _refresh() async {
    setState(() {
      _loadStats();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FB), // light modern bg
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _refresh,
          child: FutureBuilder<ReviewerDashboardStatsResponse>(
            future: _statsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return const Center(
                  child: Text(
                    "Something went wrong.\nPull to retry.",
                    textAlign: TextAlign.center,
                  ),
                );
              }

              final stats = snapshot.data!;

              return ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  // 🔹 Header
                  Text(
                    "Reviewer Dashboard",
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "Track your review activity",
                    style: TextStyle(color: Colors.grey.shade600),
                  ),

                  const SizedBox(height: 24),

                  // 🔹 Overview Section
                  Text(
                    "Overview",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 16),

                  Row(
                    children: [
                      Expanded(
                        child: _StatCard(
                          title: "Total Assigned",
                          value: stats.totalAssigned.toString(),
                          color: const Color(0xFF6366F1), // Indigo
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: _StatCard(
                          title: "Completed",
                          value: stats.completed.toString(),
                          color: const Color(0xFF22C55E), // Green
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  _StatCard(
                    title: "Pending Reviews",
                    value: stats.pending.toString(),
                    color: const Color(0xFFF59E0B), // Amber
                  ),

                  const SizedBox(height: 30),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: LinearGradient(
          colors: [color.withOpacity(0.12), Colors.white],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.15),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
        border: Border.all(color: color.withOpacity(0.15)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Value
            Text(
              value,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w800, // stronger than bold
                fontSize: 30, // slightly bigger
                color: color,
                letterSpacing: 0.5, // improves clarity
                fontFeatures: const [
                  FontFeature.tabularFigures(), // 🔥 aligns digits properly
                ],
              ),
            ),

            const SizedBox(height: 8),

            // Title
            Text(
              title,
              style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
