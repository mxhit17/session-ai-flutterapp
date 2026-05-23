import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:session.ai/core/events/models/get_events_response.dart';
import 'package:session.ai/features/organiser/presentation/event_detail_view_helpers/cfp_modifier_view.dart';
import 'package:session.ai/features/organiser/presentation/event_detail_view_helpers/event_details_helper_tabs.dart';
import 'package:session.ai/features/organiser/presentation/event_detail_view_helpers/reviewed_sessions_tab.dart';
import 'package:session.ai/features/organiser/presentation/schedule_view.dart';

class OrganizerEventDetailScreen extends StatefulWidget {
  final GetEventsResponse event;

  const OrganizerEventDetailScreen({super.key, required this.event});

  @override
  State<OrganizerEventDetailScreen> createState() =>
      _OrganizerEventDetailScreenState();
}

class _OrganizerEventDetailScreenState
    extends State<OrganizerEventDetailScreen> {
  late GetEventsResponse event;

  @override
  void initState() {
    super.initState();
    event = widget.event;
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd MMM yyyy');

    final bool isCfpDatesMissing =
        event.cfpStart == null || event.cfpEnd == null;

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: const Color(0xFFF7F9FC), // light clean bg
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.black,
          title: const Text("Event Management"),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 🚨 CFP WARNING
            if (isCfpDatesMissing)
              Padding(
                padding: const EdgeInsets.all(16),
                child: GestureDetector(
                  onTap: () async {
                    // final updated = await Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (_) => CfpModifierScreen(event: event),
                    //   ),
                    // );

                    // if (updated == true) {
                    //   setState(() {});
                    // }

                    final updated = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CfpModifierScreen(event: event),
                      ),
                    );

                    if (updated != null) {
                      setState(() {
                        event = event.copyWith(
                          cfpOpen: updated["cfpOpen"],
                          cfpStart: updated["cfpStart"],
                          cfpEnd: updated["cfpEnd"],
                        );
                      });
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade50,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: Colors.orange.shade200),
                    ),
                    child: Row(
                      children: const [
                        Icon(Icons.warning_amber_rounded, color: Colors.orange),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            "CFP dates are not set. Tap to configure.",
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

            /// HEADER CARD
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _ModernEventHeader(
                title: event.title,
                startDate: dateFormat.format(event.startDate),
                endDate: dateFormat.format(event.endDate),
                location: event.location,
                isCfpOpen: event.cfpOpen,
              ),
            ),

            const SizedBox(height: 12),

            /// ACTION BUTTONS
            /// ACTION BUTTONS
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _SoftButton(
                          icon: Icons.calendar_month,
                          label: "View Schedule",
                          isPrimary: false,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (_) => ScheduleScreen(
                                      eventId: widget.event.id,
                                    ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _SoftButton(
                          icon: Icons.auto_fix_high,
                          label: "Generate",
                          isPrimary: true,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (_) => ScheduleBuilderScreen(
                                      eventId: widget.event.id,
                                    ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),

                  /// SHOW ONLY WHEN CFP DATES ARE MISSING
                  if (!isCfpDatesMissing) ...[
                    const SizedBox(height: 12),

                    SizedBox(
                      width: double.infinity,
                      child: _SoftButton(
                        icon: Icons.edit_calendar_rounded,
                        label: "Configure CFP Dates",
                        isPrimary: true,
                        onTap: () async {
                          final updated = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => CfpModifierScreen(event: event),
                            ),
                          );

                          if (updated != null) {
                            setState(() {
                              event = event.copyWith(
                                cfpOpen: updated["cfpOpen"],
                                cfpStart: updated["cfpStart"],
                                cfpEnd: updated["cfpEnd"],
                              );
                            });
                          }
                        },
                      ),
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 12),

            /// IMPROVED TAB BAR
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F3F7), // soft background
                borderRadius: BorderRadius.circular(16),
              ),
              child: TabBar(
                dividerColor: Colors.transparent,
                indicator: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(10, 4),
                    ),
                  ],
                ),
                indicatorPadding: const EdgeInsets.symmetric(
                  // vertical: -2,
                  horizontal: -14,
                ),

                labelColor: Colors.black,
                unselectedLabelColor: Colors.grey.shade600,
                labelStyle: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
                tabs: const [
                  Tab(text: "Tracks"),
                  Tab(text: "Rooms"),
                  Tab(text: "Reviewers"),
                  Tab(text: "Sessions"),
                ],
              ),
            ),

            const SizedBox(height: 10),

            Expanded(
              child: TabBarView(
                children: [
                  TracksTab(),
                  RoomsTab(),
                  ReviewersTab(eventId: widget.event.id),
                  ReviewedSessionsTab(eventId: widget.event.id),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// ================= HEADER =================
class _ModernEventHeader extends StatelessWidget {
  final String title;
  final String startDate;
  final String endDate;
  final String location;
  final bool isCfpOpen;

  const _ModernEventHeader({
    required this.title,
    required this.startDate,
    required this.endDate,
    required this.location,
    required this.isCfpOpen,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFE8F0FE), Color(0xFFF1F5FF)],
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// TITLE
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 10),

          /// DATE
          Row(
            children: [
              const Icon(Icons.calendar_today, size: 18),
              const SizedBox(width: 6),
              Text("$startDate - $endDate"),
            ],
          ),

          const SizedBox(height: 6),

          /// LOCATION
          Row(
            children: [
              const Icon(Icons.location_on_outlined, size: 18),
              const SizedBox(width: 6),
              Expanded(child: Text(location)),
            ],
          ),

          const SizedBox(height: 12),

          /// CFP BADGE
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: isCfpOpen ? Colors.green.shade100 : Colors.red.shade100,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              isCfpOpen ? "CFP Open" : "CFP Closed",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: isCfpOpen ? Colors.green.shade800 : Colors.red.shade800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// ================= BUTTON =================
class _SoftButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isPrimary;
  final VoidCallback onTap;

  const _SoftButton({
    required this.icon,
    required this.label,
    required this.isPrimary,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isPrimary ? const Color(0xFF4F46E5) : Colors.white,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: isPrimary ? Colors.white : Colors.black),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: isPrimary ? Colors.white : Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
