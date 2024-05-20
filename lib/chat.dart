import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:typed_data'; 
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
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
  final TextEditingController _controller = TextEditingController();
  final List<Message> _messages = [];
  final ScrollController _scrollController = ScrollController(); 

  late String userName;
  late String avatar;
  Uint8List? avatarDecoded;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _getFromArguments();
  }

  void _getFromArguments() {
    final ModalRoute? modalRoute = ModalRoute.of(context);
    if (modalRoute != null) {
      final Map<String, dynamic>? args =
          modalRoute.settings.arguments as Map<String, dynamic>?;
      if (args != null) {
        setState(() {
          userName = args['user_name'] as String? ?? '';
          avatar = args['avatar'] as String? ?? '';
          if (avatar.isNotEmpty) {
            avatarDecoded = base64Decode(avatar);
          }
        });
      }
    }
  }

  void _sendMessage() async {
    String messageText = _controller.text;
    if (messageText.isNotEmpty) {
      setState(() {
        _messages.add(Message(
          text: messageText,
          username: userName,
          avatar: avatarDecoded,
          isUser: true,
        ));
        _controller.clear();
      });

      _scrollToBottom();

      try {
        Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);
        double latitude = position.latitude;
        double longitude = position.longitude;

        final http.Response response = await apiClient.post('/ask_ai', {
          'question': messageText,
          'latitude': latitude,
          'longitude': longitude,
        });

        if (response.statusCode == 200) {
          Map<String, dynamic> responseData = jsonDecode(response.body);
          String aiResponse = responseData['message'];
          setState(() {
            _messages.add(Message(
              text: aiResponse,
              username: 'AI',
              avatar: null, 
              isUser: false,
            ));
          });

          _scrollToBottom();
        } else {
          setState(() {
            _messages.add(Message(
              text: "A IA não está preparada para esse tipo de interação.",
              username: 'AI',
              avatar: null, 
              isUser: false,
            ));
          });

          _scrollToBottom();
        }
      } catch (e) {
        print('Error fetching location: $e');
      }
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: Container(
              color: const Color.fromARGB(255, 164, 216, 164),
            ),
          ),
          Positioned.fill(
            child: Column(
              children: [
                const SizedBox(height: 40),
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      final message = _messages[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: ChatBubble(message: message),
                      );
                    },
                  ),
                ),
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          decoration: InputDecoration(
                            hintText: 'Escreva sua mensagem',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide.none,
                            ),
                            fillColor: Colors.grey[200],
                            filled: true,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      IconButton(
                        icon: const Icon(Icons.send),
                        onPressed: _sendMessage,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


class Message {
  final String text;
  final Uint8List? avatar;
  final bool isUser;
  final String username;

  Message({
    required this.text,
    required this.avatar,
    required this.isUser,
    required this.username,
  });
}

class ChatBubble extends StatelessWidget {
  final Message message;

  const ChatBubble({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        CircleAvatar(
          backgroundImage: message.avatar != null
              ? MemoryImage(message.avatar!)
              : null,
          child: message.avatar == null ? Icon(Icons.person) : null,
        ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  message.username,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.8,
                  ),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: message.isUser ? Colors.blue : Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minWidth: 600, 
                    ),
                    child: Text(
                      message.text,
                      style: TextStyle(
                        color: message.isUser ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
