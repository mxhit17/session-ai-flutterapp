import 'dart:io';
import 'package:flutter/material.dart';
import 'package:session.ai/features/create_event/presentation/create_event_view.dart';
import 'package:session.ai/features/upcomming_events/presentation/detailed_event_view_speaker.dart';
import 'package:session.ai/utils/storage/preference_manager.dart';

class HomePageSpeakerView extends StatefulWidget {
  const HomePageSpeakerView({super.key});

  @override
  State<HomePageSpeakerView> createState() => _HomePageSpeakerViewState();
}

class _HomePageSpeakerViewState extends State<HomePageSpeakerView> {
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
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(
          'Upcoming Events',
          style: Theme.of(context).textTheme.displayMedium,
        ),
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () => Scaffold.of(context).openDrawer(),
            );
          },
        ),
      ),

      // ---------------- Drawer -----------------
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
                      'Hi, Speaker',
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        color: Theme.of(context).colorScheme.surface,
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
              ),
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
          ),
        ),
      ),

      // ---------------- Body -----------------
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),

          child:
              eventList.isEmpty
                  ? const Center(
                    child: Text(
                      'No upcoming events yet.\nPlease check again later.',
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
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (_) =>
                                      ViewEventSpeakerScreen(localEvent: event),
                            ),
                          );
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
                                  // Event image (banner or placeholder)
                                  if (event.bannerImage != null)
                                    Image.file(
                                      File(event.bannerImage!.path),
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
                                    child: Text(
                                      "${event.eventName}\n${event.location}",
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
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
