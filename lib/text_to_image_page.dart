import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TextToImagePage extends StatefulWidget {
  const TextToImagePage({super.key});

  @override
  State<TextToImagePage> createState() => _TextToImagePageState();
}

class _TextToImagePageState extends State<TextToImagePage> {
  final TextEditingController _promptController = TextEditingController();
  String? _imageUrl;
  bool _isLoading = false;
  String? _error;

  Future<void> _generateImage() async {
    final backendUrl = dotenv.env['BACKEND_URL'];
    if (backendUrl == null || backendUrl.isEmpty) {
      setState(() {
        _error = "Backend URL not found. Please check your .env file.";
      });
      return;
    }

    final prompt = _promptController.text.trim();
    if (prompt.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a prompt.")),
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
      _imageUrl = null;
    });

    try {
      final response = await http.post(
        Uri.parse(backendUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'prompt': prompt}),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['image_url'] != null) {
        setState(() {
          _imageUrl = data['image_url'];
        });
      } else {
        setState(() {
          _error = data['error'] ?? 'Image generation failed.';
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Something went wrong. Please try again.';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _promptController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Text to Image')),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: _promptController,
                  decoration: const InputDecoration(
                    labelText: 'Enter a prompt',
                    border: OutlineInputBorder(),
                  ),
                  textInputAction: TextInputAction.done,
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _generateImage,
                    child: const Text('Generate Image'),
                  ),
                ),
                const SizedBox(height: 20),
                if (_error != null)
                  Text(
                    _error!,
                    style: const TextStyle(color: Colors.red),
                  ),
                if (_imageUrl != null)
                  Column(
                    children: [
                      const Text(
                        "Generated Image:",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      Image.network(_imageUrl!),
                    ],
                  ),
              ],
            ),
          ),
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}
