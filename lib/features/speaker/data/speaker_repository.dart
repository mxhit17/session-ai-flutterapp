import 'package:session.ai/features/speaker/data/speaker_api.dart';
import 'package:session.ai/features/speaker/models/my_sessions_response.dart';

class SpeakerRepository {
  final SpeakerApi _api = SpeakerApi();

  Future<List<MySessionsResponse>> getMySessions() async {
    try {
      return await _api.getMySession();
    } catch (e) {
      throw Exception("Failed to get sessions.");
    }
  }
}
