import 'package:dio/dio.dart';
import 'package:session.ai/features/speaker/models/my_sessions_response.dart';
import 'package:session.ai/injection_container.dart';
import 'package:session.ai/utils/constants/api_constants.dart';
import 'package:session.ai/utils/network/dio_client.dart';

class SpeakerApi {
  final Dio _client = sl<DioClient>().instance;

  Future<List<MySessionsResponse>> getMySession() async {
    final response = await _client.get(ApiConstants.mySessions);

    final List data = response.data;

    return data.map((e) => MySessionsResponse.fromJson(e)).toList();
  }
}
