import 'package:flutter/material.dart';
import 'package:session.ai/features/reviewer/data/reviewer_api.dart';
import 'package:session.ai/features/reviewer/models/get_assigned_session_details.dart';
import 'package:session.ai/features/reviewer/presentation/helper_screens/review_submit_view.dart';

class ReviewerSessionDetailsScreen extends StatefulWidget {
  final String sessionId;

  const ReviewerSessionDetailsScreen({super.key, required this.sessionId});

  @override
  State<ReviewerSessionDetailsScreen> createState() =>
      _ReviewerSessionDetailsScreenState();
}

class _ReviewerSessionDetailsScreenState
    extends State<ReviewerSessionDetailsScreen> {
  late Future<GetAssignedSessionDetails> _future;

  final ReviewerApi _api = ReviewerApi();

  @override
  void initState() {
    super.initState();
    _future = _api.getSessionDetails(widget.sessionId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Session Details")),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.rate_review),
        label: const Text("Review"),
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ReviewSubmitScreen(sessionId: widget.sessionId),
            ),
          );

          /// Refresh session details after review submission
          if (result == true) {
            setState(() {
              _future = _api.getSessionDetails(widget.sessionId);
            });
          }
        },
      ),
      body: FutureBuilder<GetAssignedSessionDetails>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          final session = snapshot.data!;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// TITLE
                Text(
                  session.title,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                /// LEVEL + STATUS
                Row(
                  children: [
                    Chip(label: Text(session.level)),
                    const SizedBox(width: 10),
                    Chip(label: Text(session.status)),
                  ],
                ),

                const SizedBox(height: 16),

                /// ABSTRACT
                const Text(
                  "Abstract",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),

                const SizedBox(height: 8),

                Text(session.abstract),

                const SizedBox(height: 24),

                /// EVENT INFO
                const Text(
                  "Event",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),

                const SizedBox(height: 8),

                Card(
                  child: ListTile(
                    title: Text(session.event.title),
                    subtitle: Text(session.event.location),
                    trailing: Text(
                      "${session.event.startDate.toLocal().toString().split(" ")[0]}",
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                /// TRACK
                if (session.track != null) ...[
                  const Text(
                    "Track",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),

                  const SizedBox(height: 8),

                  Chip(label: Text(session.track!.name)),

                  const SizedBox(height: 24),
                ],

                /// SPEAKERS
                const Text(
                  "Speakers",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),

                const SizedBox(height: 8),

                Column(
                  children:
                      session.sessionSpeakers.map((speaker) {
                        final profile = speaker.speakerProfile;

                        return Card(
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundImage:
                                  profile.profilePhotoUrl != null
                                      ? NetworkImage(profile.profilePhotoUrl!)
                                      : null,
                              child:
                                  profile.profilePhotoUrl == null
                                      ? const Icon(Icons.person)
                                      : null,
                            ),
                            title: Text(profile.user.fullName),
                            subtitle: Text(profile.organization),
                          ),
                        );
                      }).toList(),
                ),

                const SizedBox(height: 24),

                /// REVIEWS
                const Text(
                  "Reviews",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),

                const SizedBox(height: 8),

                if (session.reviews.isEmpty) const Text("No reviews yet"),

                Column(
                  children:
                      session.reviews.map((review) {
                        return Card(
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.star,
                                      color: Colors.orange,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      review.score.toString(),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 6),

                                Text(review.comment),

                                if (review.aiAnalysis != null) ...[
                                  const SizedBox(height: 10),
                                  const Divider(),

                                  Text(
                                    "AI Analysis",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey[700],
                                    ),
                                  ),

                                  const SizedBox(height: 6),

                                  Text("Depth: ${review.aiAnalysis!.depth}"),
                                  Text(
                                    "Clarity: ${review.aiAnalysis!.clarity}",
                                  ),
                                  Text(
                                    "Novelty: ${review.aiAnalysis!.novelty}",
                                  ),
                                  Text(
                                    "Overall: ${review.aiAnalysis!.overallScore}",
                                  ),
                                ],
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                ),

                const SizedBox(height: 30),
              ],
            ),
          );
        },
      ),
    );
  }
}
