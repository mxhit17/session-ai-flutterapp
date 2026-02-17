import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:session.ai/features/speaker/data/speaker_repository.dart';
import 'package:session.ai/features/speaker/models/my_sessions_response.dart';

class MySessionsScreen extends StatefulWidget {
  const MySessionsScreen({super.key});

  @override
  State<MySessionsScreen> createState() => _MySessionsScreenState();
}

class _MySessionsScreenState extends State<MySessionsScreen> {
  late Future<List<MySessionsResponse>> _sessionsFuture;
  final SpeakerRepository _repository = SpeakerRepository();

  @override
  void initState() {
    super.initState();
    _sessionsFuture = _repository.getMySessions();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<MySessionsResponse>>(
      future: _sessionsFuture,
      builder: (context, snapshot) {
        /// Loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        /// Error
        if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        }

        final sessions = snapshot.data ?? [];

        /// Empty state
        if (sessions.isEmpty) {
          return const Center(child: Text("No sessions submitted yet."));
        }

        /// Success
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: sessions.length,
          itemBuilder: (context, index) {
            final session = sessions[index];

            return Card(
              margin: const EdgeInsets.only(bottom: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Title
                    Text(
                      session.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 8),

                    /// Abstract
                    Text(
                      session.abstract,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 12),

                    /// Event
                    Row(
                      children: [
                        const Icon(Icons.event, size: 18),
                        const SizedBox(width: 6),
                        Text(session.event.title),
                      ],
                    ),

                    const SizedBox(height: 6),

                    /// Date
                    Row(
                      children: [
                        const Icon(Icons.calendar_today, size: 18),
                        const SizedBox(width: 6),
                        Text(
                          DateFormat(
                            'dd MMM yyyy',
                          ).format(session.event.startDate),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    /// Status
                    Align(
                      alignment: Alignment.centerRight,
                      child: Chip(
                        label: Text(session.status),
                        backgroundColor: _getStatusColor(session.status),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case "ACCEPTED":
        return Colors.green.shade100;
      case "REJECTED":
        return Colors.red.shade100;
      case "SUBMITTED":
        return Colors.orange.shade100;
      default:
        return Colors.grey.shade200;
    }
  }
}
