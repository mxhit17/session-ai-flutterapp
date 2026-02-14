import 'package:flutter/material.dart';

class HelpAndFaqScreen extends StatelessWidget {
  const HelpAndFaqScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final faqs = _faqItems;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Help & FAQ"),
        centerTitle: true,
        elevation: 1,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.help_outline_rounded,
                  color: Colors.white,
                  size: 32,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    "Need help managing your events?\nFind quick answers below.",
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          Text(
            "Frequently asked questions",
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
          ),

          const SizedBox(height: 12),

          // FAQ list
          ...faqs.map(
            (item) => _FaqTile(question: item.question, answer: item.answer),
          ),

          const SizedBox(height: 24),

          // Contact/help card
          Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.only(top: 8),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.12),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              children: [
                const Icon(Icons.email_outlined, size: 28),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Still need help?",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Reach out to our support team and we’ll assist you with your event setup.",
                        style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "support@youreventapp.com",
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ----------------- FAQ model & sample questions -----------------

class _FaqItem {
  final String question;
  final String answer;

  const _FaqItem({required this.question, required this.answer});
}

const List<_FaqItem> _faqItems = [
  _FaqItem(
    question: "How do I create a new event?",
    answer:
        "Go to the 'Create Event' screen from the home page or side menu. Fill in the event name, dates, location, time zone, and description. "
        "You can also add a banner image and configure call for speakers dates before tapping 'Submit'.",
  ),
  _FaqItem(
    question: "Can I edit an event after creating it?",
    answer:
        "Currently you can view and delete events. Editing event details (name, dates, location, etc.) will be added soon in a future update. "
        "For now, you can delete the event and create a new one with the correct information.",
  ),
  _FaqItem(
    question: "Where are my events stored?",
    answer:
        "Your events are stored securely on your device using local storage. This means your events remain available even if you close and reopen the app, "
        "but they won’t sync automatically across different devices yet.",
  ),
  _FaqItem(
    question: "What does 'Call for Speakers' mean?",
    answer:
        "Call for Speakers is the date range during which speakers can apply or submit talk proposals for your event. "
        "You can set this range while creating the event so you and your speakers have clarity on deadlines.",
  ),
  _FaqItem(
    question: "Can I manage travel and accommodation for speakers?",
    answer:
        "Yes. While creating an event, you can mark whether accommodation, travel, and conference fees are covered. "
        "This helps speakers know what support they can expect when they view your event details.",
  ),
  _FaqItem(
    question: "How do I delete an event?",
    answer:
        "Open the event from the home screen, then tap the delete icon in the top-right corner. "
        "Confirm the action in the dialog and the event will be removed from your device.",
  ),
  _FaqItem(
    question: "I’m a speaker. Can I use this app too?",
    answer:
        "Yes. The app will support both organisers and speakers. You can switch between roles from the side menu once the speaker features are fully available.",
  ),
  _FaqItem(
    question: "Will my data be synced to the cloud?",
    answer:
        "At the moment, events are stored locally on your device only. Cloud sync and multi-device support are planned for upcoming versions of the app.",
  ),
];

// ----------------- FAQ tile widget -----------------

class _FaqTile extends StatefulWidget {
  final String question;
  final String answer;

  const _FaqTile({required this.question, required this.answer});

  @override
  State<_FaqTile> createState() => _FaqTileState();
}

class _FaqTileState extends State<_FaqTile> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          childrenPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          onExpansionChanged: (expanded) {
            setState(() => _isExpanded = expanded);
          },
          trailing: Icon(
            _isExpanded
                ? Icons.remove_circle_outline
                : Icons.add_circle_outline,
            color: Theme.of(context).colorScheme.primary,
          ),
          title: Text(
            widget.question,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                widget.answer,
                style: TextStyle(fontSize: 13, color: Colors.grey[800]),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
