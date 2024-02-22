import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ollama_chat/models/ollama_request.dart';
import 'package:ollama_chat/utils/utils.dart';

class ChatView extends StatefulWidget {
  const ChatView({super.key});

  // this is so we can easily call the route
  // to this component from other files
  static route() => MaterialPageRoute(
        builder: (context) => const ChatView(),
      );

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  final TextEditingController _textController = TextEditingController();
  final OllamaRequestModel ai = OllamaRequestModel("mistral");

  final StreamController<OllamaResponseModel> _responseController = StreamController<OllamaResponseModel>();
  final List<String> _responses = [];

  @override
  void dispose() {
    _responseController.close(); // Close the stream controller when not needed
    super.dispose();
  }

  void sendMessage() async {
    String message = _textController.text;

    if (message.isEmpty) {
      showMessage(context, "Message cannot be empty");
      return;
    }

    await for (final chunk in ai.sendMessage(message)) {
      _responseController.add(chunk);
      _responses.add(chunk.response);
      // it's actually really fast (I'm assuming), this makes it feel more ChatGPT-like
      await Future.delayed(Duration(milliseconds: 100));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            const Text('Enter your message here'),
            TextField(
              controller: _textController,
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: sendMessage,
              child: const Text("Send message"),
            ),
            const SizedBox(height: 10),
            StreamBuilder<OllamaResponseModel>(
              stream: _responseController.stream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Text(_responses.join());
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return Text('Waiting for response...');
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
