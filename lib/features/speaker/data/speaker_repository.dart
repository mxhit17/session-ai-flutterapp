import 'package:dio/dio.dart';
import 'package:session.ai/core/events/models/create_event_response.dart';
import 'package:session.ai/features/speaker/data/speaker_api.dart';
import 'package:session.ai/features/speaker/models/get_speaker_profile_response.dart';
import 'package:session.ai/features/speaker/models/my_sessions_response.dart';
import 'package:session.ai/features/speaker/models/update_speaker_profile_response.dart';

class SpeakerRepository {
  final SpeakerApi _api = SpeakerApi();

  Future<List<MySessionsResponse>> getMySessions() async {
    try {
      return await _api.getMySession();
    } catch (e) {
      throw Exception("Failed to get sessions.");
    }
  }

  Future<GetSpeakerProfile> getSpeakerProfile() async {
    try {
      return await _api.getSpeakerProfile();
    } catch (e) {
      throw Exception("Failed to get speaker profile.");
    }
  }

  Future<UpdateSpeakerProfile> updateSpeakerProfile(
    Map<String, dynamic> body,
  ) async {
    try {
      return await _api.updateSpeakerProfile(body);
    } catch (e) {
      throw Exception("Failed to update speaker profile.");
    }
  }

  Future<CreateEventResponse> createEvent(Map<String, dynamic> body) async {
    try {
      return await _api.createEvent(body);
    } on DioException catch (e) {
      final message = e.response?.data?['message'] ?? "Failed to create event.";
      throw Exception(message);
    } catch (e) {
      throw Exception("Something went wrong.");
    }
  }
}
