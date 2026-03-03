import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:session.ai/core/auth/auth_notifier.dart';
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
    ReviewerSessionsScreen(),
    ReviewerReviewsScreen(),
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

class ReviewerSessionsScreen extends StatelessWidget {
  const ReviewerSessionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: 5,
      itemBuilder: (context, index) {
        return Card(
          child: ListTile(
            leading: const Icon(Icons.assignment),
            title: Text("Session ${index + 1}"),
            subtitle: const Text("Track: Mobile • Status: UNDER_REVIEW"),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              // TODO: Navigate to Session Detail
            },
          ),
        );
      },
    );
  }
}

class ReviewerReviewsScreen extends StatelessWidget {
  const ReviewerReviewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: 3,
      itemBuilder: (context, index) {
        return Card(
          child: ListTile(
            leading: const Icon(Icons.rate_review),
            title: Text("Reviewed Session ${index + 1}"),
            subtitle: const Text("Score: 4 / 5"),
            trailing: const Icon(Icons.check_circle, color: Colors.green),
          ),
        );
      },
    );
  }
}

class ReviewerProfileScreen extends StatelessWidget {
  const ReviewerProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: const [
          CircleAvatar(radius: 40, child: Icon(Icons.person, size: 40)),
          SizedBox(height: 16),
          Text(
            "Mohit Mudgal",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 4),
          Text("Role: Reviewer"),
          SizedBox(height: 30),
          ListTile(leading: Icon(Icons.logout), title: Text("Logout")),
        ],
      ),
    );
  }
}
