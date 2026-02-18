import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:session.ai/features/speaker/data/speaker_repository.dart';
import 'package:session.ai/features/speaker/models/get_speaker_profile_response.dart';
import 'package:session.ai/features/speaker/models/my_sessions_response.dart';
import 'package:session.ai/features/speaker/models/update_speaker_profile_response.dart';
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

  Future<GetSpeakerProfile> getSpeakerProfile() async {
    final response = await _client.get(ApiConstants.speakerProfile);

    final data = response.data;

    return GetSpeakerProfile.fromJson(data);
  }

  Future<UpdateSpeakerProfile> updateSpeakerProfile(
    Map<String, dynamic> body,
  ) async {
    final response = await _client.patch(
      ApiConstants.speakerProfile,
      data: body,
    );

    return UpdateSpeakerProfile.fromJson(response.data);
  }
}

final speakerRepositoryProvider = Provider<SpeakerRepository>((ref) {
  return SpeakerRepository();
});

final speakerProfileProvider = FutureProvider<GetSpeakerProfile>((ref) async {
  final repo = ref.read(speakerRepositoryProvider);
  return repo.getSpeakerProfile();
});

final updateSpeakerProfileProvider = StateNotifierProvider<
  UpdateSpeakerProfileNotifier,
  AsyncValue<void>
>((ref) {
  return UpdateSpeakerProfileNotifier(ref.read(speakerRepositoryProvider), ref);
});

class UpdateSpeakerProfileNotifier extends StateNotifier<AsyncValue<void>> {
  final SpeakerRepository _repo;
  final Ref ref;

  UpdateSpeakerProfileNotifier(this._repo, this.ref)
    : super(const AsyncData(null));

  Future<void> updateField(Map<String, dynamic> body) async {
    state = const AsyncLoading();
    try {
      await _repo.updateSpeakerProfile(body);
      ref.invalidate(speakerProfileProvider);
      state = const AsyncData(null);
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }
}
