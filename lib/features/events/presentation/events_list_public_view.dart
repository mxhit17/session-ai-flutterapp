import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:intl/intl.dart';
import 'package:session.ai/core/widgets/app_sign_in_button.dart';
import 'package:session.ai/features/auth/presentation/sign_in_view.dart';
import 'package:session.ai/features/events/data/events_repository.dart';
import 'package:session.ai/features/events/presentation/event_details_public_view.dart';
import 'package:session.ai/features/events/models/all_events_list_response.dart';

class EventsListPage extends StatelessWidget {
  const EventsListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F172A),
        elevation: 0,
        centerTitle: false,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
        ),
        title: const Text(
          "Explore Events",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 24),
            child: Center(
              child: AppSignInButton(
                fullWidth: false, // Important for AppBar usage
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SignInPage()),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            SearchBarSection(),
            SizedBox(height: 32),
            Expanded(child: EventsGrid()),
          ],
        ),
      ),
    );
  }
}

class SearchBarSection extends StatelessWidget {
  const SearchBarSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: TextField(
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: "Search events...",
          hintStyle: const TextStyle(color: Colors.white54),
          prefixIcon: const Icon(Icons.search, color: Colors.white70),
          filled: true,
          fillColor: const Color(0xFF1F2937),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}

class EventsGrid extends StatefulWidget {
  const EventsGrid({super.key});

  @override
  State<EventsGrid> createState() => _EventsGridState();
}

class _EventsGridState extends State<EventsGrid> {
  final repository = EventsRepository();
  late Future<AllEventsList> _eventsFuture;

  @override
  void initState() {
    super.initState();
    _eventsFuture = repository.getEvents();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<AllEventsList>(
      future: _eventsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return const Center(child: Text("Something went wrong"));
        }

        final events = snapshot.data!;

        return MasonryGridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 24,
          crossAxisSpacing: 24,
          itemCount: events.events.length,
          itemBuilder: (context, index) {
            final event = events.events[index];
            final start = DateFormat('dd MMM yyyy').format(event.startDate);
            final end = DateFormat('dd MMM yyyy').format(event.endDate);

            return EventCard(
              title: event.title,
              description: event.description,
              location: event.location,
              date: "$start - $end",
            );
          },
        );
      },
    );
  }
}

class EventCard extends StatelessWidget {
  final String title;
  final String description;
  final String location;
  final String date;

  const EventCard({
    super.key,
    required this.title,
    required this.description,
    required this.location,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF1F2937),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            description,
            style: const TextStyle(color: Colors.white70, fontSize: 14),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Icon(Icons.location_on, size: 16, color: Colors.white54),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  location,
                  style: const TextStyle(color: Colors.white60, fontSize: 13),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),

          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(Icons.calendar_today, size: 16, color: Colors.white54),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  location,
                  style: const TextStyle(color: Colors.white60, fontSize: 13),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3B82F6),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (_) => EventDetailsPage(
                          title: title,
                          description: description,
                          location: location,
                          date: date,
                        ),
                  ),
                );
              },

              child: const Text("View Details"),
            ),
          ),
        ],
      ),
    );
  }
}
