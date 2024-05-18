import 'package:flutter/material.dart';
import 'api.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() {
    return _ChatScreenState();
  }
}

class _ChatScreenState extends State<ChatScreen> {
  final ApiClient apiClient = ApiClient();
  @override
  Widget build(BuildContext context) {
  return Scaffold(
      body: Center(
            child: Container(
              color: Color.fromARGB(255, 164, 216, 164),
            ),
          ),
        );
      }
    }