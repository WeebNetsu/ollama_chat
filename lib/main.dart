import 'package:flutter/material.dart';
import 'package:ollama_chat/routes.dart';
import 'package:ollama_chat/theme/theme.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});
// test
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ollama Chat',
      theme: AppTheme.theme,
      routes: routes,
    );
  }
}
