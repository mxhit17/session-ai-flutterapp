import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:session.ai/core/events/models/get_events_response.dart';
import 'package:session.ai/features/organiser/data/organiser_repository.dart';

class CfpModifierScreen extends StatefulWidget {
  final GetEventsResponse event;

  const CfpModifierScreen({super.key, required this.event});

  @override
  State<CfpModifierScreen> createState() => _CfpModifierScreenState();
}

class _CfpModifierScreenState extends State<CfpModifierScreen> {
  DateTime? _cfpStart;
  DateTime? _cfpEnd;
  bool _cfpOpen = false;
  bool _isSaving = false;
  final OrganiserRepository _repository = OrganiserRepository();

  @override
  void initState() {
    super.initState();
    _cfpStart = widget.event.cfpStart;
    _cfpEnd = widget.event.cfpEnd;
    _cfpOpen = widget.event.cfpOpen;
  }

  Future<void> _pickDateRange() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      initialDateRange:
          (_cfpStart != null && _cfpEnd != null)
              ? DateTimeRange(start: _cfpStart!, end: _cfpEnd!)
              : null,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        _cfpStart = picked.start;
        _cfpEnd = picked.end;
      });
    }
  }

  Future<void> _saveCfp() async {
    if (_cfpOpen && (_cfpStart == null || _cfpEnd == null)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please select CFP dates before enabling"),
        ),
      );
      return;
    }

    setState(() => _isSaving = true);

    try {
      final Map<String, dynamic> body = {
        "cfp_open": _cfpOpen,
        "cfp_start": _cfpStart?.toIso8601String(),
        "cfp_end": _cfpEnd?.toIso8601String(),
      };

      await _repository.handleCFP(widget.event.id, body);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("CFP updated successfully")),
        );

        Navigator.pop(context, true);
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Failed to update CFP")));
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd MMM yyyy');

    return Scaffold(
      appBar: AppBar(title: const Text("Configure CFP")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// EVENT TITLE
            Text(
              widget.event.title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 30),

            /// 🔘 CFP TOGGLE
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade400),
              ),
              child: SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text(
                  "Enable CFP",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                subtitle: Text(
                  _cfpOpen
                      ? "Speakers can submit sessions"
                      : "CFP is currently closed",
                ),
                value: _cfpOpen,
                onChanged: (value) {
                  setState(() {
                    _cfpOpen = value;
                  });
                },
              ),
            ),

            const SizedBox(height: 24),

            /// DATE RANGE FIELD
            GestureDetector(
              onTap: _pickDateRange,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade400),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.date_range),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        (_cfpStart != null && _cfpEnd != null)
                            ? "${dateFormat.format(_cfpStart!)}  →  ${dateFormat.format(_cfpEnd!)}"
                            : "Select CFP Date Range",
                        style: TextStyle(
                          fontSize: 16,
                          color:
                              (_cfpStart != null) ? Colors.black : Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const Spacer(),

            /// SAVE BUTTON
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isSaving ? null : _saveCfp,
                child:
                    _isSaving
                        ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                        : const Text("Save Changes"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
