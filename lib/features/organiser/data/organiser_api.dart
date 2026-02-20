import 'package:dio/dio.dart';
import 'package:session.ai/core/events/models/get_events_response.dart';
import 'package:session.ai/injection_container.dart';
import 'package:session.ai/utils/constants/api_constants.dart';
import 'package:session.ai/utils/network/dio_client.dart';

class OrganiserApi {
  final Dio _client = sl<DioClient>().instance;

  Future<List<GetEventsResponse>> getMyEventsOrganiser() async {
    final response = await _client.get(ApiConstants.getMyEventsOrganiser);

    final List data = response.data;

    return data.map((e) => GetEventsResponse.fromJson(e)).toList();
  }
}
