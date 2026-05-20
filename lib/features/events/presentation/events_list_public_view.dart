import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:intl/intl.dart';
import 'package:session.ai/features/events/data/events_repository.dart';
import 'package:session.ai/features/events/presentation/event_details_public_view.dart';
import 'package:session.ai/features/events/models/all_events_list_response.dart';
import 'package:session.ai/features/landing/landing_view.dart';

/// ---------------- COLORS ----------------
class AppColors {
  static const bg = Color(0xFF0A0F1C);
  static const card = Color(0xFF111827);
  static const glass = Color(0xFF1A2238);

  static const cyan = Color(0xFF00F5FF);
  static const purple = Color(0xFF8B5CF6);
  static const green = Color(0xFF22C55E);
}

/// ---------------- MAIN PAGE ----------------
class EventsListPage extends StatelessWidget {
  const EventsListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
        ),
        title: const Text(
          "Explore Events",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 20,
            letterSpacing: 0.5,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          children: const [
            SearchBarSection(),
            SizedBox(height: 24),
            Expanded(child: EventsGrid()),
          ],
        ),
      ),
    );
  }
}

/// ---------------- SEARCH ----------------
class SearchBarSection extends StatelessWidget {
  const SearchBarSection({super.key});

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      child: TextField(
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: "Search events with AI...",
          hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
          prefixIcon: const Icon(Icons.auto_awesome, color: AppColors.cyan),
          border: InputBorder.none,
        ),
      ),
    );
  }
}

/// ---------------- GRID ----------------
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
          return const Center(
            child: CircularProgressIndicator(color: AppColors.cyan),
          );
        }

        if (snapshot.hasError) {
          return const Center(
            child: Text(
              "Something went wrong",
              style: TextStyle(color: Colors.white),
            ),
          );
        }

        final events = snapshot.data!;

        return MasonryGridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 20,
          crossAxisSpacing: 20,
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

/// ---------------- CARD ----------------
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
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: const LinearGradient(
          colors: [Color(0xFF111827), Color(0xFF1F2937)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(
          color: const Color(0xFF00F5FF).withOpacity(0.15),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF00F5FF).withOpacity(0.08),
            blurRadius: 20,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 🔹 Title
          Text(
            title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              letterSpacing: 0.3,
            ),
          ),

          const SizedBox(height: 8),

          /// 🔹 Description
          Text(
            description,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 13,
              height: 1.4,
            ),
          ),

          const SizedBox(height: 14),

          /// 🔹 Location
          Row(
            children: [
              const Icon(Icons.location_on, size: 14, color: Colors.cyanAccent),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  location,
                  style: const TextStyle(color: Colors.white60, fontSize: 12),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),

          const SizedBox(height: 6),

          /// 🔹 Date (FIXED)
          Row(
            children: [
              const Icon(
                Icons.calendar_today,
                size: 14,
                color: Colors.purpleAccent,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  date,
                  style: const TextStyle(color: Colors.white60, fontSize: 12),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          /// 🔹 View Details Button (UNCHANGED LOGIC)
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 13),
                backgroundColor: const Color(0xFF3B82F6),
                foregroundColor: Colors.white,
                elevation: 0,
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
              child: const Text(
                "View Details",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
