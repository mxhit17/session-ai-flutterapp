class GetSchedule {
  final String sessionId;
  final String title;
  final String roomId;
  final String roomName;
  final DateTime startTime;
  final DateTime endTime;

  GetSchedule({
    required this.sessionId,
    required this.title,
    required this.roomId,
    required this.roomName,
    required this.startTime,
    required this.endTime,
  });

  factory GetSchedule.fromJson(Map<String, dynamic> json) {
    return GetSchedule(
      sessionId: json['sessionId'],
      title: json['title'],
      roomId: json['roomId'],
      roomName: json['roomName'],
      startTime: DateTime.parse(json['startTime']),
      endTime: DateTime.parse(json['endTime']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sessionId': sessionId,
      'title': title,
      'roomId': roomId,
      'roomName': roomName,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
    };
  }

  static List<GetSchedule> listFromJson(List<dynamic> jsonList) {
    return jsonList.map((e) => GetSchedule.fromJson(e)).toList();
  }
}
