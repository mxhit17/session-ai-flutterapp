import 'package:session.ai/core/sessions/data/sessions_api.dart';
import 'package:session.ai/core/sessions/models/submit_session_response.dart';

class SessionsRepository {
  final SessionsApi _api = SessionsApi();

  Future<SubmitSessionResponse> submitSession(
    Map<String, dynamic> sessionMap,
  ) async {
    try {
      return await _api.submitSession(sessionMap);
    } catch (e) {
      throw Exception("Failed to submit session.");
    }
  }
}
