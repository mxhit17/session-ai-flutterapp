import 'package:session.ai/features/events/models/all_events_list_response.dart';

import 'events_api.dart';

class EventsRepository {
  final EventsApi _api = EventsApi();

  Future<AllEventsList> getEvents() async {
    try {
      return await _api.fetchEvents();
    } catch (e) {
      throw Exception("Failed to fetch events");
    }
  }
}
