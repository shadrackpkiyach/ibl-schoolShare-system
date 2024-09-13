import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:student/providers/user_provider.dart';
import 'package:student/screens/AdminsInfor/information/messages_received.dart';
import 'package:student/screens/GradeActivities/grade_activities.dart';
import 'package:student/screens/documents/documents.dart';
import 'package:student/screens/home/activities.dart';
import 'package:student/screens/home/assignments.dart';
import 'package:student/screens/home/homepage/activities_done.dart';
import 'package:student/screens/home/homepage/parent_view.dart';

import 'package:student/screens/home/resources.dart';

import 'package:student/screens/links/links.dart';
import 'package:student/screens/notes/notes.dart';
import 'package:student/screens/notes/novels.dart';

enum PopUpMenuItem { home, settings }

class HomePage extends StatefulWidget {
  static const String routeName = '/home';

  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    userProvider.unreadNotifications; // Accessing property to trigger its usage

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Schoolshare',
          style: TextStyle(
            fontSize: 22,
            color: Colors.black,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              userProvider.resetNotifications();
            },
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Implement search functionality
            },
          ),
        ],
      ),
      body: Row(
        children: [
          SizedBox(
            width: 200,
            child: Drawer(
              child: SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      ExpansionTile(
                        title: const Text('School work'),
                        leading: const Icon(Icons.work),
                        childrenPadding: const EdgeInsets.only(left: 60),
                        initiallyExpanded: _selectedIndex == 0,
                        onExpansionChanged: (bool expanded) {
                          if (expanded) {
                            setState(() {
                              _selectedIndex = 0;
                            });
                          }
                        },
                        children: [
                          ListTile(
                            title: const Text('Diaries'),
                            onTap: () {
                              _navigatorKey.currentState!.pushReplacement(
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const WorkflowTeacherScreen()));
                              _scaffoldKey.currentState!.openEndDrawer();
                            },
                          ),
                          ListTile(
                            title: const Text('Assignments'),
                            onTap: () {
                              _navigatorKey.currentState!.pushReplacement(
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const AssignmentsScreen()));
                              _scaffoldKey.currentState!.openEndDrawer();
                            },
                          ),
                          ListTile(
                            title: const Text('Assessment'),
                            onTap: () {
                              _navigatorKey.currentState!.pushReplacement(
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const ClassTShownActivities()));
                              _scaffoldKey.currentState!.openEndDrawer();
                            },
                          ),
                          ListTile(
                            title: const Text('Activities'),
                            onTap: () {
                              _navigatorKey.currentState!.pushReplacement(
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const ActivitiesListView()));
                              _scaffoldKey.currentState!.openEndDrawer();
                            },
                          )
                        ],
                      ),
                      ExpansionTile(
                        title: const Text('Resource'),
                        leading: const Icon(Icons.work),
                        childrenPadding: const EdgeInsets.only(left: 60),
                        initiallyExpanded: _selectedIndex == 1,
                        onExpansionChanged: (bool expanded) {
                          if (expanded) {
                            setState(() {
                              _selectedIndex = 1;
                            });
                          }
                        },
                        children: [
                          ListTile(
                            title: const Text('Your shared Resources'),
                            onTap: () {
                              _navigatorKey.currentState!.pushReplacement(
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const ResourcesPage()));
                              _scaffoldKey.currentState!.openEndDrawer();
                            },
                          ),
                          ListTile(
                            title: const Text('Notes'),
                            onTap: () {
                              _navigatorKey.currentState!.pushReplacement(
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const NotesCardListView()));
                              _scaffoldKey.currentState!.openEndDrawer();
                            },
                          ),
                          ListTile(
                            title: const Text('Q/A papers'),
                            onTap: () {
                              _navigatorKey.currentState!.pushReplacement(
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const DocumentCardListView()));
                              _scaffoldKey.currentState!.openEndDrawer();
                            },
                          ),
                          ListTile(
                            title: const Text('Media Links'),
                            onTap: () {
                              _navigatorKey.currentState!.pushReplacement(
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const LinksCardListView()));
                              _scaffoldKey.currentState!.openEndDrawer();
                            },
                          ),
                          ListTile(
                            title: const Text('Novels'),
                            onTap: () {
                              _navigatorKey.currentState!.pushReplacement(
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const NovelsCardListView()));
                              _scaffoldKey.currentState!.openEndDrawer();
                            },
                          ),
                          ListTile(
                            title: const Text('to do activities'),
                            onTap: () {
                              _navigatorKey.currentState!.pushReplacement(
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const ActivitiesCardListView()));
                              _scaffoldKey.currentState!.openEndDrawer();
                            },
                          ),
                        ],
                      ),
                      ListTile(
                        leading: const Icon(Icons.info),
                        title: const Text('Admin info'),
                        onTap: () {
                          setState(() {
                            _selectedIndex = 2;
                          });
                          _navigatorKey.currentState!.pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const AdminSentMessage()));
                          _scaffoldKey.currentState!.openEndDrawer();
                        },
                        selected: _selectedIndex == 2,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const VerticalDivider(), // Divider between drawer and content
          Expanded(
            child: Navigator(
              key: _navigatorKey,
              initialRoute: '/',
              onGenerateRoute: (settings) {
                switch (settings.name) {
                  case '/':
                    return MaterialPageRoute(
                        builder: (_) => const WorkflowTeacherScreen());
                  case '/resources':
                    return MaterialPageRoute(
                        builder: (_) => const ResourcesPage());
                  case '/adminInfo':
                    return MaterialPageRoute(
                        builder: (_) => const AdminSentMessage());
                  default:
                    return MaterialPageRoute(
                        builder: (_) => Scaffold(
                            body: Center(
                                child: Text(
                                    'No route defined for ${settings.name}'))));
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
