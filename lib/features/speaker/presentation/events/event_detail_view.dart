import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:session.ai/features/events/models/all_events_list_response.dart';
import 'package:session.ai/features/organiser/presentation/my_events_view.dart';
import 'package:session.ai/features/speaker/presentation/events/submit_session_screen.dart';

class EventDetailScreen extends StatelessWidget {
  final Event event;

  const EventDetailScreen({super.key, required this.event});

  bool get isCfpActive {
    final now = DateTime.now();

    if (!event.cfpOpen) return false;
    if (event.cfpStart == null || event.cfpEnd == null) return false;

    return now.isAfter(event.cfpStart!) && now.isBefore(event.cfpEnd!);
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd MMM yyyy');

    return Scaffold(
      backgroundColor: Color(0xFFEFF3FF),
      appBar: AppBar(
        title: const Text("Event Details"),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black87,
      ),
      extendBodyBehindAppBar: true,

      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF8FAFF), Color(0xFFEFF3FF)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),

        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 100, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),

              /// TITLE CARD
              _glassCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Builder(
                      builder: (context) {
                        final imageToShow =
                            (event.imageUrl != null &&
                                    event.imageUrl!.isNotEmpty)
                                ? event.imageUrl!
                                : randomImages[event.title.hashCode %
                                    randomImages.length];

                        return Column(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(14),
                              child: AspectRatio(
                                aspectRatio: 16 / 9,
                                child: Image.network(
                                  imageToShow,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) {
                                    return Container(
                                      color: Colors.grey.shade200,
                                      alignment: Alignment.center,
                                      child: const Icon(
                                        Icons.broken_image,
                                        color: Colors.grey,
                                        size: 40,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),

                            const SizedBox(height: 18),
                          ],
                        );
                      },
                    ),

                    Text(
                      event.title,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 12),

                    Row(
                      children: [
                        const Icon(Icons.calendar_today, size: 18),
                        const SizedBox(width: 8),
                        Text(
                          "${dateFormat.format(event.startDate)} - ${dateFormat.format(event.endDate)}",
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    Row(
                      children: [
                        const Icon(Icons.location_on, size: 18),
                        const SizedBox(width: 8),
                        Expanded(child: Text(event.location)),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              /// ABOUT
              _sectionTitle("About Event"),

              const SizedBox(height: 10),

              _glassCard(
                child: Text(
                  event.description.isEmpty
                      ? "No description available."
                      : event.description,
                  style: const TextStyle(fontSize: 14, height: 1.5),
                ),
              ),

              const SizedBox(height: 24),

              /// CFP SECTION
              _sectionTitle("Call For Papers"),

              const SizedBox(height: 10),

              _glassCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.schedule, size: 18),
                        const SizedBox(width: 8),
                        if (event.cfpStart != null && event.cfpEnd != null)
                          Text(
                            "${dateFormat.format(event.cfpStart!)} - ${dateFormat.format(event.cfpEnd!)}",
                          )
                        else
                          const Text("CFP dates not announced"),
                      ],
                    ),

                    const SizedBox(height: 12),

                    /// STATUS CHIP
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color:
                            event.cfpOpen
                                ? Colors.green.withOpacity(0.1)
                                : Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            event.cfpOpen ? Icons.check_circle : Icons.cancel,
                            size: 16,
                            color: event.cfpOpen ? Colors.green : Colors.red,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            event.cfpOpen ? "CFP Open" : "CFP Closed",
                            style: TextStyle(
                              color: event.cfpOpen ? Colors.green : Colors.red,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              /// BUTTON
              SizedBox(
                width: double.infinity,
                child: GestureDetector(
                  onTap:
                      isCfpActive
                          ? () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (_) =>
                                        SubmitSessionScreen(eventId: event.id),
                              ),
                            );
                          }
                          : null,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      gradient:
                          isCfpActive
                              ? const LinearGradient(
                                colors: [Color(0xFF7C7CFF), Color(0xFF5A54FF)],
                              )
                              : LinearGradient(
                                colors: [
                                  Colors.grey.shade300,
                                  Colors.grey.shade200,
                                ],
                              ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow:
                          isCfpActive
                              ? [
                                BoxShadow(
                                  color: const Color(
                                    0xFF6C63FF,
                                  ).withOpacity(0.3),
                                  blurRadius: 12,
                                  offset: const Offset(0, 6),
                                ),
                              ]
                              : [],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Submit Session",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: isCfpActive ? Colors.white : Colors.grey,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              if (!isCfpActive) ...[
                const SizedBox(height: 10),
                const Center(
                  child: Text(
                    "Session submissions are not currently open.",
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  /// REUSABLE GLASS CARD
  Widget _glassCard({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.75),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.6)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }

  /// SECTION TITLE
  Widget _sectionTitle(String text) {
    return Text(
      text,
      style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
    );
  }
}
