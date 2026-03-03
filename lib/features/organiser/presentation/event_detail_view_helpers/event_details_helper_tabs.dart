import 'package:flutter/material.dart';
import 'package:session.ai/features/organiser/data/organiser_repository.dart';
import 'package:session.ai/features/organiser/models/all_rooms_response.dart';
import 'package:session.ai/features/organiser/models/all_tracks_response.dart';
import 'package:session.ai/features/organiser/models/get_reviewer_pool_response.dart';
import 'package:session.ai/features/organiser/presentation/event_detail_view_helpers/search_reviewer_view.dart';
import 'package:session.ai/features/organiser/presentation/organiser_event_details_view.dart';

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
    eventId = parent?.event.id;

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
    eventId = parent?.event.id;

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

class ReviewersTab extends StatefulWidget {
  final String eventId;

  const ReviewersTab({super.key, required this.eventId});

  @override
  State<ReviewersTab> createState() => _ReviewersTabState();
}

class _ReviewersTabState extends State<ReviewersTab> {
  final OrganiserRepository _repository = OrganiserRepository();

  bool _isLoading = true;
  List<GetReviewerPoolResponse> _reviewers = [];

  @override
  void initState() {
    super.initState();
    _fetchReviewers();
  }

  Future<void> _fetchReviewers() async {
    setState(() => _isLoading = true);

    try {
      final data = await _repository.getReviewerPool(widget.eventId);

      if (mounted) {
        setState(() {
          _reviewers = data;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Failed to load reviewers")));
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _removeReviewer(GetReviewerPoolResponse reviewer) async {
    try {
      await _repository.removeReviewer(widget.eventId, reviewer.reviewerId);

      setState(() {
        _reviewers.removeWhere((r) => r.id == reviewer.id);
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Reviewer removed")));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to remove reviewer")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _reviewers.isEmpty
              ? const Center(
                child: Text(
                  "No reviewers added yet.\nTap + to add reviewers.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
              )
              : RefreshIndicator(
                onRefresh: _fetchReviewers,
                child: ListView.builder(
                  itemCount: _reviewers.length,
                  itemBuilder: (context, index) {
                    final reviewer = _reviewers[index];

                    return Dismissible(
                      key: ValueKey(reviewer.id),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 20),
                        color: Colors.red,
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      confirmDismiss: (_) async {
                        return await showDialog(
                          context: context,
                          builder:
                              (_) => AlertDialog(
                                title: const Text("Remove Reviewer"),
                                content: const Text(
                                  "Are you sure you want to remove this reviewer?",
                                ),
                                actions: [
                                  TextButton(
                                    onPressed:
                                        () => Navigator.pop(context, false),
                                    child: const Text("Cancel"),
                                  ),
                                  TextButton(
                                    onPressed:
                                        () => Navigator.pop(context, true),
                                    child: const Text("Remove"),
                                  ),
                                ],
                              ),
                        );
                      },
                      onDismissed: (_) => _removeReviewer(reviewer),
                      child: ListTile(
                        leading: const CircleAvatar(child: Icon(Icons.person)),
                        title: Text(reviewer.user.fullName),
                        subtitle: Text(reviewer.user.email),
                      ),
                    );
                  },
                ),
              ),

      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => SearchReviewersScreen(eventId: widget.eventId),
            ),
          );

          if (result == true) {
            _fetchReviewers(); // refresh after adding
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
