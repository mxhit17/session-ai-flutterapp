import 'package:session.ai/core/events/models/get_events_response.dart';
import 'package:session.ai/features/organiser/data/organiser_api.dart';

class OrganiserRepository {
  final OrganiserApi _api = OrganiserApi();

  Future<List<GetEventsResponse>> getMyEventsOrganiser() async {
    try {
      return await _api.getMyEventsOrganiser();
    } catch (e) {
      throw Exception("Failed to get events.");
    }
  }
}
