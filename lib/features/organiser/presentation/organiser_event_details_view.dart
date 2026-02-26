import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:session.ai/features/organiser/data/organiser_repository.dart';
import 'package:session.ai/features/organiser/models/all_rooms_response.dart';
import 'package:session.ai/features/organiser/models/all_tracks_response.dart';

class OrganizerEventDetailScreen extends StatelessWidget {
  final String eventId;

  final String title;
  final DateTime startDate;
  final DateTime endDate;
  final String location;
  final bool isCfpOpen;

  const OrganizerEventDetailScreen({
    super.key,
    required this.eventId,
    required this.title,
    required this.startDate,
    required this.endDate,
    required this.location,
    required this.isCfpOpen,
  });

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd MMM yyyy');

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(title: const Text("Event Management")),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// ===== EVENT HEADER =====
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: _EventHeader(
                title: title,
                startDate: dateFormat.format(startDate),
                endDate: dateFormat.format(endDate),
                location: location,
                isCfpOpen: isCfpOpen,
              ),
            ),

            /// ===== TAB BAR =====
            const TabBar(tabs: [Tab(text: "Tracks"), Tab(text: "Rooms")]),

            /// ===== TAB CONTENT =====
            const Expanded(
              child: TabBarView(children: [TracksTab(), RoomsTab()]),
            ),
          ],
        ),
      ),
    );
  }
}

class _EventHeader extends StatelessWidget {
  final String title;
  final String startDate;
  final String endDate;
  final String location;
  final bool isCfpOpen;

  const _EventHeader({
    required this.title,
    required this.startDate,
    required this.endDate,
    required this.location,
    required this.isCfpOpen,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Event Title
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),

        /// Dates
        Row(
          children: [
            const Icon(Icons.calendar_today, size: 18),
            const SizedBox(width: 6),
            Text("$startDate - $endDate"),
          ],
        ),
        const SizedBox(height: 6),

        /// Location
        Row(
          children: [
            const Icon(Icons.location_on_outlined, size: 18),
            const SizedBox(width: 6),
            Text(location),
          ],
        ),
        const SizedBox(height: 12),

        /// CFP Badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: isCfpOpen ? Colors.green.shade100 : Colors.red.shade100,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            isCfpOpen ? "CFP Open" : "CFP Closed",
            style: TextStyle(
              color: isCfpOpen ? Colors.green.shade800 : Colors.red.shade800,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

class TracksTab extends StatefulWidget {
  const TracksTab({super.key});

  @override
  State<TracksTab> createState() => _TracksTabState();
}

class _TracksTabState extends State<TracksTab> {
  late Future<List<AllTracksResponse>> _tracksFuture;
  final OrganiserRepository _repository = OrganiserRepository();

  String? eventId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Get eventId from parent screen
    final parent =
        context.findAncestorWidgetOfExactType<OrganizerEventDetailScreen>();
    eventId = parent?.eventId;

    _loadTracks();
  }

  void _loadTracks() {
    if (eventId != null) {
      _tracksFuture = _repository.getAllTracks(eventId!);
    }
  }

  Future<void> _refresh() async {
    setState(() {
      _loadTracks();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (eventId == null) {
      return const Center(child: Text("Event ID not found"));
    }

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openTrackSheet(),
        child: const Icon(Icons.add),
      ),
      body: FutureBuilder<List<AllTracksResponse>>(
        future: _tracksFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No tracks yet"));
          }

          final tracks = snapshot.data!;

          return RefreshIndicator(
            onRefresh: _refresh,
            child: ListView.builder(
              itemCount: tracks.length,
              itemBuilder: (context, index) {
                final track = tracks[index];

                return Dismissible(
                  key: ValueKey(track.id),
                  direction: DismissDirection.endToStart,
                  confirmDismiss: (_) async {
                    return await _showDeleteDialog(track.id);
                  },
                  onDismissed: (_) async {
                    await _repository.deleteTrack(track.id);
                    _refresh();
                  },
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    color: Colors.red,
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  child: ListTile(
                    title: Text(track.name),
                    subtitle: Text(track.description),
                    trailing: IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => _openTrackSheet(track: track),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Future<bool> _showDeleteDialog(String trackId) async {
    return await showDialog<bool>(
          context: context,
          builder:
              (_) => AlertDialog(
                title: const Text("Delete Track"),
                content: const Text(
                  "Are you sure you want to delete this track?",
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text("Cancel"),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: const Text(
                      "Delete",
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              ),
        ) ??
        false;
  }

  void _openTrackSheet({AllTracksResponse? track}) {
    final nameController = TextEditingController(text: track?.name ?? "");
    final descriptionController = TextEditingController(
      text: track?.description ?? "",
    );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder:
          (_) => Padding(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              top: 20,
              bottom: MediaQuery.of(context).viewInsets.bottom + 20,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  track == null ? "Create Track" : "Edit Track",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),

                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: "Track Name",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),

                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(
                    labelText: "Description",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      final data = {
                        "name": nameController.text,
                        "description": descriptionController.text,
                      };

                      if (track == null) {
                        await _repository.createTrack(eventId!, data);
                      } else {
                        await _repository.updateTrack(track.id, data);
                      }

                      Navigator.pop(context);
                      _refresh();
                    },
                    child: Text(track == null ? "Create" : "Update"),
                  ),
                ),
              ],
            ),
          ),
    );
  }
}

class RoomsTab extends StatefulWidget {
  const RoomsTab({super.key});

  @override
  State<RoomsTab> createState() => _RoomsTabState();
}

class _RoomsTabState extends State<RoomsTab> {
  late Future<List<GetAllRoomsResponse>> _roomsFuture;
  final OrganiserRepository _repository = OrganiserRepository();

  String? eventId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final parent =
        context.findAncestorWidgetOfExactType<OrganizerEventDetailScreen>();
    eventId = parent?.eventId;

    _loadRooms();
  }

  void _loadRooms() {
    if (eventId != null) {
      _roomsFuture = _repository.getRoomsByEvent(eventId!);
    }
  }

  Future<void> _refresh() async {
    setState(() {
      _loadRooms();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (eventId == null) {
      return const Center(child: Text("Event ID not found"));
    }

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openRoomSheet(),
        child: const Icon(Icons.add),
      ),
      body: FutureBuilder<List<GetAllRoomsResponse>>(
        future: _roomsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No rooms yet"));
          }

          final rooms = snapshot.data!;

          return RefreshIndicator(
            onRefresh: _refresh,
            child: ListView.builder(
              itemCount: rooms.length,
              itemBuilder: (context, index) {
                final room = rooms[index];

                return Dismissible(
                  key: ValueKey(room.id),
                  direction: DismissDirection.endToStart,
                  confirmDismiss: (_) async {
                    return await _showDeleteDialog();
                  },
                  onDismissed: (_) async {
                    await _repository.deleteRoom(room.id);
                    _refresh();
                  },
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    color: Colors.red,
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  child: ListTile(
                    title: Text(room.name),
                    subtitle: Text("Capacity: ${room.capacity}"),
                    trailing: IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => _openRoomSheet(room: room),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Future<bool> _showDeleteDialog() async {
    return await showDialog<bool>(
          context: context,
          builder:
              (_) => AlertDialog(
                title: const Text("Delete Room"),
                content: const Text(
                  "Are you sure you want to delete this room?",
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text("Cancel"),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: const Text(
                      "Delete",
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              ),
        ) ??
        false;
  }

  void _openRoomSheet({GetAllRoomsResponse? room}) {
    final nameController = TextEditingController(text: room?.name ?? "");
    final capacityController = TextEditingController(
      text: room != null ? room.capacity.toString() : "",
    );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder:
          (_) => Padding(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              top: 20,
              bottom: MediaQuery.of(context).viewInsets.bottom + 20,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  room == null ? "Create Room" : "Edit Room",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),

                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: "Room Name",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),

                TextField(
                  controller: capacityController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "Capacity",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      final data = {
                        "eventId": eventId,
                        "name": nameController.text,
                        "capacity": int.tryParse(capacityController.text) ?? 0,
                      };

                      if (room == null) {
                        await _repository.createRoom(data);
                      } else {
                        await _repository.updateRoom(room.id, {
                          "name": nameController.text,
                          "capacity":
                              int.tryParse(capacityController.text) ?? 0,
                        });
                      }

                      Navigator.pop(context);
                      _refresh();
                    },
                    child: Text(room == null ? "Create" : "Update"),
                  ),
                ),
              ],
            ),
          ),
    );
  }
}
