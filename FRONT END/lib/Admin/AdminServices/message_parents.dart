import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';
import 'package:student/Admin/AdminServices/sending_message_service.dart';
import 'package:student/constants/global_variables.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:student/models/adminMessage.dart';
import 'package:student/models/emails.dart';

class AdminMessage extends StatefulWidget {
  static const String routeName = '/messaging-screen';
  const AdminMessage({super.key});

  @override
  State<AdminMessage> createState() => _AdminMessageState();
}

class _AdminMessageState extends State<AdminMessage> {
  AdminMessageService adminMessageService = AdminMessageService();
  List<MessageAdminModel> messages = [];
  List<emailModel> emails = [];
  final TextEditingController textController = TextEditingController();
  final TextEditingController subjectController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchAdminMessages();
    fetchEmails();
  }

  void sendingMessage() {
    adminMessageService.sendMessage(
      context: context,
      text: textController.text,
      subject: subjectController.text,
      emails: emails,
    );
  }

  Future<void> fetchEmails() async {
    try {
      // Make an HTTP request to fetch the admin messages from your backend
      var response = await http.get(Uri.parse('$uri/usersAll'));

      if (response.statusCode == 200) {
        // If the request is successful (status code 200), parse the response body
        // and update the messages list with the retrieved data
        var jsonData = jsonDecode(response.body);

        setState(() {
          emails.addAll(
            jsonData.map<emailModel>((user) => emailModel(
                  emails: user['email'],
                )),
          );

          print(emails);
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
        floatingActionButton: SizedBox(
            width: 200,
            child: FloatingActionButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      String? subject;
                      String? text;

                      return StatefulBuilder(
                        builder: (context, setState) {
                          return AlertDialog(
                            title: const Text('Send Message to parents'),
                            content: SingleChildScrollView(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TextField(
                                    controller: subjectController,
                                    onChanged: (value) {
                                      subject = value;
                                    },
                                    decoration: const InputDecoration(
                                      labelText: 'subject',
                                    ),
                                  ),
                                  SizedBox(
                                    width: 300,
                                    child: TextField(
                                      controller: textController,
                                      onChanged: (value) {
                                        text = value;
                                      },
                                      decoration: const InputDecoration(
                                        labelText: 'type message',
                                      ),
                                      maxLines: null,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text(
                                  "close",
                                ),
                              ),
                              TextButton(
                                onPressed: () async {
                                  if (text!.isEmpty || subject!.isEmpty) {
                                    // Validate that all fields are filled
                                    return;
                                  }
                                  sendingMessage();

                                  //  setState(() {
                                  //    titleController.clear();
                                  //   workflowController.clear();
                                  // });
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text('message sent'),
                                        content: const Text(
                                            'The email has been sent successfully.'),
                                        actions: <Widget>[
                                          TextButton(
                                            child: const Text('OK'),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );

                                  // Close the dialog
                                  //Navigator.of(context).pop();
                                },
                                child: const Text('send message'),
                              ),
                            ],
                          );
                        },
                      );
                    });
              },
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                    Radius.circular(8.0)), // Set the desired radius
              ),
              child: const Stack(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Icon(Icons.chat),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 8.0),
                      child: Text('sent message '),
                    ),
                  ),
                ],
              ),
            )),
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
