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
    return RefreshIndicator(
      onRefresh: _refresh,
      child: FutureBuilder<ReviewerDashboardStatsResponse>(
        future: _statsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                "Something went wrong.\nPull to retry.",
                textAlign: TextAlign.center,
              ),
            );
          }

          final stats = snapshot.data!;

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text("Overview", style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 20),

              Row(
                children: [
                  Expanded(
                    child: _StatCard(
                      title: "Total Assigned",
                      value: stats.totalAssigned.toString(),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _StatCard(
                      title: "Completed",
                      value: stats.completed.toString(),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              _StatCard(
                title: "Pending Reviews",
                value: stats.pending.toString(),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;

  const _StatCard({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        child: Column(
          children: [
            Text(value, style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 8),
            Text(title, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
