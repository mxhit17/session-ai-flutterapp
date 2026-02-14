import 'package:flutter/material.dart';
import 'package:session.ai/features/home_page_organiser_view.dart';
import 'package:session.ai/features/create_event/presentation/create_event_view.dart';
import 'package:session.ai/features/profile_organiser_view.dart';

class BottomNavBarOrganizer extends StatefulWidget {
  const BottomNavBarOrganizer({super.key});

  @override
  State<BottomNavBarOrganizer> createState() => _BottomNavBarOrganizerState();
}

class _BottomNavBarOrganizerState extends State<BottomNavBarOrganizer> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const CreateEventScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex], // show selected screen
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index; // update index on tap
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline),
            label: "Create Event",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}
