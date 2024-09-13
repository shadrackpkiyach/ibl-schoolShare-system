import 'package:flutter/material.dart';
import 'package:student/models/ChatModel.dart';
import 'package:student/screens/home/CustomUI/ChartCard.dart';
import 'package:student/screens/home/CustomUI/select_chat.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<ChatModel> chats = [
    ChatModel(
        name: "shaddy",
        isGroup: false,
        currentMessage: "sasa",
        time: "1:00",
        icon: "person.svg",
        id: ''),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (builder) => const SelectChat()));
        },
        child: const Icon(Icons.chat),
      ),
      body: ListView.builder(
        itemCount: chats.length,
        itemBuilder: (context, index) => ChartCard(chatModel: chats[index]),
      ),
    );
  }
}
