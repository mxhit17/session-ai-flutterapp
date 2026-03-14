import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:session.ai/features/organiser/data/organiser_repository.dart';
import 'package:session.ai/features/organiser/models/get_schedule_response.dart';

class ScheduleBuilderScreen extends StatefulWidget {
  final String eventId;

  const ScheduleBuilderScreen({super.key, required this.eventId});

  @override
  State<ScheduleBuilderScreen> createState() => _ScheduleBuilderScreenState();
}

class _ScheduleBuilderScreenState extends State<ScheduleBuilderScreen> {
  final OrganiserRepository _repo = OrganiserRepository();

  DateTime? startDate;
  TimeOfDay? startTime;
  TimeOfDay? endTime;

  bool loading = false;

  Future<void> generateSchedule() async {
    if (startDate == null || startTime == null || endTime == null) return;

    setState(() => loading = true);

    try {
      final result = await _repo.createSchedule(
        eventId: widget.eventId,
        startDate: DateFormat('yyyy-MM-dd').format(startDate!),
        dayStartTime: startTime!.format(context),
        dayEndTime: endTime!.format(context),
      );

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(result.message)));

      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to generate schedule")),
      );
    }

    setState(() => loading = false);
  }

  Future<void> pickDate() async {
    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
      initialDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() => startDate = picked);
    }
  }

  Future<void> pickStartTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 9, minute: 0),
    );

    if (picked != null) {
      setState(() => startTime = picked);
    }
  }

  Future<void> pickEndTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 17, minute: 0),
    );

    if (picked != null) {
      setState(() => endTime = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Generate Schedule")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            ListTile(
              title: const Text("Start Date"),
              subtitle: Text(
                startDate == null
                    ? "Select date"
                    : DateFormat.yMMMMd().format(startDate!),
              ),
              trailing: const Icon(Icons.calendar_today),
              onTap: pickDate,
            ),

            ListTile(
              title: const Text("Day Start Time"),
              subtitle: Text(
                startTime == null ? "Select time" : startTime!.format(context),
              ),
              trailing: const Icon(Icons.access_time),
              onTap: pickStartTime,
            ),

            ListTile(
              title: const Text("Day End Time"),
              subtitle: Text(
                endTime == null ? "Select time" : endTime!.format(context),
              ),
              trailing: const Icon(Icons.access_time),
              onTap: pickEndTime,
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: loading ? null : generateSchedule,
                child:
                    loading
                        ? const CircularProgressIndicator()
                        : const Text("Generate Schedule"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ScheduleScreen extends StatefulWidget {
  final String eventId;

  const ScheduleScreen({super.key, required this.eventId});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  final OrganiserRepository _repo = OrganiserRepository();

  List<GetSchedule> schedule = [];
  bool loading = true;

  Map<String, List<GetSchedule>> groupedSchedule = {};

  @override
  void initState() {
    super.initState();
    fetchSchedule();
  }

  Future<void> fetchSchedule() async {
    setState(() => loading = true);

    try {
      final data = await _repo.getSchedule(widget.eventId);

      schedule = data;

      /// Group sessions by day
      groupedSchedule.clear();
      for (var s in schedule) {
        final key = DateFormat('yyyy-MM-dd').format(s.startTime);
        groupedSchedule.putIfAbsent(key, () => []);
        groupedSchedule[key]!.add(s);
      }
    } catch (_) {}

    setState(() => loading = false);
  }

  Color roomColor(String room) {
    final colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.teal,
    ];

    return colors[room.hashCode % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    final days = groupedSchedule.keys.toList();

    return DefaultTabController(
      length: days.isEmpty ? 1 : days.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Event Schedule"),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: fetchSchedule,
            ),
          ],
          bottom:
              days.isEmpty
                  ? null
                  : TabBar(
                    isScrollable: true,
                    tabs:
                        days
                            .map(
                              (d) => Tab(
                                text: DateFormat(
                                  'dd MMM',
                                ).format(DateTime.parse(d)),
                              ),
                            )
                            .toList(),
                  ),
        ),

        floatingActionButton: FloatingActionButton.extended(
          icon: const Icon(Icons.auto_fix_high),
          label: const Text("Generate"),
          onPressed: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ScheduleBuilderScreen(eventId: widget.eventId),
              ),
            );

            if (result == true) {
              fetchSchedule();
            }
          },
        ),

        body:
            loading
                ? const Center(child: CircularProgressIndicator())
                : schedule.isEmpty
                ? _emptyState()
                : TabBarView(
                  children:
                      days.map((day) {
                        final sessions = groupedSchedule[day]!;

                        return RefreshIndicator(
                          onRefresh: fetchSchedule,
                          child: ListView.builder(
                            padding: const EdgeInsets.all(16),
                            itemCount: sessions.length,
                            itemBuilder: (context, index) {
                              final session = sessions[index];

                              return _sessionCard(session);
                            },
                          ),
                        );
                      }).toList(),
                ),
      ),
    );
  }

  Widget _sessionCard(GetSchedule session) {
    final start = DateFormat('hh:mm a').format(session.startTime.toLocal());
    final end = DateFormat('hh:mm a').format(session.endTime.toLocal());

    final color = roomColor(session.roomName);

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// TIME COLUMN
          Column(
            children: [
              Text(
                start,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              Container(width: 2, height: 70, color: Colors.grey.shade300),
            ],
          ),

          const SizedBox(width: 12),

          /// SESSION CARD
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: color.withOpacity(.08),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: color.withOpacity(.25)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// TITLE
                  Text(
                    session.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 10),

                  /// ROOM CHIP
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          session.roomName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ),

                      const SizedBox(width: 10),

                      Text(
                        "$start - $end",
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _emptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.event_busy, size: 70, color: Colors.grey),
          SizedBox(height: 20),
          Text(
            "No Schedule Generated",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 6),
          Text("Generate schedule to see sessions here."),
        ],
      ),
    );
  }
}
