import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ollama_chat/models/models.dart';
import 'package:ollama_chat/utils/utils.dart';
import 'package:ollama_chat/views/chat/widgets/chat_widgets.dart';
import 'package:ollama_chat/widgets/widgets.dart';

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
  final TextEditingController _messageController = TextEditingController();
  final OllamaRequestModel ai = OllamaRequestModel("mistral");

//   final StreamController<OllamaResponseModel> _responseController = StreamController<OllamaResponseModel>();
//   final List<String> _responses = [];
  final List<MessageModel> _allMessages = [
    MessageModel('Hi! What can I help you with today?', bot: true),
  ];

  @override
  void dispose() {
    // _responseController.close(); // Close the stream controller when not needed
    super.dispose();
  }

  Future<void> sendMessage() async {
    String message = _messageController.text;
    _messageController.clear();

    if (message.isEmpty) {
      showMessage(context, "Message cannot be empty");
      return;
    }
    String newResponse = "";
    int index = 0;

    _allMessages.add(MessageModel(message));

    setState(() {
      _allMessages.add(MessageModel("Thinking real hard...", bot: true));
    });

    await for (final chunk in ai.sendMessage(message)) {
      //   _responseController.add(chunk);
      //   _responses.add(chunk.response);
      newResponse += chunk.response;

      if (index == 0) _allMessages.removeLast();
      index++;

      // it's actually really fast (I'm assuming), this makes it feel more ChatGPT-like
      //   await Future.delayed(const Duration(milliseconds: 100));
    }

    setState(() {
      _allMessages.add(MessageModel(newResponse, bot: true));
      //   _responses.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ..._allMessages.map((message) {
                if (message.bot) {
                  return BotChatBubble(message: message.message);
                }
                return Align(
                  alignment: Alignment.topRight,
                  child: UserChatBubble(message: message.message),
                );
              }),
            ],
          ),
          InputSend(onPressed: sendMessage, controller: _messageController),
        ],
      ),
    );
  }
}
