class ApiConstants {
  static const String baseUrl = "http://localhost:3000/";

  static const String events = "api/events";
  static const String auth = "users/";
  static const String login = "${auth}login";
  static const String register = "${auth}register";
  static const String mySessions = "speaker/sessions";
  static const String speakerProfile = "speaker/profile";
  static const String submitSession = "api/sessions";
  static const String searchUsers = "users";

  // events
  static const String createEvent = "api/events";
  static const String getMyEventsOrganiser = "/api/events/my-events";
  static String updateEvent(String id) => "/api/events/$id";
  static String deleteEvent(String id) => "/api/events/$id";

  // tracks
  static String createTrack(String eventId) => "events/$eventId/tracks";
  static String getAllTracks(String eventId) => "events/$eventId/tracks";
  static String updateTrack(String trackId) => "tracks/$trackId";
  static String deleteTrack(String trackId) => "tracks/$trackId";

  // =========================
  // ROOMS
  // =========================

  static const String createRoom = "rooms";
  static String getRoomsByEvent(String eventId) => "rooms/event/$eventId";
  static String getSingleRoom(String roomId) => "rooms/$roomId";
  static String updateRoom(String roomId) => "rooms/$roomId";
  static String deleteRoom(String roomId) => "rooms/$roomId";

  // ----------
  // cfp
  // ----------
  static String handleCFP(String eventId) => "events/$eventId/cfp";

  // reviewer pool
  static String getReviewerPool(String eventId) => "events/$eventId/reviewers";
  static String addReviewer(String eventId) => "events/$eventId/reviewers";
  static String removeReviewer(String eventId, String reviewerId) =>
      "events/$eventId/reviewers/$reviewerId";

  // reviewer module
  static const String reviewerBase = "reviewer";

  static const String reviewerSessions = "$reviewerBase/sessions";
  static const String reviewedSessions = "$reviewerBase/sessions/reviewed";

  static const String reviewerDashboardStats = "$reviewerBase/dashboard/stats";

  static String getReviewedSessions(String eventId) =>
      "/api/events/$eventId/reviewed-sessions";

  static String updateSessionStatus(String sessionId) =>
      "/api/sessions/$sessionId/status";

  static String autoSchedule(String eventId) =>
      "/events/$eventId/schedule/auto";

  static String getSchedule(String eventId) => "/events/$eventId/schedule";

  static String getScheduleByDay(String eventId, String date) =>
      "/events/$eventId/schedule/day/$date";
}
