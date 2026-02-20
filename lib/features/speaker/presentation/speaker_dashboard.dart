import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:session.ai/core/auth/auth_notifier.dart';
import 'package:session.ai/features/speaker/presentation/sessions/my_sessions_view.dart';
import 'package:session.ai/features/speaker/presentation/profile/speaker_profile_view.dart';
import 'package:session.ai/features/speaker/presentation/events/upcoming_events_view.dart';

class SpeakerNav extends ConsumerStatefulWidget {
  const SpeakerNav({super.key});

  @override
  ConsumerState<SpeakerNav> createState() => _SpeakerNavState();
}

class _SpeakerNavState extends ConsumerState<SpeakerNav> {
  int index = 0;

  final screens = const [
    UpcomingEventsScreen(),
    MySessionsScreen(),
    SpeakerProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Speaker"),

        actions: [
          IconButton(
            icon: const Icon(Icons.switch_account),
            onPressed: () {
              ref.read(authProvider.notifier).switchRole(null);
            },
          ),
        ],
      ),
      body: screens[index],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        onTap: (value) => setState(() => index = value),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: "Dashboard",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event_note),
            label: "Sessions",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}
