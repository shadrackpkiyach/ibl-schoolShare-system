import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:student/constants/global_variables.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:student/constants/utils.dart';
import 'package:student/models/getmessageModel.dart';
import 'package:student/models/messageModel.dart';
import 'package:student/models/selectChatModel.dart';
import 'package:student/providers/user_provider.dart';
import 'package:student/screens/home/CustomUI/receivedmessagecard.dart';
import 'package:student/screens/home/CustomUI/sentmessagecard.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class DmChatPage extends StatefulWidget {
  const DmChatPage({
    Key? key,
    required this.chatUser,
  }) : super(key: key);
  final SelectChatModel chatUser;
  @override
  State<DmChatPage> createState() => _DmChatPageState();
}

class _DmChatPageState extends State<DmChatPage> {
  ScrollController scrollController = ScrollController();
  late IO.Socket socket;
  bool sendButton = false;
  List<MessageModel> messages = [];
  List<MessageModel1> messages1 = [];
  final TextEditingController _controller = TextEditingController();

  String? userProfile;
  String? sourceId;

  @override
  void initState() {
    super.initState();
    connect();
    fetchMessages();
  }

  @override
  void dispose() {
    socket.disconnect();
    super.dispose();
  }

  Future<void> fetchMessages() async {
    final SelectChatModel chatUuser = widget.chatUser;
    bool userDataRetrieved = await getUserData();
    if (userDataRetrieved) {
      var userData = jsonDecode(userProfile!);
      sourceId = userData['email'];

      final source = sourceId;
      final targ = chatUuser.id;

      try {
        var response = await http.get(
          Uri.parse('$uri/usersMessages?senderId=$source&targetId=$targ'),
        );
        var response2 = await http.get(
            Uri.parse('$uri/usersMessage?senderId=$targ&targetId=$source'));

        if (response.statusCode == 200 && response2.statusCode == 200) {
          final List<dynamic> messagesData = jsonDecode(response.body);
          final List<dynamic> messagesData2 = jsonDecode(response2.body);

          List<MessageModel1> allMessages = [];

          allMessages.addAll(messagesData
              .map((messageJson) => MessageModel1.fromJson(messageJson)));

          allMessages.addAll(messagesData2
              .map((messageJson) => MessageModel1.fromJson(messageJson)));

          allMessages.sort((a, b) {
            if (a.timestamp != null && b.timestamp != null) {
              return a.timestamp!.compareTo(b.timestamp!);
            } else {
              return allMessages.indexOf(a).compareTo(allMessages.indexOf(b));
            }
          });
          setState(() {
            messages1 = allMessages;
          });
        } else {
          print('Failed to fetch messages');
        }
      } catch (e) {
        print('Error fetching messages: $e');
      }
    } else {}
  }

  Future<void> connect() async {
    bool userDataRetrieved = await getUserData();
    if (userDataRetrieved) {
      var userData = jsonDecode(userProfile!);
      sourceId = userData['email'];

      socket = IO.io("http://192.168.100.6:3000", <String, dynamic>{
        "transports": ["websocket"],
        "autoConnect": false,
      });
      socket.connect();
      socket.onConnect((data) {
        print("connected");
        socket.on("message", (msg) {
          print(msg);
          setMessage("destination", msg["message"]);
        });
      });

      socket.on("notification", (data) {
        print("Received notification:");
        Provider.of<UserProvider>(context, listen: false)
            .incrementNotifications();
      });

      socket.emit("signin", userData['email']);
    } else {}
  }

  void sendMessage(
      String message, String sourceId, String targetId, String name) {
    setMessage(sourceId, message);
    socket.emit("message", {
      "message": message,
      "sourceId": sourceId,
      "targetId": targetId,
      "name": name
    });
  }

  void setMessage(String type, String message) {
    if (type == 'destination') {
      MessageModel1 messageModel1 = MessageModel1(
          content: message, senderId: widget.chatUser.id, targetId: sourceId!);
      setState(() {
        messages1.add(messageModel1);
      });
    } else {
      MessageModel1 messageModel1 = MessageModel1(
          content: message, senderId: sourceId!, targetId: widget.chatUser.id);
      setState(() {
        messages1.add(messageModel1);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final SelectChatModel chatUser = widget.chatUser;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 187, 206, 197),
      appBar: AppBar(
        leadingWidth: 80,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child:
              const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(
              Icons.arrow_back,
              size: 27,
            ),
            CircleAvatar(
              radius: 21,
              backgroundColor: Colors.black,
            )
          ]),
        ),
        title: Column(
          children: [
            Text(chatUser.name,
                style: const TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                ))
          ],
        ),
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height - 140,
              child: ListView.builder(
                shrinkWrap: true,
                controller: scrollController,
                itemCount: messages1.length + 1,
                itemBuilder: (context, index) {
                  if (index == messages1.length) {
                    return Container(
                      height: 70,
                    );
                  }
                  if (messages1[index].senderId == sourceId) {
                    return SentMessageCard(
                      message: messages1[index].content,
                    );
                  } else {
                    return ReceivedMessageCard(
                      message: messages1[index].content,
                    );
                  }
                },
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Row(
                children: [
                  SizedBox(
                      width: MediaQuery.of(context).size.width - 55,
                      child: Card(
                          margin: const EdgeInsets.only(
                              left: 2, right: 2, bottom: 8),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25)),
                          child: TextFormField(
                            controller: _controller,
                            textAlignVertical: TextAlignVertical.center,
                            keyboardType: TextInputType.multiline,
                            maxLines: 6,
                            minLines: 1,
                            onChanged: (value) {
                              if (value.isNotEmpty) {
                                setState(() {
                                  sendButton = true;
                                });
                              } else {
                                setState(() {
                                  sendButton = false;
                                });
                              }
                            },
                            decoration: InputDecoration(
                                hintText: "Type the message",
                                prefixIcon: IconButton(
                                  icon: const Icon(
                                    Icons.emoji_emotions,
                                  ),
                                  onPressed: () {},
                                ),
                                suffixIcon: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.attach_file),
                                        onPressed: () {
                                          showModalBottomSheet(
                                              context: context,
                                              builder: (builder) =>
                                                  bottomSheet(context));
                                        },
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.camera_alt),
                                        onPressed: () {},
                                      )
                                    ]),
                                contentPadding: const EdgeInsets.all(5)),
                          ))),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0, right: 2),
                    child: CircleAvatar(
                        radius: 25,
                        child: IconButton(
                          icon: Icon(sendButton ? Icons.send : Icons.mic),
                          onPressed: () {
                            if (sendButton) {
                              scrollController.animateTo(
                                  scrollController.position.maxScrollExtent,
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeOut);
                              sendMessage(_controller.text, sourceId!,
                                  chatUser.id, chatUser.name);
                              _controller.clear();
                              setState(() {
                                sendButton = false;
                              });
                            }
                          },
                        )),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<bool> getUserData() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('x-auth-token');

      if (token == null) {
        prefs.setString('x-auth-token', 'no S');
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
        userProfile = jsonEncode(userData);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      showSnackBar(context, e.toString());
      return false;
    }
  }
}

Widget bottomSheet(BuildContext context) {
  return SizedBox(
    height: 270,
    width: MediaQuery.of(context).size.width,
    child: Card(
      margin: const EdgeInsets.all(18),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                creation(Icons.insert_drive_file, Colors.indigo, "Documents"),
                const SizedBox(width: 30),
                creation(Icons.insert_photo, Colors.indigo, "Gallery"),
                const SizedBox(width: 30),
                creation(Icons.camera, Colors.indigo, "Videos"),
              ],
            ),
            const SizedBox(width: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                creation(Icons.headset, Colors.indigo, "Audio"),
                const SizedBox(width: 30),
                creation(Icons.location_pin, Colors.pink, "Location"),
                const SizedBox(width: 30),
                creation(Icons.person, Colors.blue, "contact"),
              ],
            )
          ],
        ),
      ),
    ),
  );
}

Widget creation(IconData icon, Color color, String text) {
  return InkWell(
    onTap: () {},
    child: Column(
      children: [
        CircleAvatar(
            radius: 30, backgroundColor: color, child: Icon(icon, size: 29)),
        const SizedBox(
          height: 5,
        ),
        Text(text)
      ],
    ),
  );
}
