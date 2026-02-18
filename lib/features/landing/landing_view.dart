import 'package:flutter/material.dart';
import 'package:session.ai/core/widgets/app_sign_in_button.dart';
import 'package:session.ai/features/auth/presentation/sign_in_view.dart';
import 'package:session.ai/features/events/presentation/events_list_public_view.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 24),
            child: Center(
              child: AppSignInButton(
                fullWidth: false, // Important for AppBar usage
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SignInPage()),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: const [
            HeroSection(),
            SizedBox(height: 80),
            FeaturesSection(),
            SizedBox(height: 80),
            HowItWorksSection(),
            SizedBox(height: 80),
            RolesSection(),
            SizedBox(height: 80),
            CTASection(),
          ],
        ),
      ),
    );
  }
}

class HeroSection extends StatelessWidget {
  const HeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 120, horizontal: 24),
      child: Column(
        children: [
          const Text(
            "AI-Assisted Session Management Platform",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 42, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          const Text(
            "Fair. Scalable. Intelligent conference session selection.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
          const SizedBox(height: 40),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 18),
              backgroundColor: const Color(0xFF3B82F6),
              foregroundColor: Colors.white, // THIS FIXES TEXT
              textStyle: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EventsListPage()),
              );
            },
            child: const Text("Get Started"),
          ),
          // const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class FeaturesSection extends StatelessWidget {
  const FeaturesSection({super.key});

  Widget featureCard(String title, String desc) {
    return Container(
      width: 300,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          // Text(
          //   title,
          //   style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          // ),
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white, // FIX
            ),
          ),

          const SizedBox(height: 12),
          // Text(
          //   desc,
          //   textAlign: TextAlign.center,
          //   style: const TextStyle(color: Colors.grey),
          // ),
          Text(
            desc,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white70, // BETTER THAN GREY
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 40,
      runSpacing: 40,
      alignment: WrapAlignment.center,
      children: [
        featureCard(
          "AI Review Engine",
          "Automatic scoring, tagging & embedding-based similarity detection.",
        ),
        featureCard(
          "Role-Based Access",
          "Organizer, Speaker, Reviewer & Admin modules.",
        ),
        featureCard(
          "Smart Scheduling",
          "Conflict detection and automated validation rules.",
        ),
      ],
    );
  }
}

class HowItWorksSection extends StatelessWidget {
  const HowItWorksSection({super.key});

  Widget step(String title, String desc) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Text(
          desc,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.grey),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Wrap(
        spacing: 60,
        alignment: WrapAlignment.center,
        children: [
          step(
            "1. Speaker Submits",
            "Session proposal is submitted with abstract & track.",
          ),
          step(
            "2. AI Analysis",
            "Quality scoring, tagging & embedding similarity search.",
          ),
          step(
            "3. Organizer Selects",
            "Review dashboard ranks sessions for final selection.",
          ),
        ],
      ),
    );
  }
}

class RolesSection extends StatelessWidget {
  const RolesSection({super.key});

  Widget roleCard(String role) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        role,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 30,
      runSpacing: 30,
      alignment: WrapAlignment.center,
      children: const [
        RolesCardWrapper("Organizer"),
        RolesCardWrapper("Speaker"),
        RolesCardWrapper("Reviewer"),
        RolesCardWrapper("Admin"),
      ],
    );
  }
}

class RolesCardWrapper extends StatelessWidget {
  final String role;
  const RolesCardWrapper(this.role, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Text(
          role,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white, // FIX
          ),
        ),
      ),
    );
  }
}

class CTASection extends StatelessWidget {
  const CTASection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 100),
      child: Column(
        children: [
          const Text(
            "Ready to run smarter events?",
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 30),
          // ElevatedButton(
          //   style: ElevatedButton.styleFrom(
          //     padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 18),
          //     backgroundColor: Colors.blueAccent,
          //   ),
          //   onPressed: () {},
          //   child: const Text("Launch Platform"),
          // ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 18),
              backgroundColor: const Color(0xFF3B82F6),
              foregroundColor: Colors.white, // THIS FIXES TEXT
              textStyle: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {},
            child: const Text("Launch Platform"),
          ),
        ],
      ),
    );
  }
}
