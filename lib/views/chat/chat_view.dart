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

//   final StreamController<OllamaResponseModel> _responseController = StreamController<OllamaResponseModel>();
//   final List<String> _responses = [];
  final List<String> _completedResponses = ['Hi! What can I help you with today?'];

  @override
  void dispose() {
    // _responseController.close(); // Close the stream controller when not needed
    super.dispose();
  }

  Future<void> sendMessage() async {
    String message = _textController.text;
    _textController.clear();

    if (message.isEmpty) {
      showMessage(context, "Message cannot be empty");
      return;
    }
    String newResponse = "";
    int index = 0;

    setState(() {
      _completedResponses.add("Thinking real hard...");
    });

    await for (final chunk in ai.sendMessage(message)) {
      //   _responseController.add(chunk);
      //   _responses.add(chunk.response);
      newResponse += chunk.response;

      if (index == 0) _completedResponses.removeLast();
      index++;

      // it's actually really fast (I'm assuming), this makes it feel more ChatGPT-like
      //   await Future.delayed(const Duration(milliseconds: 100));
    }

    setState(() {
      _completedResponses.add(newResponse);
      //   _responses.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(height: 10), // Size specified here
          Column(
            children: _completedResponses.map((cr) {
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Text(cr),
                  ),
                  SizedBox(height: 20),
                ],
              );
            }).toList(),
          ),
          //   StreamBuilder<OllamaResponseModel>(
          //     stream: _responseController.stream,
          //     builder: (context, snapshot) {
          //       if (snapshot.hasData) {
          //         return Text(_responses.join());
          //       } else if (snapshot.hasError) {
          //         return Text('Error: ${snapshot.error}');
          //       } else {
          //         return const Text('Hi! What can I help you with today?');
          //       }
          //     },
          //   ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: const InputDecoration(
                        hintText: 'Enter your text...',
                        border: OutlineInputBorder(),
                      ),
                      controller: _textController,
                    ),
                  ),
                  TextButton(
                    onPressed: sendMessage,
                    child: const Icon(
                      Icons.send,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
