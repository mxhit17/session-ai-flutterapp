import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:session.ai/core/events/models/get_events_response.dart';
import 'package:session.ai/features/organiser/presentation/event_detail_view_helpers/cfp_modifier_view.dart';
import 'package:session.ai/features/organiser/presentation/event_detail_view_helpers/event_details_helper_tabs.dart';

class OrganizerEventDetailScreen extends StatelessWidget {
  final GetEventsResponse event;

  const OrganizerEventDetailScreen({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd MMM yyyy');

    final bool isCfpDatesMissing =
        event.cfpStart == null || event.cfpEnd == null;

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(title: const Text("Event Management")),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 🚨 CFP WARNING BANNER
            if (isCfpDatesMissing)
              GestureDetector(
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CfpModifierScreen(event: event),
                    ),
                  );
                },
                child: Container(
                  width: double.infinity,
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.red),
                  ),
                  child: Row(
                    children: const [
                      Icon(Icons.warning_amber_rounded, color: Colors.red),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          "CFP dates are not set. Tap here to configure CFP now.",
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            /// ===== EVENT HEADER =====
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _EventHeader(
                title: event.title,
                startDate: dateFormat.format(event.startDate),
                endDate: dateFormat.format(event.endDate),
                location: event.location,
                isCfpOpen: event.cfpOpen,
              ),
            ),

            const TabBar(
              tabs: [
                Tab(text: "Tracks"),
                Tab(text: "Rooms"),
                Tab(text: "Reviewers"),
              ],
            ),

            Expanded(
              child: TabBarView(
                children: [
                  TracksTab(),
                  RoomsTab(),
                  ReviewersTab(eventId: event.id),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EventHeader extends StatelessWidget {
  final String title;
  final String startDate;
  final String endDate;
  final String location;
  final bool isCfpOpen;

  const _EventHeader({
    required this.title,
    required this.startDate,
    required this.endDate,
    required this.location,
    required this.isCfpOpen,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Event Title
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),

        /// Dates
        Row(
          children: [
            const Icon(Icons.calendar_today, size: 18),
            const SizedBox(width: 6),
            Text("$startDate - $endDate"),
          ],
        ),
        const SizedBox(height: 6),

        /// Location
        Row(
          children: [
            const Icon(Icons.location_on_outlined, size: 18),
            const SizedBox(width: 6),
            Text(location),
          ],
        ),
        const SizedBox(height: 12),

        /// CFP Badge
        GestureDetector(
          onTap: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (_) => CfpModifierScreen(
                      event:
                          context
                              .findAncestorWidgetOfExactType<
                                OrganizerEventDetailScreen
                              >()!
                              .event,
                    ),
              ),
            );
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: isCfpOpen ? Colors.green.shade100 : Colors.red.shade100,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              isCfpOpen ? "CFP Open" : "CFP Closed",
              style: TextStyle(
                color: isCfpOpen ? Colors.green.shade800 : Colors.red.shade800,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
