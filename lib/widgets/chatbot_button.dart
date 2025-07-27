// lib/widgets/chatbot_button.dart

import 'package:flutter/material.dart';
import '../screens/chatbot_page.dart';

class ChatBotButton extends StatelessWidget {
  const ChatBotButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ChatBotPage()),
        );
      },
      tooltip: 'AI Chatbot',
      backgroundColor: Colors.deepPurple,
      child: const Icon(Icons.chat),
    );
  }
}
