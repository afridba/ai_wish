import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsPage extends StatelessWidget {
  final void Function(bool) onThemeToggle;

  const SettingsPage({super.key, required this.onThemeToggle});

  void _launchEmail() async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'afridbasha730@gmail.com',
      query: 'subject=Feedback&body=Hello, I have some feedback...',
    );
    if (await canLaunchUrl(emailLaunchUri)) {
      await launchUrl(emailLaunchUri);
    }
  }

  void _launchInstagram() async {
    const String instagramUrl = 'https://instagram.com/mr.sab.007';
    if (await canLaunchUrl(Uri.parse(instagramUrl))) {
      await launchUrl(Uri.parse(instagramUrl));
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Avatar
          Center(
            child: CircleAvatar(
              radius: 50,
              backgroundImage: const AssetImage('assets/avatar.png'),
              backgroundColor: Colors.grey[300],
            ),
          ),
          const SizedBox(height: 10),

          // Name
          const Center(
            child: Text(
              'Afrid',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 30),

          // Theme Switch
          SwitchListTile(
            title: const Text("🌙 Dark Mode"),
            value: isDark,
            onChanged: (value) {
              onThemeToggle(value);
            },
          ),

          // Email
          ListTile(
            leading: const Icon(Icons.email),
            title: const Text("Contact via Email"),
            subtitle: const Text("afridbasha730@gmail.com"),
            onTap: _launchEmail,
          ),

          // Instagram
          ListTile(
            leading: const Icon(Icons.camera_alt),
            title: const Text("Instagram"),
            subtitle: const Text("@mr.sab.007"),
            onTap: _launchInstagram,
          ),

          // Privacy Policy
          const ListTile(
            leading: Icon(Icons.security),
            title: Text("Privacy Policy"),
            subtitle: Text("Your data is safe and never shared."),
          ),

          // About the App
          const AboutListTile(
            icon: Icon(Icons.info_outline),
            applicationName: "AI Wish App",
            applicationVersion: "1.0.0",
            applicationLegalese: "© 2025 Afrid Studio",
          ),
        ],
      ),
    );
  }
}
