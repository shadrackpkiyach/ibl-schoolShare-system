import 'package:flutter/material.dart';
import 'package:student/Admin/adminSections/header.dart';
import 'package:student/Admin/constants/color_constants.dart';
import 'package:student/Admin/constants/navigation/side_menu.dart';
import 'package:student/Admin/testsScreen/assessment.dart';
import 'package:student/Admin/testsScreen/class_activities.dart';
import 'package:student/Admin/testsScreen/class_tasks.dart';

import 'package:student/responsive.dart';

class DashboardPage extends StatefulWidget {
  static const String routeName = '/dashboard';
  const DashboardPage({Key? key}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final ScrollController _assessmentScrollController = ScrollController();
  final ScrollController _headingScrollController = ScrollController();
  @override
  void dispose() {
    _assessmentScrollController.dispose();
    _headingScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: AppBar(
            title: Row(
              children: [
                if (!Responsive.isMobile(context))
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hello',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Text(
                        "Welcome to your class management",
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    ],
                  ),
                if (!Responsive.isMobile(context))
                  Spacer(flex: Responsive.isDesktop(context) ? 2 : 1),
                const Expanded(child: SearchField()),
                const SizedBox(
                  width: 30,
                ),
                const ProfileCard()
              ],
            ),
          ),
        ),
        drawer: const SideMenu(),
        body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
                height: MediaQuery.of(context).size.height *
                    1, // 40% of the screen height
                width: MediaQuery.of(context).size.width * 1,
                child: SingleChildScrollView(
                  controller: _assessmentScrollController,
                  padding: const EdgeInsets.all(defaultPadding),
                  child: Column(
                    children: [
                      Column(children: [
                        Card(
                          color: const Color.fromARGB(255, 129, 233, 236),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      'Hello',
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 26),
                                    const Text.rich(
                                      TextSpan(
                                        text: 'Welcome to the ElimuApp.\n',
                                        children: [
                                          TextSpan(
                                              text:
                                                  'This is your Grading dashboard.\n'),
                                          TextSpan(
                                              text:
                                                  'You can find your recent activity here as well \n as the learning hub which will get you up to speed on how to use the app.\n'),
                                          TextSpan(
                                              text:
                                                  'If you have any questions, don\'t hesitate to get in touch.'),
                                        ],
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                    const SizedBox(height: 32),
                                    SizedBox(
                                        width: 400.0,
                                        height: 40.0,
                                        child: ElevatedButton(
                                          onPressed: () {
                                            Navigator.pushNamed(context,
                                                AssessmentScreen.routeName);
                                            // Handle button click
                                          },
                                          child: const Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text('Perform Assessment'),
                                              Icon(Icons.arrow_forward),
                                            ],
                                          ),
                                        )),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ]),
                      Column(children: [
                        const Text(
                          '',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Card(
                          color: const Color.fromARGB(255, 129, 233, 236),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      'Hello',
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 26),
                                    const Text.rich(
                                      TextSpan(
                                        text: 'Welcome to the ElimuApp.\n',
                                        children: [
                                          TextSpan(
                                              text:
                                                  'This is your Grading dashboard.\n'),
                                          TextSpan(
                                              text:
                                                  'You can find your recent activity here as well as the learning hub which will get you up to speed on how to use the app.\n'),
                                          TextSpan(
                                              text:
                                                  'If you have any questions, don\'t hesitate to get in touch.'),
                                        ],
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                    const SizedBox(height: 32),
                                    SizedBox(
                                        width: 400.0,
                                        height: 40.0,
                                        child: ElevatedButton(
                                          onPressed: () {
                                            Navigator.pushNamed(context,
                                                ClassAssigns.routeName);
                                            // Handle button click
                                          },
                                          child: const Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text('Give classes Tasks'),
                                              Icon(Icons.arrow_forward),
                                            ],
                                          ),
                                        )),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ]),
                      Column(children: [
                        const Text(
                          '',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Card(
                          color: const Color.fromARGB(255, 129, 233, 236),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      'Hello',
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 26),
                                    const Text.rich(
                                      TextSpan(
                                        text: 'Welcome to the ElimuApp.\n',
                                        children: [
                                          TextSpan(
                                              text:
                                                  'This is your Grading dashboard.\n'),
                                          TextSpan(
                                              text:
                                                  'You can find your recent activity here as well as the learning hub which will get you up to speed on how to use the app.\n'),
                                          TextSpan(
                                              text:
                                                  'If you have any questions, don\'t hesitate to get in touch.'),
                                        ],
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                    const SizedBox(height: 32),
                                    SizedBox(
                                        width: 400.0,
                                        height: 40.0,
                                        child: ElevatedButton(
                                          onPressed: () {
                                            Navigator.pushNamed(context,
                                                ClassActivities.routeName);
                                            // Handle button click
                                          },
                                          child: const Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text('Manage class Activities'),
                                              Icon(Icons.arrow_forward),
                                            ],
                                          ),
                                        )),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ]),
                    ],
                  ),
                ))));
  }
}
