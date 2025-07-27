import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

/// This is for AI Background Generation
class AiBackgroundScreen extends StatefulWidget {
  const AiBackgroundScreen({super.key});

  @override
  State<AiBackgroundScreen> createState() => _AiBackgroundScreenState();
}

class _AiBackgroundScreenState extends State<AiBackgroundScreen> {
  Uint8List? imageBytes;
  final TextEditingController _controller = TextEditingController();
  bool loading = false;

  Future<void> generateBackground(String prompt) async {
    const apiUrl = 'https://api-inference.huggingface.co/models/stabilityai/stable-diffusion-2';
    const apiKey = 'your_token_here';

    setState(() => loading = true);

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'inputs': prompt}),
    );

    if (response.statusCode == 200) {
      setState(() {
        imageBytes = response.bodyBytes;
        loading = false;
      });
    } else {
      print('Error: ${response.statusCode}');
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Background Generator'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'Enter Background Prompt',
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => generateBackground(_controller.text),
              child: const Text('Generate Background'),
            ),
            const SizedBox(height: 20),
            if (loading) const CircularProgressIndicator(),
            if (imageBytes != null)
              Expanded(
                child: SingleChildScrollView(
                  child: Image.memory(imageBytes!),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// ✅ Dummy Background Remover Screen for Navigation (Update this later)
class BackgroundRemoverScreen extends StatelessWidget {
  const BackgroundRemoverScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AI Background Remover')),
      body: const Center(child: Text('Background Remover Working!')),
    );
  }
}
