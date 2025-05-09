import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatScreen extends StatefulWidget {
  final String name;

  ChatScreen({required this.name});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final RxList<Map<String, dynamic>> _messages = <Map<String, dynamic>>[
    {'text': 'Hi! How are you?', 'isSent': true},
    {'text': 'Hey! I’m doing great, thanks for asking!', 'isSent': false},
    {'text': 'What’s your favorite thing to do on weekends?', 'isSent': true},
    {'text': 'I love hiking and reading. You?', 'isSent': false},
  ].obs;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;
    final padding = isMobile ? 12.0 : 16.0;

    return Scaffold(
      backgroundColor: Color(0xfff0f3f2),
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: Text(
          'Chat with ${widget.name}',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color(0xff1b60c9),
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() => ListView.builder(
                  padding: EdgeInsets.all(padding),
                  itemCount: _messages.length,
                  itemBuilder: (context, index) {
                    final message = _messages[index];
                    return _buildMessage(message['text'], message['isSent']);
                  },
                )),
          ),
          Padding(
            padding: EdgeInsets.all(padding),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      hintText: 'Type a message...',
                      hintStyle: TextStyle(fontSize: 12),
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: padding),
                IconButton(
                  icon: Icon(Icons.send, color: Color(0xff1b60c9)),
                  onPressed: () {
                    _sendMessage();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessage(String text, bool isSent) {
    return Align(
      alignment: isSent ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isSent ? Color(0xff1b60c9) : Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isSent ? Colors.white : Colors.black,
            fontSize: 14,
          ),
        ),
      ),
    );
  }


  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isNotEmpty) {
      _messages.add({'text': text, 'isSent': true}); // Add the new message
      _messageController.clear(); // Clear the input field
    }
  }




}
