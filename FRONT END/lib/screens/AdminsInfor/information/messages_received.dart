import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';
import 'package:student/constants/global_variables.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:student/models/adminMessage.dart';

class AdminSentMessage extends StatefulWidget {
  const AdminSentMessage({super.key});

  @override
  State<AdminSentMessage> createState() => _AdminSentMessageState();
}

class _AdminSentMessageState extends State<AdminSentMessage> {
  List<MessageAdminModel> messages = [];

  @override
  void initState() {
    super.initState();
    fetchAdminMessages();
  }

  Future<void> fetchAdminMessages() async {
    try {
      // Make an HTTP request to fetch the admin messages from your backend
      var response = await http.get(Uri.parse('$uri/emails'));

      if (response.statusCode == 200) {
        // If the request is successful (status code 200), parse the response body
        // and update the messages list with the retrieved data
        var jsonData = jsonDecode(response.body);

        setState(() {
          messages = List<MessageAdminModel>.from(
              jsonData.map((message) => MessageAdminModel(
                    text: message['text'],
                    subject: message['subject'],
                  )));
        });
      } else {
        // Handle any errors or non-200 status codes
        print(
            'Failed to fetch admin messages. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // Handle any exceptions that occur during the request
      print('Error fetching admin messages: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(
                  context); // This will pop the current screen and go back to the previous screen.
            },
          ),
          title: const Text('Messages sent to parents'),
        ),
        body: ListView.builder(
          itemCount: messages.length,
          itemBuilder: (context, index) => Card(
            child: Column(
              children: [
                ListTile(
                  title: Text(messages[index].subject),
                  subtitle: ReadMoreText(
                    messages[index].text,
                    trimLines: 3,
                    textAlign: TextAlign.justify,
                    trimMode: TrimMode.Line,
                    trimCollapsedText: " Show More ",
                    trimExpandedText: " Show Less ",
                    lessStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.green[700],
                    ),
                    moreStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.green[700],
                    ),
                    style: const TextStyle(
                      fontSize: 16,
                      height: 2,
                    ),
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
