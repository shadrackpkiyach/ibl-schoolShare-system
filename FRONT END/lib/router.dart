import 'package:flutter/material.dart';
import 'package:student/Admin/AdminServices/message_parents.dart';
import 'package:student/Admin/AdminViewInformation/activities_shown.dart';
import 'package:student/Admin/AdminViewInformation/classes_workflow.dart';
import 'package:student/Admin/TeacherChatScreens/teacher_chat_page.dart';
import 'package:student/Admin/TeacherTasks/classtypes.dart';
import 'package:student/Admin/adminprofile.dart';
import 'package:student/Admin/adminscreen.dart';
import 'package:student/Admin/classStudents/student_names.dart';
import 'package:student/Admin/constants/navigation/side_menu.dart';
import 'package:student/Admin/dashboard.dart';
import 'package:student/Admin/resources/resourcesadmin.dart';
import 'package:student/Admin/schoolInformation/admin_information.dart';
import 'package:student/Admin/testsScreen/assessment.dart';
import 'package:student/Admin/testsScreen/class_activities.dart';
import 'package:student/Admin/testsScreen/class_tasks.dart';

import 'package:student/constants/navigation/bottomnav_bar.dart';
import 'package:student/screens/authentication_screen.dart';
import 'package:student/screens/home/home_screen.dart';

Route<dynamic> generateRoute(RouteSettings routeSettings) {
  switch (routeSettings.name) {
    case AuthenticationScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const AuthenticationScreen(),
      );

    case HomePage.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const HomePage(),
      );

    case BottomNavBar.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const BottomNavBar(),
      );
    case DashboardPage.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const DashboardPage(),
      );

    case SideMenu.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const SideMenu(),
      );
    case AdminProfile.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const AdminProfile(),
      );

    case AdminScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const AdminScreen(),
      );
    case TeacherChatPage.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const TeacherChatPage(),
      );
    case AssessmentScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const AssessmentScreen(),
      );
    case ClassAccess.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const ClassAccess(),
      );
    case ResourcesAdminPage.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const ResourcesAdminPage(),
      );
    case WorkflowScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const WorkflowScreen(),
      );

    case ClassAssigns.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const ClassAssigns(),
      );

    case ClassActivities.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const ClassActivities(),
      );
    case ClassShownActivities.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const ClassShownActivities(),
      );

    case AdminData.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const AdminData(),
      );
    case StudentData.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const StudentData(),
      );
    case AdminMessage.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const AdminMessage(),
      );

    default:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const Scaffold(
          body: Center(
            child: Text('Screen does not exist!'),
          ),
        ),
      );
  }
}
