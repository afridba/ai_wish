import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Screens
import 'splash_screen.dart';
import 'text_to_image_page.dart';
import 'home_screen.dart';
import 'screens/settings_page.dart';
import 'background_remover_screen.dart';
import 'enhance_photo_page.dart';
import 'screens/chatbot_page.dart';
import 'screens/onboarding_screen.dart'; // Onboarding screen

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.light;

  void _toggleTheme(bool isDark) {
    setState(() {
      _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    });
  }

  Future<bool> _isOnboardingDone() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('onboarding_done') ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AI Wish',
      debugShowCheckedModeBanner: false,
      themeMode: _themeMode,
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.blueAccent,
          foregroundColor: Colors.white,
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black87,
          foregroundColor: Colors.white,
        ),
      ),
      home: FutureBuilder<bool>(
        future: _isOnboardingDone(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SplashScreen();
          } else if (snapshot.hasError) {
            return const Scaffold(
              body: Center(child: Text("Error loading app.")),
            );
          } else {
            final isDone = snapshot.data ?? false;
            return isDone
                ? HomeScreen(onThemeToggle: _toggleTheme)
                : OnboardingScreen(
                    onThemeToggle: _toggleTheme,
                    onContinue: () async {
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.setBool('onboarding_done', true);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              HomeScreen(onThemeToggle: _toggleTheme),
                        ),
                      );
                    },
                  );
          }
        },
      ),
      routes: {
        '/home': (context) => HomeScreen(onThemeToggle: _toggleTheme),
        '/settings': (context) => SettingsPage(onThemeToggle: _toggleTheme),
        '/text-to-image': (context) => const TextToImagePage(),
        '/bg-remover': (context) => const BackgroundRemoverPage(),
        '/enhance': (context) => const EnhancePhotoPage(),
        '/chatbot': (context) => const ChatBotPage(),
      },
    );
  }
}
