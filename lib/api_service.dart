import 'package:dio/dio.dart';
import 'package:session.ai/features/auth/models/register_response_model.dart';
import 'package:session.ai/features/auth/models/sign_in_model.dart';
import 'package:session.ai/features/create_event/data/models/create_session_response.dart';
import 'package:session.ai/features/upcomming_events/data/models/get_all_sessions_response.dart';
import 'package:session.ai/injection_container.dart';
import 'package:session.ai/utils/constants/urls.dart';
import 'package:session.ai/utils/network/dio_client.dart';

class ApiService {
  final Dio _dio = sl<DioClient>().instance;

  Future<SignInResponse> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dio.post(
        Urls.login,
        data: {"email": email, "password": password},
      );
      return SignInResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(_handleError(e));
    } catch (e) {
      throw Exception("Unexpected error: $e");
    }
  }

  Future<RegisterResponse> register({
    required String email,
    required String password,
    required String name,
    required String role,
  }) async {
    try {
      final response = await _dio.post(
        Urls.register,
        data: {
          "email": email,
          "password": password,
          "name": name,
          "role": role,
        },
      );
      return RegisterResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(_handleError(e));
    } catch (e) {
      throw Exception("Unexpected error: $e");
    }
  }

  // Add more APIs here (getUser, updateProfile, fetchItems, etc.)

  Future<CreateSessionResponse> createEvent({required eventMap}) async {
    try {
      final response = await _dio.post(Urls.createSession, data: eventMap);
      return CreateSessionResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(_handleError(e));
    } catch (e) {
      throw Exception("Unexpected error: $e");
    }
  }

  Future<GetAllSessionsResponse> getSessions() async {
    try {
      final response = await _dio.get(Urls.getSessions);
      return GetAllSessionsResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(_handleError(e));
    } catch (e) {
      throw Exception("Unexpected error: $e");
    }
  }

  String _handleError(DioException e) {
    if (e.response != null && e.response?.data != null) {
      return e.response?.data["message"] ?? "Unknown server error";
    } else {
      return e.message ?? "Network error occurred";
    }
  }
}
