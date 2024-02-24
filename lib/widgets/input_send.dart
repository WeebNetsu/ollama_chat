import 'package:flutter/material.dart';

class InputSend extends StatefulWidget {
  final void Function() onPressed;
  final void Function()? onClear;
  final TextEditingController controller;
  const InputSend({super.key, required this.onPressed, required this.controller, this.onClear});

  @override
  State<InputSend> createState() => _InputSendState();
}

class _InputSendState extends State<InputSend> {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            widget.onClear != null
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: widget.onClear,
                        child: const Text("Clear Conversation"),
                      ),
                    ],
                  )
                : Container(),
            const SizedBox(height: 5),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                      hintText: 'Enter your text...',
                      border: OutlineInputBorder(),
                    ),
                    controller: widget.controller,
                    onSubmitted: ((String value) {
                      widget.onPressed();
                    }),
                  ),
                ),
                TextButton(
                  onPressed: widget.onPressed,
                  child: const Icon(
                    Icons.send,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
