import 'package:flutter/material.dart';

class TermsAndPrivacyScreen extends StatelessWidget {
  const TermsAndPrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Terms & Privacy"),
        centerTitle: true,
        elevation: 1,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                    Icons.privacy_tip_outlined,
                    color: Colors.white,
                    size: 32,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      "Please read these terms and our privacy practices before using the app.",
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),
            Text(
              "Last updated: 28 November 2025",
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),

            const SizedBox(height: 24),

            // ================= TERMS OF USE =================
            _sectionTitle("1. Terms of Use"),

            _subTitle("1.1 Acceptance of terms"),
            _bodyText(
              "By creating an account or using this event management app, you agree to be bound by these Terms of Use. "
              "If you do not agree, please do not use the app.",
            ),

            _subTitle("1.2 Purpose of the app"),
            _bodyText(
              "This app is designed to help organisers create, manage, and view events, and to provide information to speakers "
              "and attendees. Features may change or be updated over time.",
            ),

            _subTitle("1.3 Your responsibilities"),
            _bulletList([
              "Provide accurate information when creating events or updating your profile.",
              "Use the app only for lawful purposes related to event management.",
              "Do not upload content that is offensive, illegal, or violates others’ rights.",
              "Respect the privacy and data of speakers, attendees, and other users.",
            ]),

            _subTitle("1.4 Event content"),
            _bodyText(
              "You are responsible for the content of the events you create, including titles, descriptions, images, and dates. "
              "We are not responsible for any incorrect information or disputes arising from your events.",
            ),

            _subTitle("1.5 Changes to the service"),
            _bodyText(
              "We may add, modify, or remove features from the app at any time, with or without prior notice. "
              "We are not liable for any impact caused by such changes.",
            ),

            const SizedBox(height: 24),

            // ================= PRIVACY POLICY =================
            _sectionTitle("2. Privacy Policy"),

            _subTitle("2.1 Information we collect"),
            _bodyText(
              "Depending on how you use the app, we may collect the following information:",
            ),
            _bulletList([
              "Basic account details such as your name and email address.",
              "Event details you create, such as event name, dates, location, and descriptions.",
              "Optional profile information like your bio, role, and organisation.",
              "Device information and basic usage data to improve app performance.",
            ]),

            _subTitle("2.2 How we use your information"),
            _bodyText("We use your information to:"),
            _bulletList([
              "Display and manage your events within the app.",
              "Help you keep track of call-for-speaker dates and event logistics.",
              "Improve the app’s reliability, user experience, and features.",
              "Communicate important updates or changes related to your account.",
            ]),

            _subTitle("2.3 Local storage"),
            _bodyText(
              "Some data, such as your events, may be stored locally on your device using secure storage mechanisms. "
              "This allows you to use the app even when you are offline. If you uninstall the app or clear app data, "
              "this locally stored information may be removed.",
            ),

            _subTitle("2.4 Data sharing"),
            _bodyText(
              "We do not sell your personal data. Limited information may be shared with service providers who help us run the app "
              "(such as analytics or cloud services), but only as needed and with appropriate safeguards.",
            ),

            _subTitle("2.5 Your choices and control"),
            _bulletList([
              "You can edit or delete events directly from the app.",
              "You can update your profile information at any time from the profile screen.",
              "You may request that your account be deactivated or certain data be removed (subject to technical and legal limitations).",
            ]),

            _subTitle("2.6 Security"),
            _bodyText(
              "We take reasonable measures to protect your data, but no system is 100% secure. "
              "Please use strong passwords and keep your device secure.",
            ),

            _subTitle("2.7 Changes to this policy"),
            _bodyText(
              "We may update these Terms and this Privacy Policy from time to time. "
              "Significant changes will be reflected in the \"Last updated\" date above.",
            ),

            const SizedBox(height: 24),

            _sectionTitle("3. Contact us"),
            _bodyText(
              "If you have any questions about these Terms or our Privacy Policy, you can contact us at:",
            ),
            const SizedBox(height: 4),
            Text(
              "support@youreventapp.com",
              style: TextStyle(
                fontSize: 14,
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 32),

            Center(
              child: Text(
                "By continuing to use the app, you agree to these Terms & Privacy Policy.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: Colors.grey[700]),
              ),
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

// ---------- Helper widgets / functions ----------

Widget _sectionTitle(String text) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Text(
      text,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
    ),
  );
}

Widget _subTitle(String text) {
  return Padding(
    padding: const EdgeInsets.only(top: 16, bottom: 6),
    child: Text(
      text,
      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
    ),
  );
}

Widget _bodyText(String text) {
  return Text(
    text,
    style: TextStyle(fontSize: 13.5, color: Colors.grey[800], height: 1.4),
  );
}

Widget _bulletList(List<String> items) {
  return Padding(
    padding: const EdgeInsets.only(top: 4),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children:
          items
              .map(
                (e) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("•  ", style: TextStyle(fontSize: 13.5)),
                      Expanded(
                        child: Text(
                          e,
                          style: TextStyle(
                            fontSize: 13.5,
                            color: Colors.grey[800],
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
              .toList(),
    ),
  );
}
