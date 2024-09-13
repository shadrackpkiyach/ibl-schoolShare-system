import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:student/Admin/AdminServices/message_parents.dart';
import 'package:student/Admin/AdminViewInformation/activities_shown.dart';
import 'package:student/Admin/AdminViewInformation/classes_workflow.dart';

import 'package:student/Admin/TeacherChatScreens/teacher_chat_page.dart';
import 'package:student/Admin/classStudents/student_names.dart';

import 'package:student/Admin/constants/color_constants.dart';
import 'package:student/Admin/dashboard.dart';
import 'package:student/Admin/resources/resourcesadmin.dart';
import 'package:student/Admin/schoolInformation/admin_information.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({
    Key? key,
  }) : super(key: key);
  static const String routeName = '/menu-home';
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pop();
      },
      child: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: defaultPadding * 3,
                ),
                Image.asset(
                  "logo/logo_icon.png",
                  scale: 5,
                ),
                const SizedBox(
                  height: defaultPadding,
                ),
                const Text("my child ")
              ],
            )),
            ListTile(
              title: const Text(
                "Dashboard",
                style: TextStyle(color: Color.fromARGB(255, 9, 8, 8)),
              ),
              leading: SvgPicture.asset("icons/menu_dashbord.svg"),
              onTap: () {
                Navigator.pushNamed(context, DashboardPage.routeName);
                // Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text("Daily workflow"),
              leading: SvgPicture.asset("icons/menu_tran.svg"),
              onTap: () {
                Navigator.pushNamed(context, WorkflowScreen.routeName);
                // Navigator.pushNamed(context, AddPostData.routeName);
                //Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text("Class events"),
              leading: SvgPicture.asset("icons/menu_task.svg"),
              onTap: () {},
            ),
            ListTile(
              title: const Text("Messages"),
              leading: SvgPicture.asset("icons/menu_task.svg"),
              onTap: () {
                Navigator.pushNamed(context, TeacherChatPage.routeName);
                //Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text("Activities"),
              leading: SvgPicture.asset("icons/menu_task.svg"),
              onTap: () {
                Navigator.pushNamed(context, ClassShownActivities.routeName);
              },
            ),
            ListTile(
              title: const Text("Resources "),
              leading: SvgPicture.asset("icons/menu_doc.svg"),
              onTap: () {
                Navigator.pushNamed(context, ResourcesAdminPage.routeName);
                //Navigator.of(context).pop();
              },
            ),
            ListTile(
              title: const Text("class lists"),
              leading: SvgPicture.asset("icons/menu_store.svg"),
              onTap: () {
                Navigator.pushNamed(context, StudentData.routeName);
              },
            ),
            ListTile(
              title: const Text("Send Admin message"),
              leading: SvgPicture.asset("icons/menu_store.svg"),
              onTap: () {
                Navigator.pushNamed(context, AdminMessage.routeName);
              },
            ),
            ListTile(
              title: const Text("Admin Information"),
              leading: SvgPicture.asset("icons/menu_notification.svg"),
              onTap: () {
                Navigator.pushNamed(context, AdminData.routeName);
              },
            ),
            ListTile(
              title: const Text("Parents"),
              leading: SvgPicture.asset("icons/menu_profile.svg"),
              onTap: () {},
            ),
            ListTile(
              title: const Text("Settings"),
              leading: SvgPicture.asset("icons/menu_setting.svg"),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
/*
class DrawerListTile extends StatelessWidget {
  const DrawerListTile({
    Key? key,
    // For selecting those three line once press "Command+D"
    required this.title,
    required this.svgSrc,
    required this.press,
  }) : super(key: key);

  final String title, svgSrc;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: press,
      horizontalTitleGap: 0.0,
      leading: SvgPicture.asset(
        svgSrc,
        color: Colors.white54,
        height: 16,
      ),
      title: Text(
        title,
        style: const TextStyle(color: Colors.white54),
      ),
    );
  }
}*/
