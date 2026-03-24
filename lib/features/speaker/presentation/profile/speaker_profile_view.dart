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
    void _showSnack(BuildContext context, String message) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    }

    Future<void> _pickAndUploadImage(
      BuildContext context,
      WidgetRef ref,
    ) async {
      try {
        final picker = ImagePicker();

        final picked = await picker.pickImage(
          source: ImageSource.gallery,
          imageQuality: 70,
        );

        if (picked == null) return;

        final file = File(picked.path);

        /// STEP 1: Upload image
        final url = await ref.read(uploadImageProvider.notifier).upload(file);

        if (url == null) {
          _showSnack(context, "Image upload failed");
          return;
        }

        /// STEP 2: Call PATCH API
        await ref.read(updateSpeakerProfileProvider.notifier).updateField({
          "profile_photo_url": url,
        });

        /// STEP 3: Refresh profile
        ref.invalidate(speakerProfileProvider);

        _showSnack(context, "Profile photo updated ✅");
      } catch (e) {
        _showSnack(context, "Something went wrong");
      }
    }

    return Scaffold(
      body: profileAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error:
            (e, _) => Center(
              child: Text(
                "Failed to load profile",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
        data: (profile) {
          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(speakerProfileProvider);
            },
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Center(
                  child: GestureDetector(
                    onTap: () => _pickAndUploadImage(context, ref),
                    child: Stack(
                      children: [
                        uploadState is AsyncLoading
                            ? const CircularProgressIndicator()
                            : CircleAvatar(
                              radius: 50,
                              backgroundImage:
                                  profile.profilePhotoUrl != null
                                      ? NetworkImage(profile.profilePhotoUrl!)
                                      : null,
                              child:
                                  profile.profilePhotoUrl == null
                                      ? const Icon(Icons.person, size: 50)
                                      : null,
                            ),
                        Positioned(
                          bottom: 0,
                          right: 0,
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
                ),
                const SizedBox(height: 24),
                _buildEditableTile(
                  context,
                  ref,
                  "Experience Level",
                  profile.experienceLevel,
                  "experience_level",
                ),
                _buildEditableTile(
                  context,
                  ref,
                  "Organization",
                  profile.organization,
                  "organization",
                ),
                _buildEditableTile(context, ref, "Bio", profile.bio, "bio"),

                _buildTile("User ID", profile.userId),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTile(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.grey.shade100,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(height: 6),
            Text(value),
          ],
        ),
      ),
    );
  }

  Widget _buildEditableTile(
    BuildContext context,
    WidgetRef ref,
    String title,
    String value,
    String fieldKey,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.grey.shade100,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit, size: 18),
                  onPressed: () {
                    _showEditBottomSheet(context, ref, title, value, fieldKey);
                  },
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(value.isEmpty ? "Not added" : value),
          ],
        ),
      ),
    );
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

                      /// 👇 EXPERIENCE LEVEL DROPDOWN
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
                            setState(() {
                              selectedExperience = value!;
                            });
                          },
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        )
                      /// 👇 TEXT FIELD FOR BIO + ORGANIZATION
                      else
                        TextField(
                          controller: controller,
                          maxLines: fieldKey == "bio" ? 4 : 1,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),

                      const SizedBox(height: 20),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
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

                                    if (context.mounted) {
                                      Navigator.pop(context);
                                    }
                                  },
                          child:
                              updateState is AsyncLoading
                                  ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
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
