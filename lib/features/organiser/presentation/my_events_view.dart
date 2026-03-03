import 'package:flutter/material.dart';
import 'package:session.ai/core/events/models/get_events_response.dart';
import 'package:session.ai/features/organiser/data/organiser_repository.dart';
import 'package:session.ai/features/organiser/presentation/organiser_event_details_view.dart';
import 'package:session.ai/features/speaker/presentation/events/create_event_view.dart';

class OrganizerEventsScreen extends StatefulWidget {
  const OrganizerEventsScreen({super.key});

  @override
  State<OrganizerEventsScreen> createState() => _OrganizerEventsScreenState();
}

class _OrganizerEventsScreenState extends State<OrganizerEventsScreen> {
  final OrganiserRepository repository = OrganiserRepository();

  late Future<List<GetEventsResponse>> _eventsFuture;

  @override
  void initState() {
    super.initState();
    _eventsFuture = repository.getMyEventsOrganiser();
  }

  Future<void> _refresh() async {
    setState(() {
      _eventsFuture = repository.getMyEventsOrganiser();
    });

    // wait for future to complete (important for RefreshIndicator)
    await _eventsFuture;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Events")),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const CreateEventScreen()),
          );

          // Refresh after coming back (in case event was created)
          await _refresh();
        },
        icon: const Icon(Icons.add),
        label: const Text("Create Event"),
      ),
      body: FutureBuilder<List<GetEventsResponse>>(
        future: _eventsFuture,
        builder: (context, snapshot) {
          // 🔄 Loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // ❌ Error
          if (snapshot.hasError) {
            return const Center(child: Text("Failed to load events"));
          }

          // 📭 Empty
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No events found"));
          }

          final events = snapshot.data!;

          // ✅ Data
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: events.length,
            itemBuilder: (context, index) {
              final event = events[index];

              return InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => OrganizerEventDetailScreen(event: event),
                    ),
                  );
                },
                child: Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// Title Row with 3-dot menu
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                event.title,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            PopupMenuButton<String>(
                              onSelected: (value) async {
                                if (value == "edit") {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (_) => CreateEventScreen(
                                            existingEvent: event,
                                          ),
                                    ),
                                  );
                                  await _refresh();
                                }

                                if (value == "delete") {
                                  _showDeleteDialog(event.id);
                                }
                              },
                              itemBuilder:
                                  (context) => const [
                                    PopupMenuItem(
                                      value: "edit",
                                      child: Text("Edit"),
                                    ),
                                    PopupMenuItem(
                                      value: "delete",
                                      child: Text("Delete"),
                                    ),
                                  ],
                            ),
                          ],
                        ),

                        const SizedBox(height: 8),
                        Text(event.description),

                        const SizedBox(height: 8),
                        Text(
                          "${event.startDate.toLocal().toString().split(' ')[0]} "
                          "- ${event.endDate.toLocal().toString().split(' ')[0]}",
                          style: const TextStyle(color: Colors.grey),
                        ),

                        const SizedBox(height: 4),
                        Text(
                          event.location,
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _showDeleteDialog(String eventId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Delete Event"),
          content: const Text(
            "Are you sure you want to delete this event? This action cannot be undone.",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text("Yes, Delete"),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      await repository.deleteEvent(eventId);
      await _refresh();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Event deleted successfully")),
        );
      }
    }
  }
}
