import 'dart:io';

import 'package:flutter/material.dart';
import 'package:session.ai/api_service.dart';
import 'package:session.ai/features/create_event/presentation/create_event_view.dart';
import 'package:session.ai/features/upcomming_events/data/models/get_all_sessions_response.dart';
import 'package:session.ai/injection_container.dart';
import 'package:session.ai/utils/storage/preference_manager.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isOrganizer = true;

  @override
  void initState() {
    super.initState();
    _loadLocalEvents();
  }

  Future<void> _loadLocalEvents() async {
    final events = await EventStorage.loadEvents();
    setState(() {
      eventList
        ..clear()
        ..addAll(events);
    });
  }

  @override
  Widget build(BuildContext context) {
    final prefs = sl<PreferencesManager>();
    final userName = prefs.getUserName() ?? "User";
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(
          'My Events',
          textAlign: TextAlign.end,
          style: Theme.of(context).textTheme.displayMedium,
        ),
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
      ),
      drawer: SizedBox(
        width: MediaQuery.of(context).size.width * 0.75,
        child: Drawer(
          shape: const BeveledRectangleBorder(),
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hi, ${userName}',
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        color: Theme.of(context).colorScheme.surface,
                      ),
                    ),
                    const Spacer(),
                    // you can re-add organizer/speaker toggle here if needed
                  ],
                ),
              ),
              if (isOrganizer) ...[
                ListTile(
                  leading: const Icon(Icons.home),
                  title: const Text("Dashboard"),
                  onTap: () => Navigator.pop(context),
                ),
                ListTile(
                  leading: const Icon(Icons.event),
                  title: const Text("Manage Events"),
                  onTap: () => Navigator.pop(context),
                ),
                ListTile(
                  leading: const Icon(Icons.people),
                  title: const Text("Participants"),
                  onTap: () => Navigator.pop(context),
                ),
              ] else ...[
                ListTile(
                  leading: const Icon(Icons.home),
                  title: const Text("Home"),
                  onTap: () => Navigator.pop(context),
                ),
                ListTile(
                  leading: const Icon(Icons.mic),
                  title: const Text("My Sessions"),
                  onTap: () => Navigator.pop(context),
                ),
                ListTile(
                  leading: const Icon(Icons.star),
                  title: const Text("Feedback"),
                  onTap: () => Navigator.pop(context),
                ),
              ],
            ],
          ),
        ),
      ),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
          child:
              eventList.isEmpty
                  ? const Center(
                    child: Text(
                      'No events yet.\nCreate one to get started!',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16),
                    ),
                  )
                  : ListView.builder(
                    itemCount: eventList.length,
                    itemBuilder: (context, index) {
                      final event = eventList[index];

                      return GestureDetector(
                        onTap: () {
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder:
                          //         (_) => EventDetailsPage(eventIndex: index),
                          //   ),
                          // );
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (_) => EventDetailsPage(eventIndex: index),
                            ),
                          ).then((_) {
                            setState(() {}); // rebuild list after coming back
                          });
                        },
                        child: AspectRatio(
                          aspectRatio: 4 / 3,
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 16),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.grey[200],
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  // Banner or gradient placeholder
                                  if (event.bannerImage != null)
                                    Image.file(
                                      event.bannerImage!,
                                      fit: BoxFit.cover,
                                    )
                                  else
                                    Container(
                                      decoration: const BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            Color(0xFF6A11CB),
                                            Color(0xFF2575FC),
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                                      ),
                                      child: const Icon(
                                        Icons.event,
                                        size: 80,
                                        color: Colors.white70,
                                      ),
                                    ),

                                  // Text overlay
                                  Container(
                                    alignment: Alignment.bottomLeft,
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Colors.transparent,
                                          Colors.black.withOpacity(0.7),
                                        ],
                                      ),
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          event.eventName,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          "${event.location} • ${event.eventDates}",
                                          style: const TextStyle(
                                            color: Colors.white70,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'dart:io';
// import 'your_event_model_file.dart'; // <-- import where eventList & EventModel are stored

class EventDetailsPage extends StatelessWidget {
  final int eventIndex;
  const EventDetailsPage({super.key, required this.eventIndex});

  @override
  Widget build(BuildContext context) {
    // use the correct index
    final event = eventList[eventIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text(event.eventName),
        centerTitle: true,
        elevation: 1,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder:
                    (ctx) => AlertDialog(
                      title: const Text('Delete event?'),
                      content: const Text(
                        'This will permanently remove this event from this device.',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(ctx, false),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(ctx, true),
                          child: const Text(
                            'Delete',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
              );

              if (confirm == true) {
                // remove from in-memory list
                eventList.removeAt(eventIndex);

                // persist updated list
                await EventStorage.saveEvents(eventList);

                if (context.mounted) {
                  Navigator.pop(context, true); // go back to HomeScreen
                }
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ------------------ Banner ------------------
            if (event.bannerImage != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.file(
                  File(event.bannerImage!.path),
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),

            const SizedBox(height: 20),

            // ------------------ Title ------------------
            Text(
              event.eventName,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 6),

            Row(
              children: [
                Icon(Icons.location_on_outlined, color: Colors.grey[700]),
                const SizedBox(width: 6),
                Text(
                  event.location,
                  style: TextStyle(fontSize: 15, color: Colors.grey[700]),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // ------------------ Section Header ------------------
            _sectionHeader("Event Details"),

            _infoTile("Dates", event.eventDates),
            _infoTile("Time Zone", event.timeZone),
            _infoTile("Call for Speakers", event.callForSpeakersDate),
            _infoTile("Support Email", event.speakerSupportEmail),

            const SizedBox(height: 20),

            _sectionHeader("Description"),

            Text(
              event.description,
              style: TextStyle(fontSize: 15, color: Colors.grey[800]),
            ),

            const SizedBox(height: 20),

            // ------------------ Sponsored / Coverage ------------------
            _sectionHeader("Coverages"),

            _coverageRow("Accommodation", event.accommodationCovered),
            _coverageRow("Travel", event.travelCovered),
            _coverageRow("Conference Fee", event.conferenceFeeCovered),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // ------------------ Helpers ------------------

  Widget _sectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
      ),
    );
  }

  Widget _infoTile(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Text(
            "$label: ",
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 15),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  Widget _coverageRow(String title, bool enabled) {
    return Row(
      children: [
        Icon(
          enabled ? Icons.check_circle : Icons.cancel,
          color: enabled ? Colors.green : Colors.red,
          size: 20,
        ),
        const SizedBox(width: 10),
        Text(title, style: const TextStyle(fontSize: 15)),
      ],
    );
  }
}
