import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:student/models/ChatModel.dart';
import 'package:student/models/selectChatModel.dart';
import 'package:student/screens/home/CustomUI/dmchatpage.dart';

class ChartCard extends StatelessWidget {
  const ChartCard({Key? key, required this.chatModel}) : super(key: key);
  final ChatModel chatModel;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => DmChatPage(
                    chatUser: SelectChatModel(
                        name: chatModel.name,
                        status: chatModel.name,
                        id: chatModel.id))));
      },
      child: Column(
        children: [
          ListTile(
            leading: CircleAvatar(
                radius: 32,
                child: SvgPicture.asset(
                  chatModel.isGroup ? "groups.svg" : "person_2.svg",
                  color: Colors.white,
                  height: 37,
                  width: 37,
                )),
            title: Text(
              chatModel.name,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            subtitle: Row(
              children: [
                const Icon(Icons.done_all),
                const SizedBox(
                  width: 3,
                ),
                Text(
                  chatModel.currentMessage,
                  style: const TextStyle(
                    fontSize: 13,
                  ),
                ),
              ],
            ),
            trailing: Text(chatModel.time),
          ),
          const Padding(
            padding: EdgeInsets.only(right: 20, left: 80),
            child: Divider(
              thickness: 1.5,
            ),
          )
        ],
      ),
    );
  }
}
