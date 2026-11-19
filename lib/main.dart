import 'package:flutter/material.dart';
import './preview_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Text previewer',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const TextInputScreen(),
    );
  }
}

class TextInputScreen extends StatefulWidget {
  const TextInputScreen({super.key});

  @override
  State<TextInputScreen> createState() => _TextInputScreenState();
}

class _TextInputScreenState extends State<TextInputScreen> {
  final TextEditingController _textController = TextEditingController();
  double _fontSize = 16.0;

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  Future<void> _openPreview() async {
    final textToShow =
    _textController.text.isEmpty ? 'Sample text' : _textController.text;

    final result = await Navigator.push<String>(
      context,
      MaterialPageRoute(
        builder: (context) => PreviewScreen(
          text: textToShow,
          fontSize: _fontSize,
        ),
      ),
    );

    if (!mounted) return;

    String message;
    if (result == 'ok') {
      message = 'Cool!';
    } else if (result == 'cancel') {
      message = "Let's try something else.";
    } else {
      message = "Don't know what to say.";
    }

    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Text previewer'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _textController,
              decoration: const InputDecoration(
                labelText: 'Text',
                helperText: 'Enter some text',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Text(
                  'Font size: ${_fontSize.round()}',
                  style: const TextStyle(fontSize: 16),
                ),
                Expanded(
                  child: Slider(
                    value: _fontSize,
                    min: 10.0,
                    max: 64.0,
                    onChanged: (value) {
                      setState(() {
                        _fontSize = value;
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _openPreview,
              child: const Text('Preview'),
            ),
          ],
        ),
      ),
    );
  }
}