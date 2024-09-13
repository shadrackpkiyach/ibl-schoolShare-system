import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:student/constants/global_variables.dart';
import 'package:student/models/getmessageModel.dart';

import 'package:http/http.dart' as http;

class TeacherSentMessageCard extends StatefulWidget {
  const TeacherSentMessageCard({
    Key? key,
    required this.content,
  }) : super(key: key);
  final String content;

  @override
  State<TeacherSentMessageCard> createState() => _TeacherSentMessageCardState();
}

class _TeacherSentMessageCardState extends State<TeacherSentMessageCard> {
  List<MessageModel1> messages1 = [];
  @override
  void initState() {
    super.initState();
    fetchMessages();
    //getUserData();
  }

  Future<void> fetchMessages() async {
    try {
      // Replace "YOUR_NODE_API_URL" with the actual URL of your Node.js API
      final response = await http.get(Uri.parse('$uri/usersMessages'));

      if (response.statusCode == 200) {
        // Parse the response JSON and update the messages list
        final List<dynamic> messagesData = jsonDecode(response.body);
        setState(() {
          messages1 = messagesData
              .map((messageJson) => MessageModel1.fromJson(messageJson))
              .toList();
        });
      } else {
        // Handle errors when fetching messages
        print('Failed to fetch messages');
      }
    } catch (e) {
      // Handle exceptions when fetching messages
      print('Error fetching messages: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width - 45,
        ),
        child: Card(
          elevation: 1,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          color: const Color.fromARGB(255, 152, 242, 221),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    left: 10, right: 45, top: 10, bottom: 20),
                child: Text(widget.content,
                    style: const TextStyle(fontSize: 17, color: Colors.grey)),
              ),
              const Positioned(
                  bottom: 4,
                  right: 10,
                  child: Row(
                    children: [
                      Text('2:00',
                          style: TextStyle(fontSize: 13, color: Colors.grey)),
                      Icon(Icons.done_all)
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
