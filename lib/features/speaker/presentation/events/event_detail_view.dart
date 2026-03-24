import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:session.ai/features/events/models/all_events_list_response.dart';
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
      appBar: AppBar(title: const Text("Event Details")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// TITLE
            Text(
              event.title,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 16),

            /// DATE
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 18),
                const SizedBox(width: 8),
                Text(
                  "${dateFormat.format(event.startDate)} - ${dateFormat.format(event.endDate)}",
                ),
              ],
            ),

            const SizedBox(height: 10),

            /// LOCATION
            Row(
              children: [
                const Icon(Icons.location_on, size: 18),
                const SizedBox(width: 8),
                Text(event.location),
              ],
            ),

            const SizedBox(height: 20),

            /// DESCRIPTION
            const Text(
              "About Event",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            Text(
              event.description.isEmpty
                  ? "No description available."
                  : event.description,
              style: const TextStyle(fontSize: 14),
            ),

            const SizedBox(height: 24),

            /// CFP DETAILS
            const Text(
              "Call For Papers (CFP)",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

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

            const SizedBox(height: 8),

            Row(
              children: [
                Icon(
                  event.cfpOpen ? Icons.check_circle : Icons.cancel,
                  color: event.cfpOpen ? Colors.green : Colors.red,
                  size: 18,
                ),
                const SizedBox(width: 8),
                Text(
                  event.cfpOpen ? "CFP is Open" : "CFP is Closed",
                  style: TextStyle(
                    color: event.cfpOpen ? Colors.green : Colors.red,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            /// SUBMIT SESSION BUTTON
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed:
                    isCfpActive
                        ? () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (_) => SubmitSessionScreen(eventId: event.id),
                            ),
                          );
                        }
                        : null,
                child: const Text("Submit Session"),
              ),
            ),

            if (!isCfpActive) ...[
              const SizedBox(height: 10),
              const Text(
                "Session submissions are not currently open.",
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
