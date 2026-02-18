import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:session.ai/features/events/models/all_events_list_response.dart';
import 'package:session.ai/features/speaker/presentation/events/submit_session_screen.dart';

class EventDetailScreen extends StatelessWidget {
  final Event event;

  const EventDetailScreen({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
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
                  "${DateFormat('dd MMM yyyy').format(event.startDate)} - ${DateFormat('dd MMM yyyy').format(event.endDate)}",
                ),
              ],
            ),

            const SizedBox(height: 10),

            /// LOCATION
            Row(
              children: [
                const Icon(Icons.location_on, size: 18),
                const SizedBox(width: 8),
                Text(event.location ?? "No location"),
              ],
            ),

            const SizedBox(height: 20),

            const Text(
              "About Event",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            Text(
              event.description ?? "No description available.",
              style: const TextStyle(fontSize: 14),
            ),

            const SizedBox(height: 30),

            /// SUBMIT SESSION BUTTON
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => SubmitSessionScreen(eventId: event.id),
                    ),
                  );
                },
                child: const Text("Submit Session"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
