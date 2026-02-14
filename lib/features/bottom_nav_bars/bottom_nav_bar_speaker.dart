import 'package:flutter/material.dart';
import 'package:session.ai/features/auth/presentation/sign_in_view.dart';
import 'package:session.ai/features/upcomming_events/presentation/applied_events_view.dart';
import 'package:session.ai/features/upcomming_events/presentation/home_page_speaker_view.dart';
import 'package:session.ai/features/profile_speaker_view.dart';
import 'package:session.ai/injection_container.dart';
import 'package:session.ai/utils/storage/preference_manager.dart';

class BottomNavBarSpeaker extends StatefulWidget {
  const BottomNavBarSpeaker({super.key});

  @override
  State<BottomNavBarSpeaker> createState() => _BottomNavBarSpeakerState();
}

class _BottomNavBarSpeakerState extends State<BottomNavBarSpeaker> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomePageSpeakerView(),
    const AppliedEventsScreen(), // 👈 NEW
    const ProfileSpeakerView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
            icon: Icon(Icons.event_available),
            label: "Applied",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),

      body: _screens[_currentIndex], // show selected screen
    );
  }
}
