import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:ai_wish/screens/settings_page.dart';
import 'package:ai_wish/screens/chatbot_page.dart';
import 'package:ai_wish/widgets/chatbot_button.dart'; // ✅ Import ChatBotButton

class HomeScreen extends StatelessWidget {
  final Function(bool) onThemeToggle;

  const HomeScreen({super.key, required this.onThemeToggle});

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Wish Home'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.brightness_6),
            onPressed: () {
              onThemeToggle(!isDark);
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      SettingsPage(onThemeToggle: onThemeToggle),
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [
            _buildFeatureCard(
              context,
              title: 'Text to Image',
              lottiePath: 'assets/animations/text_to_image.json',
              routeWidget: const PlaceholderScreen(title: 'Text to Image'),
            ),
            _buildFeatureCard(
              context,
              title: 'BG Remover',
              lottiePath: 'assets/animations/bg_remover.json',
              routeWidget: const PlaceholderScreen(title: 'BG Remover'),
            ),
            _buildFeatureCard(
              context,
              title: 'Enhance Photo',
              lottiePath: 'assets/animations/enhance.json',
              routeWidget: const PlaceholderScreen(title: 'Enhance Photo'),
            ),
            _buildFeatureCard(
              context,
              title: 'AI Background',
              lottiePath: 'assets/animations/ai_background.json',
              routeWidget: const PlaceholderScreen(title: 'AI Background'),
            ),
            _buildFeatureCard(
              context,
              title: 'AI Chatbot',
              lottiePath: 'assets/animations/chatbot.json',
              routeWidget: const ChatBotPage(),
            ),
          ],
        ),
      ),
      floatingActionButton: const ChatBotButton(), // ✅ Floating Chatbot Button
    );
  }

  Widget _buildFeatureCard(
    BuildContext context, {
    required String title,
    required String lottiePath,
    required Widget routeWidget,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => routeWidget),
        );
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              lottiePath.isNotEmpty
                  ? Lottie.asset(lottiePath, height: 100)
                  : const Icon(Icons.image, size: 80, color: Colors.blue),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PlaceholderScreen extends StatelessWidget {
  final String title;

  const PlaceholderScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Text(
          '$title Page Coming Soon',
          style: const TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
