import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class OnboardingScreen extends StatelessWidget {
  final VoidCallback onContinue;
  final Function(bool) onThemeToggle;

  const OnboardingScreen({
    super.key,
    required this.onContinue,
    required this.onThemeToggle,
  });

  final List<Map<String, String>> features = const [
    {
      'title': 'Text to Image',
      'description': 'Convert your text into AI-generated images.',
      'animation': 'assets/animations/text_to_image.json',
    },
    {
      'title': 'Text to Voice',
      'description': 'Listen to your text with natural voices.',
      'animation': 'assets/animations/text_to_voice.json',
    },
    {
      'title': 'Text to Song',
      'description': 'Generate music from your lyrics.',
      'animation': 'assets/animations/text_to_song.json',
    },
    {
      'title': 'Voice Cloner',
      'description': 'Clone any voice with just a sample.',
      'animation': 'assets/animations/voice_cloner.json',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final PageController controller = PageController();
    int currentPage = 0;

    return Scaffold(
      backgroundColor: Colors.black,
      body: StatefulBuilder(
        builder: (context, setState) {
          return SafeArea(
            child: PageView.builder(
              controller: controller,
              onPageChanged: (index) => setState(() => currentPage = index),
              itemCount: features.length,
              itemBuilder: (context, index) {
                final feature = features[index];
                return Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Lottie.asset(
                              feature['animation']!,
                              height: 220,
                              fit: BoxFit.contain,
                            ),
                            const SizedBox(height: 20),
                            Text(
                              feature['title']!,
                              style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              feature['description']!,
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.white70,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 30),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(features.length, (dotIndex) {
                                return AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  margin: const EdgeInsets.symmetric(horizontal: 4),
                                  width: currentPage == dotIndex ? 12 : 8,
                                  height: currentPage == dotIndex ? 12 : 8,
                                  decoration: BoxDecoration(
                                    color: currentPage == dotIndex ? Colors.white : Colors.grey,
                                    shape: BoxShape.circle,
                                  ),
                                );
                              }),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            if (index == features.length - 1) {
                              onContinue();
                            } else {
                              controller.nextPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            index == features.length - 1 ? 'Get Started 🚀' : 'Next →',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextButton(
                        onPressed: () {
                          onThemeToggle(true); // you can toggle to dark mode, etc.
                        },
                        child: const Text(
                          "Toggle Theme 🌗",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
