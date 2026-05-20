import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:session.ai/core/upload_images/upload_provider.dart';
import 'package:session.ai/features/speaker/data/speaker_api.dart';

class SpeakerProfileScreen extends ConsumerWidget {
  const SpeakerProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(speakerProfileProvider);
    final uploadState = ref.watch(uploadImageProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      body: profileAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => const Center(child: Text("Failed to load profile")),
        data: (profile) {
          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(speakerProfileProvider);
            },
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              children: [
                _buildHeader(context, ref, profile, uploadState),
                const SizedBox(height: 24),

                _buildCard(
                  child: Column(
                    children: [
                      _buildEditableTile(
                        context,
                        ref,
                        "Experience Level",
                        profile.experienceLevel,
                        "experience_level",
                      ),
                      _divider(),
                      _buildEditableTile(
                        context,
                        ref,
                        "Organization",
                        profile.organization,
                        "organization",
                      ),
                      _divider(),
                      _buildEditableTile(
                        context,
                        ref,
                        "Bio",
                        profile.bio,
                        "bio",
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                _buildCard(child: _buildTile("User ID", profile.userId)),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context,
    WidgetRef ref,
    dynamic profile,
    AsyncValue uploadState,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFE0EAFC), Color(0xFFCFDEF3)],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: () => _pickAndUploadImage(context, ref),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white,
                    backgroundImage:
                        profile.profilePhotoUrl != null
                            ? NetworkImage(profile.profilePhotoUrl!)
                            : null,
                    child:
                        profile.profilePhotoUrl == null
                            ? const Icon(
                              Icons.person,
                              size: 50,
                              color: Colors.grey,
                            )
                            : null,
                  ),
                ),
                if (uploadState is AsyncLoading)
                  const CircularProgressIndicator(),
                Positioned(
                  bottom: 0,
                  right: 4,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.blue,
                    ),
                    child: const Icon(
                      Icons.camera_alt,
                      size: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Text(
            profile.organization.isNotEmpty
                ? profile.organization
                : "Your Profile",
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _buildCard({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _divider() => const Divider(height: 24);

  Widget _buildTile(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: const TextStyle(color: Colors.grey),
          ),
        ),
      ],
    );
  }

  Widget _buildEditableTile(
    BuildContext context,
    WidgetRef ref,
    String title,
    String value,
    String fieldKey,
  ) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
              const SizedBox(height: 4),
              Text(
                value.isEmpty ? "Not added" : value,
                style: TextStyle(
                  color: value.isEmpty ? Colors.grey : Colors.black87,
                ),
              ),
            ],
          ),
        ),
        IconButton(
          icon: const Icon(Icons.edit, size: 18),
          onPressed: () {
            _showEditBottomSheet(context, ref, title, value, fieldKey);
          },
        ),
      ],
    );
  }

  Future<void> _pickAndUploadImage(BuildContext context, WidgetRef ref) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );

    if (picked == null) return;

    final file = File(picked.path);

    final url = await ref.read(uploadImageProvider.notifier).upload(file);

    if (url == null) return;

    await ref.read(updateSpeakerProfileProvider.notifier).updateField({
      "profile_photo_url": url,
    });

    ref.invalidate(speakerProfileProvider);
  }

  void _showEditBottomSheet(
    BuildContext context,
    WidgetRef ref,
    String title,
    String currentValue,
    String fieldKey,
  ) {
    final controller = TextEditingController(text: currentValue);
    String selectedExperience = currentValue;
    final experienceLevels = ['Beginner', 'Intermediate', 'Advanced'];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 20,
            right: 20,
            top: 20,
          ),
          child: Consumer(
            builder: (context, ref, _) {
              final updateState = ref.watch(updateSpeakerProfileProvider);

              return StatefulBuilder(
                builder: (context, setState) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Edit $title",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),

                      if (fieldKey == "experience_level")
                        DropdownButtonFormField<String>(
                          value:
                              selectedExperience.isNotEmpty
                                  ? selectedExperience
                                  : experienceLevels.first,
                          items:
                              experienceLevels
                                  .map(
                                    (level) => DropdownMenuItem(
                                      value: level,
                                      child: Text(level),
                                    ),
                                  )
                                  .toList(),
                          onChanged: (value) {
                            setState(() => selectedExperience = value!);
                          },
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.grey.shade100,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        )
                      else
                        TextField(
                          controller: controller,
                          maxLines: fieldKey == "bio" ? 4 : 1,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.grey.shade100,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),

                      const SizedBox(height: 20),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed:
                              updateState is AsyncLoading
                                  ? null
                                  : () async {
                                    final valueToSend =
                                        fieldKey == "experience_level"
                                            ? selectedExperience
                                            : controller.text;

                                    await ref
                                        .read(
                                          updateSpeakerProfileProvider.notifier,
                                        )
                                        .updateField({fieldKey: valueToSend});

                                    if (context.mounted) Navigator.pop(context);
                                  },
                          child:
                              updateState is AsyncLoading
                                  ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                  : const Text("Save"),
                        ),
                      ),

                      const SizedBox(height: 20),
                    ],
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}
