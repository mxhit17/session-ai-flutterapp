import 'package:flutter/material.dart';

class OrganizerDashboardScreen extends StatelessWidget {
  const OrganizerDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy Data
    final stats = [
      {"title": "Total Events", "value": "12", "icon": Icons.event},
      {"title": "Upcoming", "value": "5", "icon": Icons.schedule},
      {"title": "Speakers", "value": "24", "icon": Icons.mic},
      {"title": "Attendees", "value": "320", "icon": Icons.people},
    ];

    final recentEvents = [
      {"title": "AI Summit 2026", "date": "12 Apr 2026", "location": "Delhi"},
      {
        "title": "Flutter Connect",
        "date": "20 Apr 2026",
        "location": "Bangalore",
      },
      {"title": "Startup Meetup", "date": "25 Apr 2026", "location": "Mumbai"},
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            _buildHeader(),
            const SizedBox(height: 24),

            // 🔹 Stats Grid
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: stats.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 1.3,
              ),
              itemBuilder: (context, index) {
                final item = stats[index];
                return _buildStatCard(
                  title: item["title"] as String,
                  value: item["value"] as String,
                  icon: item["icon"] as IconData,
                );
              },
            ),

            const SizedBox(height: 24),

            // 🔹 Quick Actions
            _sectionTitle("Quick Actions"),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildActionButton(
                    icon: Icons.add,
                    label: "Create Event",
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildActionButton(
                    icon: Icons.list_alt,
                    label: "Manage Events",
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // 🔹 Recent Events
            _sectionTitle("Recent Events"),
            const SizedBox(height: 12),

            ...recentEvents.map((event) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _buildEventCard(event),
              );
            }),
          ],
        ),
      ),
    );
  }

  // 🔹 Header
  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Hello, Organizer",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4),
            Text(
              "Manage your events easily",
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
        CircleAvatar(
          radius: 24,
          backgroundColor: Colors.white,
          child: Icon(Icons.business, color: Colors.grey),
        ),
      ],
    );
  }

  // 🔹 Stat Card
  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFE0EAFC), Color(0xFFCFDEF3)],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.black54),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          Text(title, style: const TextStyle(color: Colors.black54)),
        ],
      ),
    );
  }

  // 🔹 Section Title
  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
    );
  }

  // 🔹 Action Button
  Widget _buildActionButton({required IconData icon, required String label}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, size: 26),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  // 🔹 Event Card
  Widget _buildEventCard(Map<String, String> event) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.event, color: Colors.blue),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event["title"]!,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4),
                Text(
                  "${event["date"]} • ${event["location"]}",
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        ],
      ),
    );
  }
}

class OrganizerReviewScreen extends StatelessWidget {
  const OrganizerReviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("Review Dashboard"));
  }
}

class OrganizerScheduleScreen extends StatelessWidget {
  const OrganizerScheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("Schedule Builder"));
  }
}

class OrganizerProfileScreen extends StatelessWidget {
  const OrganizerProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy Data
    final profile = {
      "name": "Tech Conference Org",
      "email": "organizer@email.com",
      "organization": "Session.ai Events",
      "bio": "We organize world-class tech conferences.",
      "experience": "Advanced",
      "userId": "ORG_102938",
      "profilePhoto": null,
    };

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        children: [
          _buildHeader(profile),
          const SizedBox(height: 24),

          _buildCard(
            child: Column(
              children: [
                _buildTile("Organizer Name", profile["name"]!),
                _divider(),
                _buildTile("Email", profile["email"]!),
                _divider(),
                _buildTile("Organization", profile["organization"]!),
                _divider(),
                _buildTile("Experience Level", profile["experience"]!),
                _divider(),
                _buildTile("Bio", profile["bio"]!),
              ],
            ),
          ),

          const SizedBox(height: 20),

          _buildCard(child: _buildTile("User ID", profile["userId"]!)),
        ],
      ),
    );
  }

  // 🔹 Header (same vibe as speaker)
  Widget _buildHeader(Map<String, dynamic> profile) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFE0EAFC), Color(0xFFCFDEF3)],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.white,
                  child: const Icon(
                    Icons.business,
                    size: 50,
                    color: Colors.grey,
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 4,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.blue,
                  ),
                  child: const Icon(
                    Icons.camera_alt,
                    size: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            profile["organization"],
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  // 🔹 Card Wrapper
  Widget _buildCard({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _divider() => const Divider(height: 24);

  // 🔹 Simple Tile
  Widget _buildTile(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: const TextStyle(color: Colors.grey),
          ),
        ),
      ],
    );
  }
}
