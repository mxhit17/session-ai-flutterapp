class ApiConstants {
  static const String baseUrl = "http://localhost:3000/";

  static const String events = "api/events";
  static const String auth = "users/";
  static const String login = "${auth}login";
  static const String register = "${auth}register";
  static const String mySessions = "speaker/sessions";
  static const String speakerProfile = "speaker/profile";
  static const String submitSession = "api/sessions";

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
}
