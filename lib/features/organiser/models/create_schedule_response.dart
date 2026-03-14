class CreateSchedule {
  final String message;
  final int totalSessions;
  final List<ScheduledSession> scheduled;

  CreateSchedule({
    required this.message,
    required this.totalSessions,
    required this.scheduled,
  });

  factory CreateSchedule.fromJson(Map<String, dynamic> json) {
    return CreateSchedule(
      message: json['message'],
      totalSessions: json['totalSessions'],
      scheduled:
          (json['scheduled'] as List)
              .map((e) => ScheduledSession.fromJson(e))
              .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'totalSessions': totalSessions,
      'scheduled': scheduled.map((e) => e.toJson()).toList(),
    };
  }
}

class ScheduledSession {
  final String sessionId;
  final String room;
  final DateTime start;
  final DateTime end;

  ScheduledSession({
    required this.sessionId,
    required this.room,
    required this.start,
    required this.end,
  });

  factory ScheduledSession.fromJson(Map<String, dynamic> json) {
    return ScheduledSession(
      sessionId: json['sessionId'],
      room: json['room'],
      start: DateTime.parse(json['start']),
      end: DateTime.parse(json['end']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sessionId': sessionId,
      'room': room,
      'start': start.toIso8601String(),
      'end': end.toIso8601String(),
    };
  }
}
