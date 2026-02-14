// root_router.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:session.ai/core/auth/auth_notifier.dart';
import 'package:session.ai/features/landing/landing_view.dart';
import 'package:session.ai/features/splash/splash_view.dart';
import 'app_shell.dart';

class RootRouter extends ConsumerWidget {
  const RootRouter({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authProvider);

    print("RootRouter rebuild");
    print("Token: ${auth.token}");

    // Show splash while loading storage
    if (auth.token == null && auth.roles.isEmpty) {
      return const SplashScreen();
      // return const LandingPage();
    }

    // Not logged in
    if (!auth.isLoggedIn) {
      return const LandingPage();
    }

    // Logged in
    return const AppShell();
  }
}

// class RootRouter extends ConsumerWidget {
//   const RootRouter({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final auth = ref.watch(authProvider);
//     print("RootRouter rebuild");
//     print(auth.token);
//     print(identityHashCode(ref.read(authProvider.notifier)));

//     // If still loading from SharedPreferences
//     if (auth.token == null && auth.roles.isEmpty) {
//       return const SplashScreen();
//     }

//     // If not logged in → show public module
//     if (!auth.isLoggedIn) {
//       return const LandingPage();
//     }

//     // If logged in → show private module
//     return const AppShell();
//   }
// }
