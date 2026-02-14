import 'dart:async';
import 'package:flutter/material.dart';
import 'package:session.ai/features/landing/landing_view.dart';
import 'package:session.ai/injection_container.dart';
import 'package:session.ai/utils/storage/preference_manager.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  final _prefs = sl<PreferencesManager>();

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..forward();

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    _navigate();
  }

  void _navigate() async {
    // Wait for splash duration
    await Future.delayed(const Duration(milliseconds: 700));

    // Get access token from PreferencesManager
    // final String? token = await _prefs.getAccessToken();
    // final String? role = await _prefs.getUserRoles().first;

    // Navigate based on token availability
    // if (token != null && token.isNotEmpty) {
    //   // Check user role and navigate accordingly
    //   if (role?.toLowerCase() == 'organiser') {
    //     Navigator.pushReplacement(
    //       context,
    //       MaterialPageRoute(builder: (_) => const BottomNavBarOrganizer()),
    //     );
    //   } else if (role?.toLowerCase() == 'speaker') {
    //     Navigator.pushReplacement(
    //       context,
    //       MaterialPageRoute(builder: (_) => const BottomNavBarSpeaker()),
    //     );
    //   } else {
    //     ScaffoldMessenger.of(context).showSnackBar(
    //       const SnackBar(
    //         content: Text("Unknown role. Please contact support."),
    //       ),
    //     );
    //   }
    // } else {
    // Navigator.pushReplacement(
    //   context,
    //   MaterialPageRoute(builder: (_) => const SignInScreen()),
    // );
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const LandingPage()),
    );
    // }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            // colors: [Color(0xFF6A11CB), Color(0xFF2575FC)], // Purple to Blue
            colors: [
              Color(0xFF2575FC),
              Theme.of(context).colorScheme.primary,
            ], // Purple to Blue
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo inside glowing circle
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white.withOpacity(0.4),
                        blurRadius: 30,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.event,
                    size: 70,
                    color: const Color(0xFF2575FC),
                  ),
                ),
                const SizedBox(height: 30),

                // App Name
                const Text(
                  "Session.ai",
                  style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 12),

                // Subtitle
                const Text(
                  "Manage Events • Connect Experts",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 40),

                // Progress indicator
                const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  strokeWidth: 2.5,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
