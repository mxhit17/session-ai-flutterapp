import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:session.ai/features/speaker/data/speaker_repository.dart';
import 'package:session.ai/injection_container.dart';
import 'package:session.ai/utils/storage/preference_manager.dart';

class CreateEventScreen extends StatefulWidget {
  const CreateEventScreen({super.key});

  @override
  State<CreateEventScreen> createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  final SpeakerRepository _repository = SpeakerRepository();
  bool _isLoading = false;

  DateTimeRange? _selectedDateRange;
  String _selectedTimezone = "Asia/Kolkata";

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
    };

    try {
      setState(() => _isLoading = true);

      final response = await _repository.createEvent(eventMap);

      if (!mounted) return;

      // 🔥 ROLE CHECK LOGIC
      final prefs = sl<PreferencesManager>();

      List<String> roles = prefs.getUserRoles();

      if (!roles.contains("ORGANISER")) {
        roles.add("ORGANISER");

        await prefs.setUserRoles(roles);

        // Optional: make ORGANISER active role
        await prefs.setActiveRole("ORGANISER");
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Event Created Successfully 🎉")),
      );

      Navigator.pop(context, response);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Create Event")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Title
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: "Event Title",
                  border: OutlineInputBorder(),
                ),
                validator:
                    (value) => value!.isEmpty ? "Title is required" : null,
              ),
              const SizedBox(height: 16),

              /// Description
              TextFormField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: "Description",
                  border: OutlineInputBorder(),
                ),
                validator:
                    (value) =>
                        value!.isEmpty ? "Description is required" : null,
              ),
              const SizedBox(height: 16),

              /// Location
              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(
                  labelText: "Location",
                  border: OutlineInputBorder(),
                ),
                validator:
                    (value) => value!.isEmpty ? "Location is required" : null,
              ),
              const SizedBox(height: 16),

              /// Date Range Picker
              InkWell(
                onTap: _pickDateRange,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 16,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _selectedDateRange == null
                            ? "Select Event Date Range"
                            : "${formatDate(_selectedDateRange!.start)}  →  ${formatDate(_selectedDateRange!.end)}",
                      ),
                      const Icon(Icons.calendar_month),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              /// Timezone Dropdown
              DropdownButtonFormField<String>(
                value: _selectedTimezone,
                items:
                    _timezones
                        .map(
                          (tz) => DropdownMenuItem(value: tz, child: Text(tz)),
                        )
                        .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedTimezone = value!;
                  });
                },
                decoration: const InputDecoration(
                  labelText: "Timezone",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 24),

              /// Submit Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child:
                      _isLoading
                          ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                          : const Text("Create Event"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
