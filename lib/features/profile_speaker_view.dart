import 'package:flutter/material.dart';
import 'package:session.ai/coming_soon_view.dart';
import 'package:session.ai/injection_container.dart';
import 'package:session.ai/utils/storage/preference_manager.dart';

class ProfileSpeakerView extends StatefulWidget {
  const ProfileSpeakerView({super.key});

  @override
  State<ProfileSpeakerView> createState() => _ProfileSpeakerViewState();
}

class _ProfileSpeakerViewState extends State<ProfileSpeakerView> {
  Future<void> _logout(BuildContext context) async {
    final prefs = sl<PreferencesManager>();

    // Clear tokens
    await prefs.clear(PreferencesManager.ACCESS_TOKEN);
    await prefs.clear(PreferencesManager.REFRESH_TOKEN);

    // Navigate to SignInScreen
    // Navigator.pushAndRemoveUntil(
    //   context,
    //   MaterialPageRoute(builder: (_) => const SignInScreen()),
    //   (route) => false,
    // );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: const Text("Speaker Profile"),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: theme.textTheme.bodyLarge?.color ?? Colors.black87,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
          child: Column(
            children: [
              // Top header with gradient + avatar + stats
              SizedBox(
                height: 230,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      height: 160,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            colorScheme.primary.withOpacity(0.95),
                            colorScheme.secondary.withOpacity(0.85),
                          ],
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 18,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Name + role
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Jane Smith", // TODO: bind speaker name
                                      style: theme.textTheme.titleLarge
                                          ?.copyWith(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w700,
                                          ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      "Speaker • Mobile & Cloud",
                                      style: theme.textTheme.bodyMedium
                                          ?.copyWith(
                                            color: Colors.white.withOpacity(
                                              0.85,
                                            ),
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 12),
                              // Quick tags / level
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.16),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.star_rounded,
                                      size: 18,
                                      color: Colors.amber,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      "4.8 rating", // TODO: dynamic rating
                                      style: theme.textTheme.bodySmall
                                          ?.copyWith(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          // Stats row
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              _HeaderStat(
                                label: "Talks",
                                value: "12", // TODO: dynamic
                              ),
                              _HeaderStat(
                                label: "Events",
                                value: "5", // TODO: dynamic
                              ),
                              _HeaderStat(
                                label: "Attendees",
                                value: "850+", // TODO: dynamic
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Avatar overlapping
                    Positioned(
                      bottom: -40,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.12),
                                blurRadius: 16,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: const CircleAvatar(
                            radius: 44,
                            backgroundColor: Color(0xFFE3F2FD),
                            child: Icon(
                              Icons.mic_none_rounded,
                              size: 48,
                              color: Color(0xFF1976D2),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 60),

              // About speaker
              _SectionHeader(title: "About", icon: Icons.person_rounded),
              Card(
                elevation: 1,
                shape: RoundedRectangleBorder(
                  borderRadius:
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ).borderRadius,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Senior Developer & Speaker",
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "Passionate about building scalable mobile and cloud-native applications. "
                        "Loves sharing knowledge through talks, workshops, and hands-on demos.",
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.textTheme.bodySmall?.color?.withOpacity(
                            0.8,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 8,
                        runSpacing: 6,
                        children: [
                          _ChipPill(label: "Flutter"),
                          _ChipPill(label: "Firebase"),
                          _ChipPill(label: "Architecture"),
                          _ChipPill(label: "DevOps"),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Upcoming sessions
              // _SectionHeader(
              //   title: "Upcoming sessions",
              //   icon: Icons.event_rounded,
              // ),
              // Card(
              //   elevation: 0.5,
              //   shape: RoundedRectangleBorder(
              //     borderRadius: BorderRadius.circular(18),
              //   ),
              //   child: Column(
              //     children: [
              //       _ProfileTile(
              //         icon: Icons.mic_rounded,
              //         title: "Building scalable Flutter apps",
              //         subtitle: "Tomorrow • 11:00 AM • Hall A",
              //         onTap: () {
              //           // TODO: Navigate to session detail
              //         },
              //       ),
              //       const _TileDivider(),
              //       _ProfileTile(
              //         icon: Icons.mic_rounded,
              //         title: "Realtime apps with Firebase",
              //         subtitle: "Sat • 3:30 PM • Room 2",
              //         onTap: () {
              //           // TODO: Navigate to session detail
              //         },
              //       ),
              //       const _TileDivider(),
              //       ListTile(
              //         contentPadding: const EdgeInsets.symmetric(
              //           horizontal: 16,
              //           vertical: 6,
              //         ),
              //         title: Text(
              //           "View all sessions",
              //           style: theme.textTheme.bodyMedium?.copyWith(
              //             fontWeight: FontWeight.w600,
              //             color: colorScheme.primary,
              //           ),
              //         ),
              //         trailing: Icon(
              //           Icons.chevron_right_rounded,
              //           size: 20,
              //           color: colorScheme.primary,
              //         ),
              //         onTap: () {
              //           // TODO: Navigate to full sessions list
              //         },
              //       ),
              //     ],
              //   ),
              // ),

              // const SizedBox(height: 20),

              // Speaker tools
              _SectionHeader(title: "Speaker tools", icon: Icons.build_rounded),
              Card(
                elevation: 0.5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(
                  children: [
                    _ProfileTile(
                      icon: Icons.schedule_rounded,
                      title: "My schedule",
                      subtitle: "See your talks across all days",
                      onTap: () {
                        // TODO: Navigate to speaker schedule
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ComingSoonScreen(),
                          ),
                        );
                      },
                    ),
                    const _TileDivider(),
                    _ProfileTile(
                      icon: Icons.insert_drive_file_rounded,
                      title: "Slides & resources",
                      subtitle: "Upload or manage your session assets",
                      onTap: () {
                        // TODO: Navigate to resources manager
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ComingSoonScreen(),
                          ),
                        );
                      },
                    ),
                    const _TileDivider(),
                    _ProfileTile(
                      icon: Icons.reviews_rounded,
                      title: "Feedback & ratings",
                      subtitle: "Check attendee feedback and scores",
                      onTap: () {
                        // TODO: Navigate to feedback screen
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ComingSoonScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Account + app
              _SectionHeader(title: "Account", icon: Icons.settings_rounded),
              Card(
                elevation: 0.5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(
                  children: [
                    _ProfileTile(
                      icon: Icons.edit_rounded,
                      title: "Edit profile",
                      subtitle: "Update your bio and photo",
                      onTap: () {
                        // TODO: Navigate to edit profile
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ComingSoonScreen(),
                          ),
                        );
                      },
                    ),
                    const _TileDivider(),
                    _ProfileTile(
                      icon: Icons.access_time_rounded,
                      title: "Availability",
                      subtitle: "Set when you're available to talk",
                      onTap: () {
                        // TODO: Navigate to availability settings
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ComingSoonScreen(),
                          ),
                        );
                      },
                    ),
                    const _TileDivider(),
                    _ProfileTile(
                      icon: Icons.notifications_active_rounded,
                      title: "Notifications",
                      subtitle: "Reminders before your sessions",
                      onTap: () {
                        // TODO: Navigate to notifications
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ComingSoonScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Support / guidelines
              _SectionHeader(
                title: "Support",
                icon: Icons.help_outline_rounded,
              ),
              Card(
                elevation: 0.5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(
                  children: [
                    _ProfileTile(
                      icon: Icons.menu_book_rounded,
                      title: "Speaker guidelines",
                      subtitle: "Best practices & event rules",
                      onTap: () {
                        // TODO: Navigate to guidelines
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ComingSoonScreen(),
                          ),
                        );
                      },
                    ),
                    const _TileDivider(),
                    _ProfileTile(
                      icon: Icons.headset_mic_rounded,
                      title: "Contact organiser",
                      subtitle: "Reach out for any help",
                      onTap: () {
                        // TODO: Contact organiser screen
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ComingSoonScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // Bottom nav hint (if you still want that text)
              // You can remove this if not needed.
              Text(
                "Bottom nav bar for speaker",
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.textTheme.bodySmall?.color?.withOpacity(0.6),
                ),
              ),
              const SizedBox(height: 12),

              // Logout button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => _logout(context),
                  icon: const Icon(Icons.logout_rounded),
                  label: const Text(
                    "Logout",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 3,
                    shadowColor: Colors.redAccent.withOpacity(0.3),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeaderStat extends StatelessWidget {
  final String label;
  final String value;

  const _HeaderStat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: theme.textTheme.titleMedium?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: Colors.white.withOpacity(0.8),
          ),
        ),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;

  const _SectionHeader({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, left: 4, right: 4),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: colorScheme.primary.withOpacity(0.08),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 18, color: colorScheme.primary),
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;

  const _ProfileTile({
    required this.icon,
    required this.title,
    this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return ListTile(
      onTap: onTap,
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: colorScheme.primary.withOpacity(0.06),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, size: 22, color: colorScheme.primary),
      ),
      title: Text(
        title,
        style: theme.textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle:
          subtitle != null
              ? Text(
                subtitle!,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.textTheme.bodySmall?.color?.withOpacity(0.7),
                ),
              )
              : null,
      trailing: const Icon(Icons.chevron_right_rounded, size: 20),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 4.0,
      ),
    );
  }
}

class _TileDivider extends StatelessWidget {
  const _TileDivider();

  @override
  Widget build(BuildContext context) {
    return const Divider(height: 0, indent: 72, thickness: 0.4);
  }
}

class _ChipPill extends StatelessWidget {
  final String label;

  const _ChipPill({required this.label});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: colorScheme.primary.withOpacity(0.06),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w500),
      ),
    );
  }
}
