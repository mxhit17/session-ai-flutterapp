import 'package:session.ai/core/events/models/get_events_response.dart';
import 'package:session.ai/features/organiser/data/organiser_api.dart';
import 'package:session.ai/features/organiser/models/all_rooms_response.dart';
import 'package:session.ai/features/organiser/models/all_tracks_response.dart';
import 'package:session.ai/features/organiser/models/create_schedule_response.dart';
import 'package:session.ai/features/organiser/models/get_reviewer_pool_response.dart';
import 'package:session.ai/features/organiser/models/get_schedule_response.dart';
import 'package:session.ai/features/organiser/models/get_user_response.dart';
import 'package:session.ai/features/organiser/models/reviewed_sessions_response.dart';

class OrganiserRepository {
  final OrganiserApi _api = OrganiserApi();

  Future<List<GetEventsResponse>> getMyEventsOrganiser() async {
    try {
      return await _api.getMyEventsOrganiser();
    } catch (e) {
      throw Exception("Failed to get events.");
    }
  }

  /// 🔹 UPDATE EVENT
  Future<void> updateEvent(String eventId, Map<String, dynamic> data) async {
    try {
      await _api.updateEvent(eventId, data);
    } catch (e) {
      throw Exception("Failed to update event.");
    }
  }

  /// 🔹 DELETE EVENT
  Future<void> deleteEvent(String eventId) async {
    try {
      await _api.deleteEvent(eventId);
    } catch (e) {
      throw Exception("Failed to delete event.");
    }
  }

  // =========================
  // TRACKS
  // =========================

  /// 🔹 CREATE TRACK
  Future<void> createTrack(String eventId, Map<String, dynamic> data) async {
    try {
      await _api.createTrack(eventId, data);
    } catch (e) {
      throw Exception("Failed to create track.");
    }
  }

  /// 🔹 GET ALL TRACKS
  Future<List<AllTracksResponse>> getAllTracks(String eventId) async {
    try {
      return await _api.getAllTracks(eventId);
    } catch (e) {
      throw Exception("Failed to fetch tracks.");
    }
  }

  /// 🔹 UPDATE TRACK
  Future<void> updateTrack(String trackId, Map<String, dynamic> data) async {
    try {
      await _api.updateTrack(trackId, data);
    } catch (e) {
      throw Exception("Failed to update track.");
    }
  }

  /// 🔹 DELETE TRACK
  Future<void> deleteTrack(String trackId) async {
    try {
      await _api.deleteTrack(trackId);
    } catch (e) {
      throw Exception("Failed to delete track.");
    }
  }

  // =========================
  // ROOMS
  // =========================

  /// 🔹 CREATE ROOM
  Future<void> createRoom(Map<String, dynamic> data) async {
    try {
      await _api.createRoom(data);
    } catch (e) {
      throw Exception("Failed to create room.");
    }
  }

  /// 🔹 GET ROOMS BY EVENT
  Future<List<GetAllRoomsResponse>> getRoomsByEvent(String eventId) async {
    try {
      return await _api.getRoomsByEvent(eventId);
    } catch (e) {
      throw Exception("Failed to fetch rooms.");
    }
  }

  /// 🔹 GET SINGLE ROOM
  Future<GetAllRoomsResponse> getSingleRoom(String roomId) async {
    try {
      return await _api.getSingleRoom(roomId);
    } catch (e) {
      throw Exception("Failed to fetch room.");
    }
  }

  /// 🔹 UPDATE ROOM
  Future<void> updateRoom(String roomId, Map<String, dynamic> data) async {
    try {
      await _api.updateRoom(roomId, data);
    } catch (e) {
      throw Exception("Failed to update room.");
    }
  }

  /// 🔹 DELETE ROOM
  Future<void> deleteRoom(String roomId) async {
    try {
      await _api.deleteRoom(roomId);
    } catch (e) {
      throw Exception("Failed to delete room.");
    }
  }

  // -------
  // handle cfp
  // -------
  Future<void> handleCFP(String eventId, Map<String, dynamic> map) async {
    try {
      await _api.handleCFP(eventId, map);
    } catch (e) {
      throw Exception("Could not modify CFP.");
    }
  }

  // Reviewer Pool
  Future<List<GetReviewerPoolResponse>> getReviewerPool(String eventId) async {
    try {
      return await _api.getReviewerPool(eventId);
    } catch (_) {
      throw Exception("Failed to fetch reviewers.");
    }
  }

  Future<void> addReviewer(String eventId, String reviewerId) async {
    try {
      await _api.addReviewer(eventId, reviewerId);
    } catch (_) {
      throw Exception("Failed to add reviewer.");
    }
  }

  Future<void> removeReviewer(String eventId, String reviewerId) async {
    try {
      await _api.removeReviewer(eventId, reviewerId);
    } catch (_) {
      throw Exception("Failed to remove reviewer.");
    }
  }

  Future<List<GetUsersModel>> searchUsers(String query) async {
    try {
      return await _api.searchUsers(query);
    } catch (_) {
      throw Exception("Failed to search users.");
    }
  }

  // =========================
  // REVIEWED SESSIONS
  // =========================

  Future<List<ReviewedSession>> getReviewedSessions(String eventId) async {
    try {
      return await _api.getReviewedSessions(eventId);
    } catch (_) {
      throw Exception("Failed to fetch reviewed sessions.");
    }
  }

  // =========================
  // SESSION STATUS UPDATE
  // =========================

  Future<void> updateSessionStatus(String sessionId, String status) async {
    try {
      await _api.updateSessionStatus(sessionId, status);
    } catch (_) {
      throw Exception("Failed to update session status.");
    }
  }

  // =========================
  // CREATE SCHEDULE
  // =========================

  Future<CreateSchedule> createSchedule({
    required String eventId,
    required String startDate,
    required String dayStartTime,
    required String dayEndTime,
  }) async {
    try {
      return await _api.createSchedule(
        eventId: eventId,
        startDate: startDate,
        dayStartTime: dayStartTime,
        dayEndTime: dayEndTime,
      );
    } catch (_) {
      throw Exception("Failed to create schedule.");
    }
  }

  // =========================
  // GET SCHEDULE
  // =========================

  Future<List<GetSchedule>> getSchedule(String eventId) async {
    try {
      return await _api.getSchedule(eventId);
    } catch (_) {
      throw Exception("Failed to fetch schedule.");
    }
  }

  // =========================
  // GET SCHEDULE BY DAY
  // =========================

  Future<List<GetSchedule>> getScheduleByDay(
    String eventId,
    String date,
  ) async {
    try {
      return await _api.getScheduleByDay(eventId, date);
    } catch (_) {
      throw Exception("Failed to fetch schedule for day.");
    }
  }
}
