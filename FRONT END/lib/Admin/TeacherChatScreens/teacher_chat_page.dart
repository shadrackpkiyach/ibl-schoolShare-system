import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:student/Admin/TeacherChatScreens/selectparent.dart';
import 'package:student/Admin/TeacherChatScreens/teacherchatcard.dart';
import 'package:student/Admin/constants/utils.dart';
import 'package:student/constants/global_variables.dart';

import 'package:http/http.dart' as http;
import 'package:student/models/everchat.dart';

class TeacherChatPage extends StatefulWidget {
  const TeacherChatPage({Key? key}) : super(key: key);
  static const String routeName = '/teacher-chat-page';

  @override
  State<TeacherChatPage> createState() => _TeacherChatPageState();
}

class _TeacherChatPageState extends State<TeacherChatPage> {
  String? userProfile;
  List<ChatEverModel> chatsOnces = [];

  @override
  void initState() {
    super.initState();

    fetchMessages();
    //getUserData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> fetchMessages() async {
    bool userDataRetrieved = await getUserData();
    if (userDataRetrieved) {
      var userData = jsonDecode(userProfile!);

      try {
        // Replace "YOUR_NODE_API_URL" with the actual URL of your Node.js API
        var response = await http.get(
          Uri.parse('$uri/everMessages?senderId=${userData['email']}'),
        );

        if (response.statusCode == 200) {
          // Parse the response JSON and update the messages list
          final List<dynamic> messagesData = jsonDecode(response.body);

          setState(() {
            chatsOnces = messagesData
                .map((messageJson) => ChatEverModel.fromJson(messageJson))
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
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (builder) => const SelectParentChat()));
        },
        child: const Icon(Icons.chat),
      ),
      body: ListView.builder(
        itemCount: chatsOnces.length,
        itemBuilder: (context, index) =>
            TeacherChartCard(chatEverModel: chatsOnces[index]),
      ),
    );
  }

  Future<bool> getUserData() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('x-auth-token');

      if (token == null) {
        prefs.setString('x-auth-token', 'no S'); // empty string
      }

      var tokenRes = await http.post(Uri.parse('$uri/tokenIsValid'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token': token!
          });

      var response = jsonDecode(tokenRes.body);

      if (response == true) {
        http.Response userRes = await http.get(
          Uri.parse('$uri/getUserProfile'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token': token
          },
        );
        var userData = jsonDecode(userRes.body);
        // var userProvider = Provider.of<UserProvider>(context, listen: false);
        // userProvider.setUser(jsonEncode(userData));
        userProfile = jsonEncode(userData);
        return true;
        // print('User Data: ${jsonEncode(userData)}');
      } else {
        return false;
      }
    } catch (e) {
      showSnackBar(context, e.toString());
      return false;
    }
  }
}
