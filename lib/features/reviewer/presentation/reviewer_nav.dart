import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:session.ai/core/auth/auth_notifier.dart';
import 'package:session.ai/features/reviewer/presentation/helper_screens/assinged_sessions_view.dart';
import 'package:session.ai/features/reviewer/presentation/helper_screens/reviewed_sessions_view.dart';
import 'package:session.ai/features/reviewer/presentation/helper_screens/reviewer_dashboard_view.dart';

class ReviewerNav extends ConsumerStatefulWidget {
  const ReviewerNav({super.key});

  @override
  ConsumerState<ReviewerNav> createState() => _ReviewerNavState();
}

class _ReviewerNavState extends ConsumerState<ReviewerNav> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    ReviewerDashboardScreen(),
    AssignedSessionsScreen(),
    ReviewedSessionsScreen(),
    ReviewerProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Reviewer"),
        actions: [
          IconButton(
            icon: const Icon(Icons.switch_account),
            onPressed: () {
              ref.read(authProvider.notifier).switchRole(null);
            },
          ),
        ],
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: "Dashboard",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: "Sessions",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.rate_review),
            label: "My Reviews",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}

class ReviewerProfileScreen extends StatelessWidget {
  const ReviewerProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy Data
    final profile = {
      "name": "Mohit Mudgal",
      "email": "mohit@email.com",
      "role": "Reviewer",
      "organization": "Session.ai",
      "experience": "Intermediate",
      "bio": "Passionate about reviewing tech sessions and content quality.",
      "userId": "REV_567890",
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
                _buildTile("Name", profile["name"]!),
                _divider(),
                _buildTile("Email", profile["email"]!),
                _divider(),
                _buildTile("Role", profile["role"]!),
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

          const SizedBox(height: 20),

          // _buildLogoutButton(),
        ],
      ),
    );
  }

  // 🔹 Header (same feel as speaker)
  Widget _buildHeader(Map<String, String> profile) {
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
                child: const CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, size: 50, color: Colors.grey),
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
            profile["name"]!,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 4),
          Text(profile["role"]!, style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  // 🔹 Card UI
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

  // 🔹 Tile
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

  // 🔹 Logout Button
  Widget _buildLogoutButton() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: Colors.red.withOpacity(0.1),
      ),
      child: ListTile(
        leading: const Icon(Icons.logout, color: Colors.red),
        title: const Text(
          "Logout",
          style: TextStyle(color: Colors.red, fontWeight: FontWeight.w600),
        ),
        onTap: () {},
      ),
    );
  }
}
