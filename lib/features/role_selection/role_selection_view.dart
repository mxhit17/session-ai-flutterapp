// role_selection_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:session.ai/core/auth/auth_notifier.dart';

class RoleSelectionScreen extends ConsumerWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final roles = ref.watch(authProvider).roles;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Select Workspace"),
        actions: [
          ElevatedButton(
            onPressed: () {
              ref.read(authProvider.notifier).logout();
            },
            child: const Text("Logout"),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: roles.length,
        itemBuilder: (context, index) {
          final role = roles[index];

          return ListTile(
            title: Text(role),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () {
              ref.read(authProvider.notifier).switchRole(role);
            },
          );
        },
      ),
    );
  }
}
