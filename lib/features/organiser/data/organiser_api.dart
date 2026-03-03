import 'package:dio/dio.dart';
import 'package:session.ai/core/events/models/get_events_response.dart';
import 'package:session.ai/features/organiser/models/all_rooms_response.dart';
import 'package:session.ai/features/organiser/models/all_tracks_response.dart';
import 'package:session.ai/features/organiser/models/get_reviewer_pool_response.dart';
import 'package:session.ai/features/organiser/models/get_user_response.dart';
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

  /// 🔹 UPDATE EVENT (PATCH)
  Future<void> updateEvent(String eventId, Map<String, dynamic> data) async {
    await _client.patch(ApiConstants.updateEvent(eventId), data: data);
  }

  /// 🔹 DELETE EVENT (SOFT DELETE)
  Future<void> deleteEvent(String eventId) async {
    await _client.delete(ApiConstants.deleteEvent(eventId));
  }

  // =========================
  // TRACKS
  // =========================

  /// 🔹 CREATE TRACK
  Future<void> createTrack(String eventId, Map<String, dynamic> data) async {
    await _client.post(ApiConstants.createTrack(eventId), data: data);
  }

  /// 🔹 GET ALL TRACKS
  Future<List<AllTracksResponse>> getAllTracks(String eventId) async {
    final response = await _client.get(ApiConstants.getAllTracks(eventId));

    final List data = response.data;

    return data.map((e) => AllTracksResponse.fromJson(e)).toList();
  }

  /// 🔹 UPDATE TRACK
  Future<void> updateTrack(String trackId, Map<String, dynamic> data) async {
    await _client.put(ApiConstants.updateTrack(trackId), data: data);
  }

  /// 🔹 DELETE TRACK
  Future<void> deleteTrack(String trackId) async {
    await _client.delete(ApiConstants.deleteTrack(trackId));
  }

  // =========================
  // ROOMS
  // =========================

  /// 🔹 CREATE ROOM
  Future<void> createRoom(Map<String, dynamic> data) async {
    await _client.post(ApiConstants.createRoom, data: data);
  }

  /// 🔹 GET ROOMS BY EVENT
  Future<List<GetAllRoomsResponse>> getRoomsByEvent(String eventId) async {
    final response = await _client.get(ApiConstants.getRoomsByEvent(eventId));

    final List data = response.data;

    return data.map((e) => GetAllRoomsResponse.fromJson(e)).toList();
  }

  /// 🔹 GET SINGLE ROOM
  Future<GetAllRoomsResponse> getSingleRoom(String roomId) async {
    final response = await _client.get(ApiConstants.getSingleRoom(roomId));

    return GetAllRoomsResponse.fromJson(response.data);
  }

  /// 🔹 UPDATE ROOM
  Future<void> updateRoom(String roomId, Map<String, dynamic> data) async {
    await _client.patch(ApiConstants.updateRoom(roomId), data: data);
  }

  /// 🔹 DELETE ROOM
  Future<void> deleteRoom(String roomId) async {
    await _client.delete(ApiConstants.deleteRoom(roomId));
  }

  // -----------
  // Handle CFP (Patch)
  // -----------
  Future<void> handleCFP(String eventId, Map<String, dynamic> map) async {
    await _client.patch(ApiConstants.handleCFP(eventId), data: map);
  }

  Future<List<GetReviewerPoolResponse>> getReviewerPool(String eventId) async {
    final response = await _client.get(ApiConstants.getReviewerPool(eventId));

    final List data = response.data;

    return data.map((e) => GetReviewerPoolResponse.fromJson(e)).toList();
  }

  Future<void> addReviewer(String eventId, String reviewerId) async {
    await _client.post(
      ApiConstants.addReviewer(eventId),
      data: {"reviewer_id": reviewerId},
    );
  }

  Future<void> removeReviewer(String eventId, String reviewerId) async {
    await _client.delete(ApiConstants.removeReviewer(eventId, reviewerId));
  }

  Future<List<GetUsersModel>> searchUsers(String query) async {
    final response = await _client.get(
      ApiConstants.searchUsers,
      queryParameters: {"search": query},
    );

    final List data = response.data;

    return data.map((e) => GetUsersModel.fromJson(e)).toList();
  }
}
