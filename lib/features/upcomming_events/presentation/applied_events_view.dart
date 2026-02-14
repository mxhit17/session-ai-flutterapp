import 'dart:io';
import 'package:flutter/material.dart';
import 'package:session.ai/features/create_event/presentation/create_event_view.dart';
import 'package:session.ai/features/upcomming_events/presentation/detailed_event_view_speaker.dart';
import 'package:session.ai/utils/storage/preference_manager.dart';

class AppliedEventsScreen extends StatefulWidget {
  const AppliedEventsScreen({super.key});

  @override
  State<AppliedEventsScreen> createState() => _AppliedEventsScreenState();
}

class _AppliedEventsScreenState extends State<AppliedEventsScreen> {
  List<EventModel> appliedEvents = [];

  @override
  void initState() {
    super.initState();
    _loadAppliedEvents();
  }

  Future<void> _loadAppliedEvents() async {
    final events = await EventStorage.loadAppliedEvents();
    setState(() {
      appliedEvents = events;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Applied Events"), centerTitle: true),
      body:
          appliedEvents.isEmpty
              ? const Center(
                child: Text(
                  "You haven’t applied to any events yet.",
                  style: TextStyle(fontSize: 16),
                ),
              )
              : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: appliedEvents.length,
                itemBuilder: (context, index) {
                  final event = appliedEvents[index];

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (_) => ViewEventSpeakerScreen(
                                localEvent: event,
                                hideApplyButton: true,
                              ),
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
    );
  }
}
