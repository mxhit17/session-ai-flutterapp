import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:session.ai/core/auth/auth_notifier.dart';
import 'package:session.ai/features/organiser/presentation/my_events_view.dart';
import 'package:session.ai/features/organiser/presentation/oragniser_dashboard_view.dart';

class OrganizerNav extends ConsumerStatefulWidget {
  const OrganizerNav({super.key});

  @override
  ConsumerState<OrganizerNav> createState() => _OrganizerNavState();
}

class _OrganizerNavState extends ConsumerState<OrganizerNav> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    OrganizerDashboardScreen(),
    OrganizerEventsScreen(),
    OrganizerReviewScreen(),
    OrganizerScheduleScreen(),
    OrganizerProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Organiser"),

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
          BottomNavigationBarItem(icon: Icon(Icons.event), label: "Events"),
          BottomNavigationBarItem(
            icon: Icon(Icons.rate_review),
            label: "Reviews",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.schedule),
            label: "Schedule",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}
