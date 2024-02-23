import 'package:flutter/material.dart';

class UserChatBubble extends StatefulWidget {
  final String message;
  const UserChatBubble({super.key, required this.message});

  @override
  State<UserChatBubble> createState() => _UserChatBubbleState();
}

class _UserChatBubbleState extends State<UserChatBubble> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 15, 10, 0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.green,
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
