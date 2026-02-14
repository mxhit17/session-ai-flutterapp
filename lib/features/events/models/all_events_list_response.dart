class AllEventsList {
  final List<Event> events;

  AllEventsList({required this.events});

  factory AllEventsList.fromJson(List<dynamic> json) {
    return AllEventsList(events: json.map((e) => Event.fromJson(e)).toList());
  }

  List<Map<String, dynamic>> toJson() {
    return events.map((e) => e.toJson()).toList();
  }
}

class Event {
  final String id;
  final String title;
  final String description;
  final DateTime startDate;
  final DateTime endDate;
  final String location;
  final String timezone;
  final DateTime createdAt;

  Event({
    required this.id,
    required this.title,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.location,
    required this.timezone,
    required this.createdAt,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      startDate: DateTime.parse(json['start_date']),
      endDate: DateTime.parse(json['end_date']),
      location: json['location'],
      timezone: json['timezone'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'start_date': startDate.toIso8601String(),
      'end_date': endDate.toIso8601String(),
      'location': location,
      'timezone': timezone,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
