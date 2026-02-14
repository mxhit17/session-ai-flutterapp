import 'package:dio/dio.dart';
import 'package:session.ai/features/events/models/all_events_list_response.dart';
import 'package:session.ai/injection_container.dart';
import 'package:session.ai/utils/constants/api_constants.dart';
import 'package:session.ai/utils/network/dio_client.dart';

class EventsApi {
  final Dio _client = sl<DioClient>().instance;

  Future<AllEventsList> fetchEvents() async {
    final response = await _client.get(ApiConstants.events);

    final List data = response.data;

    return AllEventsList.fromJson(data);
  }
}
