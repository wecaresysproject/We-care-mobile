import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';

class SpeechToTextDemoApp extends StatefulWidget {
  const SpeechToTextDemoApp({super.key});

  @override
  SpeechToTextDemoAppState createState() => SpeechToTextDemoAppState();
}

class SpeechToTextDemoAppState extends State<SpeechToTextDemoApp> {
  late SpeechToText speechToText;
  bool isListening = false;
  String recognizedText = '';

  @override
  void initState() {
    super.initState();
    _initSpeech();
  }

  /// This has to happen only once per app
  void _initSpeech() async {
    speechToText = SpeechToText();
    bool isAvailable = await speechToText.initialize();
    var locales = await speechToText.locales();

    for (var locale in locales) {
      log('LocaleId: ${locale.localeId}, Name: ${locale.name}');
    }

    if (isAvailable) {
      setState(
        () {
          isListening = false;
        },
      );
    }
  }

  /// Each time to start a speech recognition session
  void _startListening() async {
    await speechToText.listen(
      onResult: (result) {
        setState(() {
          recognizedText = result.recognizedWords;
          log("recognizedText: $recognizedText");
        });
      },
      localeId: "ar_EG",
    );
    setState(
      () {
        isListening = true;
      },
    );
  }

  /// Manually stop the active speech recognition session
  /// Note that there are also timeouts that each platform enforces
  /// and the SpeechToText plugin supports setting timeouts on the
  /// listen method.
  void _stopListening() async {
    if (isListening) {
      await speechToText.stop();
      setState(() {
        isListening = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Speech Demo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(16),
              child: Text(
                'Recognized words:',
                style: TextStyle(fontSize: 20.0),
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(16),
                child: Text(
                  // If listening is active show the recognized words
                  isListening
                      ? recognizedText
                      // If listening isn't active but could be tell the user
                      // how to start it, otherwise indicate that speech
                      // recognition is not yet ready or not supported on
                      // the target device
                      : "iam not listening",
                  style: TextStyle(
                    fontSize: 32.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed:
            // If not yet listening for speech start, otherwise stop
            !isListening ? _startListening : _stopListening,
        tooltip: 'Listen',
        child: Icon(!isListening ? Icons.mic_off : Icons.mic),
      ),
    );
  }
}
