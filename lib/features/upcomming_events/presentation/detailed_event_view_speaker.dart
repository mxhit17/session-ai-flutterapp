// vieweventspeaker.dart
// Flutter screen to display Session details (ViewEventSpeaker)

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:session.ai/features/create_event/presentation/create_event_view.dart';
import 'package:session.ai/utils/storage/preference_manager.dart';

// Utility: format ISO date string to friendly local representation (no external packages required)
String formatIsoDate(String iso) {
  try {
    final dt = DateTime.parse(iso).toLocal();
    final day = dt.day.toString().padLeft(2, '0');
    final monthNames = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    final month = monthNames[dt.month - 1];
    final year = dt.year;
    final hour = dt.hour.toString().padLeft(2, '0');
    final minute = dt.minute.toString().padLeft(2, '0');
    return '$day $month $year, $hour:$minute';
  } catch (e) {
    return iso;
  }
}

class ViewEventSpeakerScreen extends StatelessWidget {
  final EventModel localEvent;
  final bool hideApplyButton; // 👈 NEW

  const ViewEventSpeakerScreen({
    Key? key,
    required this.localEvent,
    this.hideApplyButton = false, // default: show the button
  }) : super(key: key);

  Widget _infoRow(IconData icon, String label) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18),
        const SizedBox(width: 8),
        Expanded(child: Text(label, style: const TextStyle(fontSize: 14))),
      ],
    );
  }

  Widget _booleanTile(
    String label,
    bool value, {
    String? trueText,
    String? falseText,
  }) {
    return Row(
      children: [
        Icon(
          value ? Icons.check_circle : Icons.cancel,
          color: value ? Colors.green : Colors.red,
        ),
        const SizedBox(width: 8),
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(width: 8),
        Text(value ? (trueText ?? 'Yes') : (falseText ?? 'No')),
      ],
    );
  }

  Future<void> _handleApply(BuildContext context) async {
    // load currently applied events
    final appliedEvents = await EventStorage.loadAppliedEvents();

    // basic "uniqueness" check by name + dates
    final alreadyApplied = appliedEvents.any(
      (e) =>
          e.eventName == localEvent.eventName &&
          e.eventDates == localEvent.eventDates,
    );

    if (!alreadyApplied) {
      appliedEvents.add(localEvent);
      await EventStorage.saveAppliedEvents(appliedEvents);
    }

    if (context.mounted) {
      Future.delayed(const Duration(seconds: 1), () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              alreadyApplied
                  ? 'You’ve already applied to this event.'
                  : 'Applied to event successfully 🎉',
            ),
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          localEvent.eventName.isNotEmpty
              ? localEvent.eventName
              : 'Event details',
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ---------- Top card: banner + main info ----------
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    // Banner or placeholder
                    Container(
                      width: 84,
                      height: 84,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.grey.shade200,
                      ),
                      child:
                          localEvent.bannerImage != null
                              ? ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.file(
                                  File(localEvent.bannerImage!.path),
                                  fit: BoxFit.cover,
                                ),
                              )
                              : const Icon(Icons.event, size: 40),
                    ),
                    const SizedBox(width: 16),
                    // Text info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            localEvent.eventName,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 6),
                          if (localEvent.description.isNotEmpty)
                            Text(
                              localEvent.description,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                          const SizedBox(height: 10),
                          if (localEvent.location.isNotEmpty)
                            Row(
                              children: [
                                const Icon(
                                  Icons.location_on_outlined,
                                  size: 16,
                                ),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    localEvent.location,
                                    style: const TextStyle(fontSize: 13),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 12),

            // ---------- When ----------
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'When',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _infoRow(
                      Icons.event,
                      'Event dates: ${localEvent.eventDates}',
                    ),
                    const SizedBox(height: 8),
                    _infoRow(
                      Icons.campaign_outlined,
                      'Call for speakers: ${localEvent.callForSpeakersDate}',
                    ),
                    const SizedBox(height: 8),
                    if (localEvent.timeZone.isNotEmpty)
                      _infoRow(
                        Icons.access_time,
                        'Time zone: ${localEvent.timeZone}',
                      ),
                    const SizedBox(height: 8),
                    if (localEvent.location.isNotEmpty)
                      _infoRow(Icons.location_on, localEvent.location),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 12),

            // ---------- Logistics ----------
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Logistics',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _booleanTile(
                      'Accommodation covered',
                      localEvent.accommodationCovered,
                    ),
                    const SizedBox(height: 8),
                    _booleanTile('Travel covered', localEvent.travelCovered),
                    const SizedBox(height: 8),
                    _booleanTile(
                      'Conference fee covered',
                      localEvent.conferenceFeeCovered,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 12),

            // ---------- Contact / Support ----------
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Contact & Support',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _infoRow(
                      Icons.email_outlined,
                      'Speaker support email: ${localEvent.speakerSupportEmail}',
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 12),

            // ---------- Full description ----------
            if (localEvent.description.isNotEmpty) ...[
              const Text(
                'About this event',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                localEvent.description,
                style: const TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 16),
            ],

            // ---------- Beautiful Apply button ----------
            if (!hideApplyButton) ...[
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () => _handleApply(context),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: EdgeInsets.zero,
                    elevation: 4,
                  ).copyWith(
                    backgroundColor: MaterialStateProperty.resolveWith(
                      (_) => Colors.transparent,
                    ),
                  ),
                  child: Ink(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.send_rounded, color: Colors.white),
                        SizedBox(width: 8),
                        Text(
                          'Apply to Event',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
