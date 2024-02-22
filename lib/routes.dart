import 'package:flutter/material.dart';
import 'package:ollama_chat/views/chat/chat_view.dart';

Map<String, Widget Function(BuildContext)> routes = {
  "/": (context) => const ChatView(),
  '/chat': (context) => const ChatView(),
};
