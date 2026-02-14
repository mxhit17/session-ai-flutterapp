import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:session.ai/coming_soon_view.dart';
import 'package:session.ai/features/auth/presentation/sign_in_view.dart';
import 'package:session.ai/help_faq_view.dart';
import 'package:session.ai/injection_container.dart';
import 'package:session.ai/terms_privacy_view.dart';
import 'package:session.ai/utils/storage/preference_manager.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Future<void> _logout(BuildContext context) async {
    final prefs = sl<PreferencesManager>();

    // Clear
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
    final prefs = sl<PreferencesManager>();
    final userName = prefs.getUserName() ?? "User";

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: const Text("Profile"),
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
              // Top header with gradient + avatar
              SizedBox(
                height: 210,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      height: 150,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            colorScheme.primary.withOpacity(0.9),
                            colorScheme.primaryContainer.withOpacity(0.8),
                          ],
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 18,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Name + role
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                // "John Doe", // TODO: bind organiser name
                                userName, // TODO: bind organiser name
                                style: theme.textTheme.titleLarge?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "Event Organizer",
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: Colors.white.withOpacity(0.85),
                                ),
                              ),
                            ],
                          ),

                          // Quick stats
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              _HeaderStat(
                                label: "Events",
                                value: "5", // TODO: dynamic
                              ),
                              const SizedBox(height: 8),
                              _HeaderStat(
                                label: "Sessions",
                                value: "5", // TODO: dynamic
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
                              Icons.person_rounded,
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

              const SizedBox(height: 56),

              // Basic info card
              Card(
                elevation: 1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.email_rounded,
                            color: colorScheme.primary,
                            size: 20,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              "${userName.toLowerCase()}@eventcorp.com", // TODO: bind email
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Icon(
                            Icons.business_center_rounded,
                            color: colorScheme.primary,
                            size: 20,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              "EventCorp India", // TODO: bind org
                              style: theme.textTheme.bodyMedium,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Event tools / navigation
              // _SectionHeader(
              //   title: "Event tools",
              //   icon: Icons.event_note_rounded,
              // ),
              // Card(
              //   elevation: 0.5,
              //   shape: RoundedRectangleBorder(
              //     borderRadius: BorderRadius.circular(18),
              //   ),
              //   child: Column(
              //     children: [
              //       _ProfileTile(
              //         icon: Icons.event_available_rounded,
              //         title: "Manage events",
              //         subtitle: "Create, edit or cancel your events",
              //         onTap: () {
              //           // TODO: Navigate to manage events screen
              //         },
              //       ),
              //       const _TileDivider(),
              //       _ProfileTile(
              //         icon: Icons.schedule_rounded,
              //         title: "My sessions",
              //         subtitle: "View and edit sessions you created",
              //         onTap: () {
              //           // TODO: Navigate to sessions screen
              //         },
              //       ),
              //       const _TileDivider(),
              //       _ProfileTile(
              //         icon: Icons.qr_code_scanner_rounded,
              //         title: "Check-in & tickets",
              //         subtitle: "Scan attendee tickets and manage check-ins",
              //         onTap: () {
              //           // TODO: Navigate to check-in / scanner screen
              //         },
              //       ),
              //     ],
              //   ),
              // ),
              // const SizedBox(height: 20),

              // App / account settings
              _SectionHeader(
                title: "Account",
                icon: Icons.person_outline_rounded,
              ),
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
                      subtitle: "Update your name, bio, and picture",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const EditOrganizerProfileScreen(),
                          ),
                        );
                      },
                    ),

                    const _TileDivider(),
                    _ProfileTile(
                      icon: Icons.notifications_active_rounded,
                      title: "Notifications",
                      subtitle: "Email and push notification preferences",
                      onTap: () {
                        // TODO: Navigate to notifications settings
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ComingSoonScreen(),
                          ),
                        );
                      },
                    ),
                    const _TileDivider(),
                    _ProfileTile(
                      icon: Icons.settings_rounded,
                      title: "App settings",
                      subtitle: "Theme, language, and more",
                      onTap: () {
                        // TODO: Navigate to app settings
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ComingSoonScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Support section
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
                      icon: Icons.info_outline_rounded,
                      title: "Help & FAQs",
                      subtitle: "Get quick answers and guides",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const HelpAndFaqScreen(),
                          ),
                        );
                      },
                    ),
                    const _TileDivider(),
                    _ProfileTile(
                      icon: Icons.description_rounded,
                      title: "Terms & privacy",
                      subtitle: "Our policies and terms of use",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const TermsAndPrivacyScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

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
      crossAxisAlignment: CrossAxisAlignment.end,
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

class EditOrganizerProfileScreen extends StatefulWidget {
  const EditOrganizerProfileScreen({super.key});

  @override
  State<EditOrganizerProfileScreen> createState() =>
      _EditOrganizerProfileScreenState();
}

class _EditOrganizerProfileScreenState
    extends State<EditOrganizerProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _bioController = TextEditingController();
  final _titleController = TextEditingController();
  final _organizationController = TextEditingController();

  File? _profileImage;

  @override
  void initState() {
    super.initState();
    _loadExistingData();
  }

  // TODO: Load saved organiser info here (from PreferencesManager / API)
  void _loadExistingData() {
    // Example (when you wire it later):
    final prefs = sl<PreferencesManager>();
    _nameController.text = prefs.getUserName() ?? "";
    // _bioController.text = prefs.getString("organizer_bio") ?? "";
  }

  Future<void> _pickProfileImage() async {
    final picked = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (picked != null) {
      setState(() {
        _profileImage = File(picked.path);
      });
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    // Here you can persist data using PreferencesManager or API
    final prefs = sl<PreferencesManager>();
    await prefs.setUserName(_nameController.text.trim());
    // await prefs.setString("organizer_bio", _bioController.text.trim());
    // await prefs.setString("organizer_title", _titleController.text.trim());
    // await prefs.setString("organizer_org", _organizationController.text.trim());
    // await prefs.setString("organizer_avatar_path", _profileImage?.path ?? "");

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Profile updated successfully 🎉")),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profile"),
        centerTitle: true,
        elevation: 1,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // -------- Profile Picture --------
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 48,
                      backgroundColor: Colors.grey[300],
                      backgroundImage:
                          _profileImage != null
                              ? FileImage(_profileImage!)
                              : null,
                      child:
                          _profileImage == null
                              ? const Icon(
                                Icons.person,
                                size: 48,
                                color: Colors.white,
                              )
                              : null,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: InkWell(
                        onTap: _pickProfileImage,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.edit,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // -------- Name --------
              _buildTextField(
                controller: _nameController,
                label: "Full Name",
                isMandatory: true,
              ),

              // -------- Title --------
              _buildTextField(
                controller: _titleController,
                label: "Title (e.g. Event Organizer)",
              ),

              // -------- Organization --------
              _buildTextField(
                controller: _organizationController,
                label: "Organization",
              ),

              // -------- Bio (multiline) --------
              _buildTextField(
                controller: _bioController,
                label: "Bio",
                isMultiline: true,
                maxLines: 4,
                hint:
                    "Tell speakers and attendees a bit about yourself, your events, and experience.",
              ),

              const SizedBox(height: 24),

              // -------- Save Button --------
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _saveProfile,
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    padding: EdgeInsets.zero,
                    elevation: 4,
                  ).copyWith(
                    backgroundColor: MaterialStateProperty.resolveWith(
                      (states) => null,
                    ),
                    foregroundColor: MaterialStateProperty.all<Color>(
                      Colors.white,
                    ),
                  ),
                  child: Ink(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
                      ),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Container(
                      alignment: Alignment.center,
                      child: const Text(
                        "Save Changes",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------- Reusable TextField ----------
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    bool isMandatory = false,
    bool isMultiline = false,
    int maxLines = 1,
    String? hint,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        maxLines: isMultiline ? maxLines : 1,
        validator: (value) {
          if (isMandatory && (value == null || value.trim().isEmpty)) {
            return "$label is required";
          }
          return null;
        },
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 18,
          ),
          labelText: label,
          hintText: hint,
          labelStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          border: InputBorder.none,
          suffixText: isMandatory ? '*' : null,
        ),
      ),
    );
  }
}
