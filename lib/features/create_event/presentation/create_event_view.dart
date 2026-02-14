import 'dart:developer' as developer show log;
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:session.ai/api_service.dart';
import 'package:session.ai/utils/constants/consts.dart';
import 'package:session.ai/utils/storage/preference_manager.dart'; // for formatting dates

// -------------------- Model --------------------
class EventModel {
  final String eventName;
  final String eventDates;
  final String timeZone;
  final String location;
  final String description;
  final File? bannerImage;
  final String callForSpeakersDate;
  final String speakerSupportEmail;
  final bool accommodationCovered;
  final bool travelCovered;
  final bool conferenceFeeCovered;

  EventModel({
    required this.eventName,
    required this.eventDates,
    required this.timeZone,
    required this.location,
    required this.description,
    required this.bannerImage,
    required this.callForSpeakersDate,
    required this.speakerSupportEmail,
    required this.accommodationCovered,
    required this.travelCovered,
    required this.conferenceFeeCovered,
  });

  // ↘ Convert Event → JSON Map
  Map<String, dynamic> toJson() {
    return {
      "eventName": eventName,
      "eventDates": eventDates,
      "timeZone": timeZone,
      "location": location,
      "description": description,
      "bannerImagePath": bannerImage?.path, // IMPORTANT
      "callForSpeakersDate": callForSpeakersDate,
      "speakerSupportEmail": speakerSupportEmail,
      "accommodationCovered": accommodationCovered,
      "travelCovered": travelCovered,
      "conferenceFeeCovered": conferenceFeeCovered,
    };
  }

  // ↘ Convert JSON → Event object
  factory EventModel.fromJson(Map<String, dynamic> json) {
    final path = json['bannerImagePath'];
    return EventModel(
      eventName: json["eventName"],
      eventDates: json["eventDates"],
      timeZone: json["timeZone"],
      location: json["location"],
      description: json["description"],
      bannerImage: path != null ? File(path) : null,
      callForSpeakersDate: json["callForSpeakersDate"],
      speakerSupportEmail: json["speakerSupportEmail"],
      accommodationCovered: json["accommodationCovered"],
      travelCovered: json["travelCovered"],
      conferenceFeeCovered: json["conferenceFeeCovered"],
    );
  }
}

// To store all created events in memory
final List<EventModel> eventList = [];

// -------------------- Reusable Field --------------------
class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final bool isMandatory;
  final TextInputType keyboardType;
  final bool readOnly;
  final VoidCallback? onTap;
  final bool isMultiline; // NEW: toggle between single-line and multi-line
  final int? maxLength; // optional character/word limit
  final bool wordLimit; // NEW: true = word limit, false = character limit

  const CustomTextField({
    super.key,
    required this.controller,
    required this.label,
    this.isMandatory = false,
    this.keyboardType = TextInputType.text,
    this.readOnly = false,
    this.onTap,
    this.isMultiline = false,
    this.maxLength,
    this.wordLimit = false, // default: character limit
  });

  @override
  Widget build(BuildContext context) {
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
        readOnly: readOnly,
        onTap: onTap,
        keyboardType: isMultiline ? TextInputType.multiline : keyboardType,
        maxLines: isMultiline ? null : 1, // dynamic
        style: const TextStyle(fontSize: 16),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 18,
          ),
          labelText: label,
          labelStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          border: InputBorder.none,
          suffixText: isMandatory ? '*' : null,
          counterText: "", // hide default Flutter counter
        ),
        validator: (value) {
          if (isMandatory && (value == null || value.trim().isEmpty)) {
            return "$label is required";
          }

          if (maxLength != null && value != null && value.isNotEmpty) {
            if (wordLimit) {
              final words = value.trim().split(RegExp(r'\s+')).length;
              if (words > maxLength!) {
                return "Max $maxLength words allowed";
              }
            } else {
              if (value.length > maxLength!) {
                return "Max $maxLength characters allowed";
              }
            }
          }

          return null;
        },
      ),
    );
  }
}

// -------------------- Screen --------------------
class CreateEventScreen extends StatefulWidget {
  const CreateEventScreen({super.key});

  @override
  State<CreateEventScreen> createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  final _formKey = GlobalKey<FormState>();
  final _apiService = ApiService();

  final _eventNameController = TextEditingController();
  final _eventDatesController = TextEditingController();
  final _timeZoneController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _callForSpeakersDateController = TextEditingController();
  final _speakerSupportEmailController = TextEditingController();

  File? _bannerImage;

  String? _selectedTimeZone;
  String? _selectedLocation;

  bool _accommodation = false;
  bool _travel = false;
  bool _conferenceFeeCovered = false;

  final List<String> _timeZones = [
    'UTC',
    'GMT',
    'EST (Eastern Standard Time)',
    'CST (Central Standard Time)',
    'MST (Mountain Standard Time)',
    'PST (Pacific Standard Time)',
    'IST (India Standard Time)',
    'CET (Central European Time)',
    'EET (Eastern European Time)',
    'JST (Japan Standard Time)',
    'AEST (Australian Eastern Standard Time)',
  ];

  String monthToNumber(String month) {
    const months = {
      'Jan': '01',
      'Feb': '02',
      'Mar': '03',
      'Apr': '04',
      'May': '05',
      'Jun': '06',
      'Jul': '07',
      'Aug': '08',
      'Sep': '09',
      'Oct': '10',
      'Nov': '11',
      'Dec': '12',
    };
    return months[month]!;
  }

  List<String> convertDateRange(String dateRange) {
    // Example input: "02 Dec 2025 - 09 Dec 2025"
    final parts = dateRange.split(' - ');
    final startParts = parts[0].split(' ');
    final endParts = parts[1].split(' ');

    final startDate =
        '${startParts[2]}-${monthToNumber(startParts[1])}-${startParts[0].padLeft(2, '0')}';
    final endDate =
        '${endParts[2]}-${monthToNumber(endParts[1])}-${endParts[0].padLeft(2, '0')}';

    return [startDate, endDate];
  }

  Future<void> _pickBannerImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      setState(() {
        _bannerImage = File(pickedFile.path);
      });
    }
  }

  void _removeBannerImage() {
    setState(() {
      _bannerImage = null;
    });
  }

  Future<void> _pickEventDateRange(TextEditingController cntrlr) async {
    final now = DateTime.now();
    final picked = await showDateRangePicker(
      context: context,
      firstDate: now,
      lastDate: DateTime(now.year + 5),
    );

    if (picked != null) {
      final formatter = DateFormat('dd MMM yyyy');
      final formatted =
          "${formatter.format(picked.start)} - ${formatter.format(picked.end)}";

      setState(() {
        cntrlr.text = formatted;
      });
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final eventDates = convertDateRange(_eventDatesController.text);
      final cfsDates = convertDateRange(_callForSpeakersDateController.text);

      // 1) Local model for in-app usage
      final newEvent = EventModel(
        eventName: _eventNameController.text.trim(),
        eventDates: _eventDatesController.text.trim(),
        timeZone: _selectedTimeZone ?? '',
        location: _selectedLocation ?? '',
        description: _descriptionController.text.trim(),
        bannerImage: _bannerImage,
        callForSpeakersDate: _callForSpeakersDateController.text.trim(),
        speakerSupportEmail: _speakerSupportEmailController.text.trim(),
        accommodationCovered: _accommodation,
        travelCovered: _travel,
        conferenceFeeCovered: _conferenceFeeCovered,
      );

      // 2) Map for API
      final eventMap = {
        "title": newEvent.eventName,
        "description": newEvent.description,
        "start_time": eventDates[0],
        "end_time": eventDates[1],
        "location": newEvent.location,
        "status": "scheduled",
        "call_for_speaker_start_date": cfsDates[0],
        "call_for_speaker_end_date": cfsDates[1],
        "accommodation_covered": newEvent.accommodationCovered,
        "travel_covered": newEvent.travelCovered,
        "conference_fee_covered": newEvent.conferenceFeeCovered,
      };

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Creating event..."),
          backgroundColor: Colors.blueGrey,
          duration: Duration(seconds: 2),
        ),
      );

      try {
        // final response = await _apiService.createEvent(eventMap: eventMap);

        // if (response != null) {
        // ✅ Save locally so you can use it everywhere in the app
        setState(() {
          eventList.add(newEvent);
          // eventList.add(newEvent);

          // save locally
          EventStorage.saveEvents(eventList);
        });

        developer.log("EventList length: ${eventList.length}");

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Event created successfully 🎉"),
            backgroundColor: Colors.green,
          ),
        );

        // Clear all fields
        _eventNameController.clear();
        _eventDatesController.clear();
        _timeZoneController.clear();
        _descriptionController.clear();
        _callForSpeakersDateController.clear();
        _speakerSupportEmailController.clear();
        _selectedTimeZone = null;
        _selectedLocation = null;
        _accommodation = false;
        _travel = false;
        _conferenceFeeCovered = false;
        _removeBannerImage();
      }
      // else {
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     const SnackBar(
      //       content: Text("Failed to create event. Please try again."),
      //       backgroundColor: Colors.red,
      //     ),
      //   );
      // }
      // }
      catch (e) {
        debugPrint("Error creating event: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Something went wrong: $e"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Create Event",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 2,
      ),
      body: Container(
        color: Colors.grey[50],
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Event Details",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),

                CustomTextField(
                  controller: _eventNameController,
                  label: "Event Name",
                  isMandatory: true,
                ),
                // CustomTextField(
                //   controller: _eventDatesController,
                //   label: "Event Dates",
                //   isMandatory: true,
                // ),
                CustomTextField(
                  controller: _eventDatesController,
                  label: "Event Dates",
                  isMandatory: true,
                  readOnly: true,
                  onTap: () {
                    _pickEventDateRange(_eventDatesController);
                  },
                ),
                // CustomTextField(
                //   controller: _timeZoneController,
                //   label: "Time Zone",
                // ),
                // Time Zone dropdown
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 18),
                  child: DropdownButtonFormField<String>(
                    value: _selectedTimeZone,
                    decoration: const InputDecoration(
                      labelText: 'Time Zone',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 0,
                        vertical: 12,
                      ),
                    ),
                    items:
                        _timeZones.map((tz) {
                          return DropdownMenuItem(value: tz, child: Text(tz));
                        }).toList(),
                    onChanged: (val) {
                      setState(() {
                        _selectedTimeZone = val;
                      });
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 18),
                  child: DropdownButtonFormField<String>(
                    value: _selectedLocation,
                    decoration: const InputDecoration(
                      labelText: 'Location',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 0,
                        vertical: 12,
                      ),
                    ),
                    items:
                        cities.map((ct) {
                          return DropdownMenuItem(value: ct, child: Text(ct));
                        }).toList(),
                    onChanged: (val) {
                      setState(() {
                        _selectedLocation = val;
                      });
                    },
                  ),
                ),
                CustomTextField(
                  controller: _descriptionController,
                  label: "Description",
                  isMultiline: true,
                ),
                // const SizedBox(height: 16),
                CustomTextField(
                  controller: _callForSpeakersDateController,
                  label: "Call for Speakers Date",
                  isMandatory: true,
                  readOnly: true,
                  onTap: () {
                    _pickEventDateRange(_callForSpeakersDateController);
                  },
                ),
                CustomTextField(
                  controller: _speakerSupportEmailController,
                  label: "Speaker Support Email",
                  isMandatory: true,
                  keyboardType: TextInputType.emailAddress,
                ),

                const Text(
                  'Select which items are covered:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 12),

                // Accommodation checkbox
                CheckboxListTile(
                  value: _accommodation,
                  onChanged:
                      (val) => setState(() => _accommodation = val ?? false),
                  title: const Text('Accommodation'),
                  controlAffinity: ListTileControlAffinity.leading,
                ),

                // Travel checkbox
                CheckboxListTile(
                  value: _travel,
                  onChanged: (val) => setState(() => _travel = val ?? false),
                  title: const Text('Travel'),
                  controlAffinity: ListTileControlAffinity.leading,
                ),

                // Conference fee covered checkbox
                CheckboxListTile(
                  value: _conferenceFeeCovered,
                  onChanged:
                      (val) =>
                          setState(() => _conferenceFeeCovered = val ?? false),
                  title: const Text('Conference fee covered'),
                  controlAffinity: ListTileControlAffinity.leading,
                ),

                // ---------- Banner Image Picker ----------
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18.0),
                  child: const Text(
                    "Banner Image",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                ),
                const SizedBox(height: 8),
                _bannerImage == null
                    ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18.0),
                      child: OutlinedButton.icon(
                        onPressed: _pickBannerImage,
                        icon: const Icon(Icons.image_outlined),
                        label: const Text("Select Banner Image"),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          side: BorderSide.none,
                          shape: RoundedRectangleBorder(
                            side: BorderSide.none,
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    )
                    : Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(
                            _bannerImage!,
                            height: 180,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton.icon(
                              onPressed: _pickBannerImage,
                              icon: const Icon(Icons.refresh),
                              label: const Text("Replace"),
                            ),
                            const SizedBox(width: 16),
                            TextButton.icon(
                              onPressed: _removeBannerImage,
                              icon: const Icon(Icons.delete_outline),
                              label: const Text("Remove"),
                            ),
                          ],
                        ),
                      ],
                    ),

                const SizedBox(height: 24),

                // Submit Button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _submitForm,
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
                      foregroundColor: MaterialStateProperty.all(Colors.white),
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
                          "Submit",
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
      ),
    );
  }
}
