import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:session.ai/features/events/data/events_repository.dart';
import 'package:session.ai/features/events/models/all_events_list_response.dart';
import 'package:session.ai/features/speaker/presentation/events/create_event_view.dart';
import 'package:session.ai/features/speaker/presentation/events/event_detail_view.dart';

class UpcomingEventsScreen extends StatefulWidget {
  const UpcomingEventsScreen({super.key});

  @override
  State<UpcomingEventsScreen> createState() => _UpcomingEventsScreenState();
}

class _UpcomingEventsScreenState extends State<UpcomingEventsScreen> {
  final EventsRepository _repository = EventsRepository();
  late Future<AllEventsList> _eventsFuture;

  @override
  void initState() {
    super.initState();
    _eventsFuture = _repository.getEvents();
  }

  Future<void> _refresh() async {
    setState(() {
      _eventsFuture = _repository.getEvents();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const CreateEventScreen()),
          );

          // Refresh after coming back (in case event was created)
          _refresh();
        },
        icon: const Icon(Icons.add),
        label: const Text("Create Event"),
      ),
      body: FutureBuilder<AllEventsList>(
        future: _eventsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text("Failed to load events"));
          }

          final events = snapshot.data?.events ?? [];

          if (events.isEmpty) {
            return const Center(child: Text("No upcoming events"));
          }

          return RefreshIndicator(
            onRefresh: _refresh,
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: events.length,
              itemBuilder: (context, index) {
                final event = events[index];

                return InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => EventDetailScreen(event: event),
                      ),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.grey.shade100,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          event.title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),

                        Text(
                          event.description ?? "",
                          style: TextStyle(color: Colors.grey.shade700),
                        ),

                        const SizedBox(height: 12),

                        Row(
                          children: [
                            const Icon(Icons.calendar_today, size: 16),
                            const SizedBox(width: 6),
                            Text(
                              "${DateFormat('dd MMM yyyy').format(event.startDate)} - ${DateFormat('dd MMM yyyy').format(event.endDate)}",
                            ),
                          ],
                        ),

                        const SizedBox(height: 6),

                        Row(
                          children: [
                            const Icon(Icons.location_on, size: 16),
                            const SizedBox(width: 6),
                            Text(event.location ?? ""),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
