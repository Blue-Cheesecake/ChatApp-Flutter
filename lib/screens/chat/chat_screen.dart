import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // List of message
    return Scaffold(
      body: SafeArea(
        child: ListView.builder(
          itemCount: 10,
          itemBuilder: (context, index) => Container(
            padding: const EdgeInsets.all(8),
            child: const Text("This work"),
          ),
        ),
      ),
    );
  }
}
