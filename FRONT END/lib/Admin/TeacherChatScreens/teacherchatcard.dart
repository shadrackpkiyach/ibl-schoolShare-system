import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:student/Admin/TeacherChatScreens/dmteacherchatpage.dart';

import 'package:student/models/everchat.dart';
import 'package:student/models/selectChatModel.dart';

class TeacherChartCard extends StatelessWidget {
  const TeacherChartCard({Key? key, required this.chatEverModel})
      : super(key: key);
  final ChatEverModel chatEverModel;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => DmTeacherChatPage(
                    chatUser: SelectChatModel(
                        name: chatEverModel.name,
                        status: chatEverModel.name,
                        id: chatEverModel.senderId))));
      },
      child: Column(
        children: [
          ListTile(
            leading: CircleAvatar(
                radius: 32,
                child: SvgPicture.asset(
                  "person_2.svg",
                  color: Colors.white,
                  height: 37,
                  width: 37,
                )),
            title: Text(
              chatEverModel.name,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            subtitle: const Row(
              children: [
                Icon(Icons.done_all),
                SizedBox(
                  width: 3,
                ),
                //Text(
                // chatEverModel.currentMessage,
                // style: const TextStyle(
                // fontSize: 13,
                // ),
                // ),
              ],
            ),
            //trailing: Text(chatEverModel.time),
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
