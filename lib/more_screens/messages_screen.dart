import 'package:flutter/material.dart';

import 'package:peopleapp_flutter/core/constants/color_constants.dart';

class Message {
  final String content;
  final bool isMe;
  final DateTime timestamp;
  Message(this.content, this.isMe, this.timestamp);
}

class MessagesScreen extends StatelessWidget {
  final List<Message> messages = [
    Message(
        "Hey man!", false, DateTime.now().subtract(const Duration(minutes: 3))),
    Message("Check out \$sumit token", false,
        DateTime.now().subtract(const Duration(minutes: 2))),
    Message("It has gained 30% increase in\nthe last 24hrs", false,
        DateTime.now().subtract(const Duration(minutes: 1))),
    Message("Oh wow! right away", true, DateTime.now()),
    Message("perfect! ✅", true, DateTime.now()),
  ];
  //
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.darkBackground,
      appBar: AppBar(
        backgroundColor: ColorConstants.primaryPurple,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Messages',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
      ),
      body: _buildMessagesList(context),
    );
  }

  Widget _buildMessagesList(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            itemCount: messages.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ChatDetailScreen(messages: messages),
                    ),
                  );
                },
                child: _buildMessageListTile(
                  "Sofia Santos",
                  messages[index].content,
                  "4:27 PM",
                  "assets/default_user.png",
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildMessageListTile(
      String name, String message, String time, String avatar) {
    return Container(
      margin: const EdgeInsets.only(bottom: 32),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: AssetImage(avatar),
            radius: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  message,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[400],
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Text(
            time,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[400],
            ),
          ),
        ],
      ),
    );
  }
}

class ChatDetailScreen extends StatelessWidget {
  final List<Message> messages;

  const ChatDetailScreen({Key? key, required this.messages}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildDetailHeader(context),
            Expanded(
              child: Stack(
                children: [
                  ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message = messages[index];
                      return _buildMessageBubble(message);
                    },
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: _buildMessageInput(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(Icons.arrow_back, color: Colors.white),
          ),
          const SizedBox(width: 16),
          const CircleAvatar(
            backgroundImage: AssetImage('assets/default_user.png'),
            radius: 20,
          ),
          const SizedBox(width: 16),
          const Text(
            "Sofia Santos",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(Message message) {
    return Align(
      alignment: message.isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color:
              message.isMe ? const Color(0xFF7257FF) : const Color(0xFF2A2B2F),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          message.content,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1B1E),
        border: Border(
          top: BorderSide(
            color: Colors.grey[800]!,
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.attach_file, color: Colors.grey[400]),
          const SizedBox(width: 16),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Type a message',
                hintStyle: TextStyle(color: Colors.grey[400]),
                border: InputBorder.none,
              ),
              style: const TextStyle(color: Colors.white),
            ),
          ),
          const Icon(Icons.send, color: Color(0xFF7257FF)),
        ],
      ),
    );
  }
}
