import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:session.ai/features/speaker/data/speaker_repository.dart';
import 'package:session.ai/features/speaker/models/my_sessions_response.dart';
import 'package:session.ai/utils/widgets/ai_floating_button.dart';

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
    return Scaffold(
      body: Container(
        color: const Color(0xFFF5F7FB), // light modern background
        child: FutureBuilder<List<MySessionsResponse>>(
          future: _sessionsFuture,
          builder: (context, snapshot) {
            /// Loading
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            /// Error
            if (snapshot.hasError) {
              return Center(
                child: Text(
                  "Something went wrong",
                  style: TextStyle(color: Colors.grey.shade700),
                ),
              );
            }

            final sessions = snapshot.data ?? [];

            /// Empty state
            if (sessions.isEmpty) {
              return Center(
                child: Text(
                  "No sessions submitted yet",
                  style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                ),
              );
            }

            /// Success
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: sessions.length,
              itemBuilder: (context, index) {
                final session = sessions[index];

                return Container(
                  margin: const EdgeInsets.only(bottom: 18),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    color: Colors.white.withOpacity(0.9),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// Title + Status
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                session.title,
                                style: Theme.of(
                                  context,
                                ).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            _buildStatusChip(session.status),
                          ],
                        ),

                        const SizedBox(height: 10),

                        /// Abstract
                        Text(
                          session.abstract,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.grey.shade700,
                            height: 1.4,
                          ),
                        ),

                        const SizedBox(height: 16),

                        /// Event & Date Row
                        Row(
                          children: [
                            _infoTile(Icons.event, session.event.title),
                            const SizedBox(width: 12),
                            _infoTile(
                              Icons.calendar_today,
                              DateFormat(
                                'dd MMM yyyy',
                              ).format(session.event.startDate),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: AiFloatingButton(),

      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
    );
  }

  Widget _infoTile(IconData icon, String text) {
    return Expanded(
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: const Color(0xFFEFF3FF),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 16, color: Colors.blueAccent),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    final color = _getStatusColor(status);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case "ACCEPTED":
        return Colors.green;
      case "REJECTED":
        return Colors.red;
      case "SUBMITTED":
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
}
