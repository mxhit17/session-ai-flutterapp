import 'package:flutter/material.dart';
import 'package:session.ai/core/sessions/data/sessions_repository.dart';

class SubmitSessionScreen extends StatefulWidget {
  final String eventId;

  const SubmitSessionScreen({super.key, required this.eventId});

  @override
  State<SubmitSessionScreen> createState() => _SubmitSessionScreenState();
}

class _SubmitSessionScreenState extends State<SubmitSessionScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _abstractController = TextEditingController();

  String _selectedLevel = "Beginner";

  bool _isSubmitting = false;

  final List<String> _levels = ["Beginner", "Intermediate", "Advanced"];
  final SessionsRepository _repository = SessionsRepository();

  Future<void> _submitSession() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    try {
      final response = await _repository.submitSession({
        "event_id": widget.eventId,
        "title": _titleController.text.trim(),
        "abstract": _abstractController.text.trim(),
        "level": _selectedLevel,
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Session '${response.title}' submitted successfully 🎉",
          ),
          backgroundColor: Colors.green,
        ),
      );

      await Future.delayed(const Duration(milliseconds: 800));
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Failed to submit session"),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Submit Session")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// TITLE
              const Text(
                "Title",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),

              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Enter session title",
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Title is required";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20),

              /// ABSTRACT
              const Text(
                "Abstract",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),

              TextFormField(
                controller: _abstractController,
                maxLines: 5,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Enter session abstract",
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Abstract is required";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20),

              /// LEVEL DROPDOWN
              const Text(
                "Level",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),

              DropdownButtonFormField<String>(
                value: _selectedLevel,
                items:
                    _levels
                        .map(
                          (level) => DropdownMenuItem(
                            value: level,
                            child: Text(level),
                          ),
                        )
                        .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedLevel = value!;
                  });
                },
                decoration: const InputDecoration(border: OutlineInputBorder()),
              ),

              const SizedBox(height: 30),

              /// SUBMIT BUTTON
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _submitSession,
                  child:
                      _isSubmitting
                          ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                          : const Text("Submit Session"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
