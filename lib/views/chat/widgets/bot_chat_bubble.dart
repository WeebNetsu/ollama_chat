import 'package:flutter/material.dart';

class BotChatBubble extends StatefulWidget {
  final String message;
  const BotChatBubble({super.key, required this.message});

  @override
  State<BotChatBubble> createState() => _BotChatBubbleState();
}

class _BotChatBubbleState extends State<BotChatBubble> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 15, 10, 0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 10,
          ),
          child: Text(widget.message),
        ),
      ),
    );
  }
}
