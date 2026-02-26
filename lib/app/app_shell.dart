// app_shell.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:session.ai/core/auth/auth_notifier.dart';
import 'package:session.ai/features/auth/presentation/sign_in_view.dart';
import 'package:session.ai/features/organiser/presentation/organiser_dashboard.dart';
import 'package:session.ai/features/role_selection/role_selection_view.dart';
import 'package:session.ai/features/speaker/presentation/speaker_dashboard.dart';

class AppShell extends ConsumerWidget {
  const AppShell({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authProvider);

    if (!auth.isLoggedIn) {
      return const SignInPage();
    }

    if (auth.activeRole == null) {
      return const RoleSelectionScreen();
    }

    switch (auth.activeRole) {
      case "SPEAKER":
        return const SpeakerNav();
      case "ORGANIZER":
        return const OrganizerNav();
      case "ORGANISER":
        return const OrganizerNav();
      case "REVIEWER":
      // return const ReviewerNav();
      case "ADMIN":
      // return const AdminNav();
      default:
        return const SizedBox();
    }
  }
}
