import 'dart:developer' as developer show log;
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:session.ai/core/events/models/get_events_response.dart';
import 'package:session.ai/core/upload_images/upload_provider.dart';
import 'package:session.ai/features/organiser/data/organiser_repository.dart';
import 'package:session.ai/features/speaker/data/speaker_repository.dart';

class CreateEventScreen extends ConsumerStatefulWidget {
  final GetEventsResponse? existingEvent;

  const CreateEventScreen({super.key, this.existingEvent});
  @override
  ConsumerState<CreateEventScreen> createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends ConsumerState<CreateEventScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  final SpeakerRepository _speakerRepository = SpeakerRepository();
  final OrganiserRepository _organiserRepository = OrganiserRepository();
  bool _isLoading = false;

  DateTimeRange? _selectedDateRange;
  String _selectedTimezone = "Asia/Kolkata";

  File? _selectedImageFile;
  String? _uploadedImageUrl;
  bool _isUploadingImage = false;

  @override
  void initState() {
    super.initState();

    if (widget.existingEvent != null) {
      final event = widget.existingEvent!;

      _titleController.text = event.title;
      _descriptionController.text = event.description;
      _locationController.text = event.location;

      _selectedDateRange = DateTimeRange(
        start: event.startDate,
        end: event.endDate,
      );

      _uploadedImageUrl = event.imageUrl;
    }
  }

  final List<String> _timezones = [
    "Asia/Kolkata",
    "UTC",
    "America/New_York",
    "Europe/London",
  ];

  String formatDate(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  Future<void> _pickDateRange() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
      initialDateRange: _selectedDateRange,
    );

    if (picked != null) {
      setState(() {
        _selectedDateRange = picked;
      });
    }
  }

  // Future<void> _submit() async {
  //   if (!_formKey.currentState!.validate()) return;
  //   if (_selectedDateRange == null) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text("Please select event date range")),
  //     );
  //     return;
  //   }
  //   final eventMap = {
  //     "title": _titleController.text.trim(),
  //     "description": _descriptionController.text.trim(),
  //     "start_date": formatDate(_selectedDateRange!.start),
  //     "end_date": formatDate(_selectedDateRange!.end),
  //     "location": _locationController.text.trim(),
  //     "timezone": _selectedTimezone,
  //   };
  //   try {
  //     setState(() => _isLoading = true);
  //     final response = await _repository.createEvent(eventMap);
  //     if (!mounted) return;
  //     // ROLE CHECK LOGIC
  //     final prefs = sl<PreferencesManager>();
  //     // List<String> roles = prefs.getUserRoles();
  //     // if (!roles.contains("ORGANIZER")) {
  //     //   roles.add("ORGANIZER");
  //     //   await prefs.setUserRoles(roles);
  //     //   // Optional: make ORGANISER active role
  //     //   await prefs.setActiveRole("ORGANIZER");
  //     // }
  //     if (response.token != null) {
  //       List<String> roles = prefs.getUserRoles();
  //       if (!roles.contains("ORGANIZER")) {
  //         roles.add("ORGANIZER");
  //         await prefs.setUserRoles(roles);
  //       }
  //     }
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text("Event Created Successfully 🎉")),
  //     );
  //     Navigator.pop(context, response);
  //   } catch (e) {
  //     if (!mounted) return;
  //     ScaffoldMessenger.of(
  //       context,
  //     ).showSnackBar(SnackBar(content: Text(e.toString())));
  //   } finally {
  //     if (mounted) {
  //       setState(() => _isLoading = false);
  //     }
  //   }
  // }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedDateRange == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select event date range")),
      );
      return;
    }

    final eventMap = {
      "title": _titleController.text.trim(),
      "description": _descriptionController.text.trim(),
      "start_date": formatDate(_selectedDateRange!.start),
      "end_date": formatDate(_selectedDateRange!.end),
      "location": _locationController.text.trim(),
      "timezone": _selectedTimezone,
      "image_url": _uploadedImageUrl,
    };

    try {
      setState(() => _isLoading = true);

      if (widget.existingEvent == null) {
        await _speakerRepository.createEvent(eventMap);
      } else {
        await _organiserRepository.updateEvent(
          widget.existingEvent!.id,
          eventMap,
        );
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.existingEvent == null
                ? "Event Created Successfully 🎉"
                : "Event Updated Successfully 🎉",
          ),
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _pickAndUploadImage() async {
    final picker = ImagePicker();

    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );

    if (picked == null) return;

    setState(() {
      _isUploadingImage = true;
      _selectedImageFile = File(picked.path);
    });

    try {
      final url = await ref
          .read(uploadImageProvider.notifier)
          .upload(_selectedImageFile!);

      developer.log("This is the url : " + url.toString());

      if (url != null) {
        setState(() {
          _uploadedImageUrl = url;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Image uploaded successfully")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      setState(() {
        _isUploadingImage = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FB),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black87,
        title: Text(
          widget.existingEvent == null ? "Create Event" : "Edit Event",
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF6F8FB), Color(0xFFEAF1FF)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                /// MAIN CARD
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: _isUploadingImage ? null : _pickAndUploadImage,
                        child: Container(
                          height: 200,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child:
                                _isUploadingImage
                                    ? const Center(
                                      child: CircularProgressIndicator(),
                                    )
                                    : _selectedImageFile != null
                                    ? Image.file(
                                      _selectedImageFile!,
                                      fit: BoxFit.cover,
                                    )
                                    : _uploadedImageUrl != null
                                    ? Image.network(
                                      _uploadedImageUrl!,
                                      fit: BoxFit.cover,
                                    )
                                    : Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: const [
                                        Icon(Icons.image_outlined, size: 50),
                                        SizedBox(height: 10),
                                        Text("Tap to upload event image"),
                                      ],
                                    ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),
                      _buildInput(
                        controller: _titleController,
                        label: "Event Title",
                      ),
                      const SizedBox(height: 16),

                      _buildInput(
                        controller: _descriptionController,
                        label: "Description",
                        maxLines: 3,
                      ),
                      const SizedBox(height: 16),

                      _buildInput(
                        controller: _locationController,
                        label: "Location",
                      ),
                      const SizedBox(height: 16),

                      /// DATE PICKER
                      GestureDetector(
                        onTap: _pickDateRange,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 16,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.calendar_month_outlined),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  _selectedDateRange == null
                                      ? "Select Event Date Range"
                                      : "${formatDate(_selectedDateRange!.start)}  →  ${formatDate(_selectedDateRange!.end)}",
                                  style: TextStyle(
                                    color:
                                        _selectedDateRange == null
                                            ? Colors.grey
                                            : Colors.black87,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      /// TIMEZONE
                      DropdownButtonFormField<String>(
                        value: _selectedTimezone,
                        items:
                            _timezones
                                .map(
                                  (tz) => DropdownMenuItem(
                                    value: tz,
                                    child: Text(tz),
                                  ),
                                )
                                .toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedTimezone = value!;
                          });
                        },
                        decoration: _inputDecoration("Timezone"),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 28),

                /// BUTTON
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _submit,
                    style: ElevatedButton.styleFrom(
                      elevation: 8,
                      shadowColor: Colors.blue.withOpacity(0.3),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      backgroundColor: const Color(0xFF4F46E5),
                    ),
                    child:
                        _isLoading
                            ? const SizedBox(
                              height: 22,
                              width: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                            : Text(
                              widget.existingEvent == null
                                  ? "Create Event"
                                  : "Update Event",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget _buildInput({
  required TextEditingController controller,
  required String label,
  int maxLines = 1,
}) {
  return TextFormField(
    controller: controller,
    maxLines: maxLines,
    decoration: _inputDecoration(label),
    validator:
        (value) => value == null || value.isEmpty ? "$label is required" : null,
  );
}

InputDecoration _inputDecoration(String label) {
  return InputDecoration(
    labelText: label,
    filled: true,
    fillColor: Colors.grey.shade100,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Color(0xFF4F46E5)),
    ),
  );
}
