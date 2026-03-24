import 'package:flutter/material.dart';
import 'package:session.ai/core/widgets/app_sign_in_button.dart';
import 'package:session.ai/features/auth/presentation/sign_in_view.dart';
import 'package:session.ai/features/events/presentation/events_list_public_view.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0F1C),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 24),
            child: Center(
              child: AppSignInButton(
                fullWidth: false,
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
            SizedBox(height: 100),
            FeaturesSection(),
            SizedBox(height: 100),
            HowItWorksSection(),
            SizedBox(height: 100),
            RolesSection(),
            SizedBox(height: 100),
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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 120, horizontal: 24),
      child: Column(
        children: [
          ShaderMask(
            shaderCallback:
                (bounds) => const LinearGradient(
                  colors: [Color(0xFF00F5FF), Color(0xFF8B5CF6)],
                ).createShader(bounds),
            child: const Text(
              "AI-Powered Session Management",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 44,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            "Intelligent. Fair. Fully automated conference workflows.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, color: Colors.white70),
          ),
          const SizedBox(height: 40),
          GlowButton(
            text: "Get Started",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EventsListPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}

class FeaturesSection extends StatelessWidget {
  const FeaturesSection({super.key});

  Widget featureCard(String title, String desc) {
    return GlassContainer(
      child: Container(
        width: 300,
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF00F5FF),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              desc,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white70),
            ),
          ],
        ),
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
    return SizedBox(
      width: 250,
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF8B5CF6),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            desc,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white70),
          ),
        ],
      ),
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
    return GlassContainer(
      child: Container(
        width: 160,
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Text(
            role,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF22C55E),
            ),
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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 120),
      child: Column(
        children: [
          const Text(
            "Launch your AI-driven event platform",
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 30),
          GlowButton(
            text: "Launch Platform",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SignInPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}

class GlassContainer extends StatelessWidget {
  final Widget child;
  const GlassContainer({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: child,
    );
  }
}

class GlowButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const GlowButton({required this.text, required this.onPressed, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF00F5FF).withOpacity(0.6),
            blurRadius: 20,
            spreadRadius: 1,
          ),
        ],
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF00F5FF),
          foregroundColor: Colors.black,
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: onPressed,
        child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }
}
