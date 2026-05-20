import 'dart:ui';
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

  Widget glassCard({required Widget child}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.7),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.white.withOpacity(0.4)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }

  Widget sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, top: 16),
      child: Text(
        text,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FC),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text("Session Details"),
        foregroundColor: Colors.black87,
      ),

      floatingActionButton: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
          ),
          borderRadius: BorderRadius.circular(30),
        ),
        child: FloatingActionButton.extended(
          backgroundColor: Colors.transparent,
          elevation: 0,
          icon: const Icon(Icons.rate_review),
          label: const Text("Review"),
          onPressed: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ReviewSubmitScreen(sessionId: widget.sessionId),
              ),
            );

            if (result == true) {
              setState(() {
                _future = _api.getSessionDetails(widget.sessionId);
              });
            }
          },
        ),
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
                /// TITLE CARD
                glassCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        session.title,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),

                      Row(
                        children: [
                          _chip(session.level, Colors.blue),
                          const SizedBox(width: 8),
                          _chip(session.status, Colors.green),
                        ],
                      ),
                    ],
                  ),
                ),

                /// ABSTRACT
                sectionTitle("Abstract"),
                glassCard(child: Text(session.abstract)),

                /// EVENT
                sectionTitle("Event"),
                glassCard(
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(session.event.title),
                    subtitle: Text(session.event.location),
                    trailing: Text(
                      session.event.startDate.toLocal().toString().split(
                        " ",
                      )[0],
                    ),
                  ),
                ),

                /// TRACK
                if (session.track != null) ...[
                  sectionTitle("Track"),
                  glassCard(child: _chip(session.track!.name, Colors.purple)),
                ],

                /// SPEAKERS
                sectionTitle("Speakers"),
                Column(
                  children:
                      session.sessionSpeakers.map((speaker) {
                        final profile = speaker.speakerProfile;

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: glassCard(
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 24,
                                  backgroundImage:
                                      profile.profilePhotoUrl != null
                                          ? NetworkImage(
                                            profile.profilePhotoUrl!,
                                          )
                                          : null,
                                  child:
                                      profile.profilePhotoUrl == null
                                          ? const Icon(Icons.person)
                                          : null,
                                ),
                                const SizedBox(width: 12),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      profile.user.fullName,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      profile.organization,
                                      style: TextStyle(color: Colors.grey[600]),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                ),

                /// REVIEWS
                sectionTitle("Reviews"),

                if (session.reviews.isEmpty) const Text("No reviews yet"),

                Column(
                  children:
                      session.reviews.map((review) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: glassCard(
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

                                const SizedBox(height: 8),
                                Text(review.comment),

                                if (review.aiAnalysis != null) ...[
                                  const Divider(height: 20),

                                  const Text(
                                    "AI Analysis",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),

                                  const SizedBox(height: 6),

                                  Wrap(
                                    spacing: 10,
                                    children: [
                                      _chip(
                                        "Depth: ${review.aiAnalysis!.depth}",
                                        Colors.blue,
                                      ),
                                      _chip(
                                        "Clarity: ${review.aiAnalysis!.clarity}",
                                        Colors.green,
                                      ),
                                      _chip(
                                        "Novelty: ${review.aiAnalysis!.novelty}",
                                        Colors.purple,
                                      ),
                                      _chip(
                                        "Overall: ${review.aiAnalysis!.overallScore}",
                                        Colors.orange,
                                      ),
                                    ],
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

  Widget _chip(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(color: color, fontWeight: FontWeight.w500),
      ),
    );
  }
}
