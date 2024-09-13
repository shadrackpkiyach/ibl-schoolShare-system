// ignore_for_file: invalid_use_of_protected_member, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:student/Admin/adminSections/header.dart';
import 'package:student/Admin/testsScreen/topics_assessment.dart';
import 'package:student/Admin/testsScreen/view_reports.dart';
import 'package:student/models/classesModel.dart';
import 'package:student/responsive.dart';

import 'package:student/constants/global_variables.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:student/constants/utils.dart';

class AssessmentScreen extends StatefulWidget {
  static const String routeName = '/assessment-screen';
  const AssessmentScreen({Key? key}) : super(key: key);

  @override
  State<AssessmentScreen> createState() => _AssessmentScreenState();
}

class _AssessmentScreenState extends State<AssessmentScreen> {
  String? userProfile;
  List<ClassModel> classList = [];

  @override
  void initState() {
    super.initState();
    getUserData(context).then((value) {
      getUserClasses(userProfile, this);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (userProfile == null) {
      return Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(8),
        child: const CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
        ),
      );
    }

    var userData = jsonDecode(userProfile!);

    return Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              if (!Responsive.isMobile(context))
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "This is Your Grade class drafts",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      "Welcome to your class management select the grade for assessment",
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
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Hello, ${userData['name']}👋",
                        style: const TextStyle(
                          fontSize: 35,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      onTap: () {
                        showSubjectDialog(context, userProfile);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: const Color(0xFF7165D6),
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 6,
                              spreadRadius: 4,
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.add,
                                color: Color(0xFF7165D6),
                                size: 35,
                              ),
                            ),
                            const SizedBox(height: 30),
                            const Text(
                              "Add Classes",
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 5),
                            const Text(
                              "Create more classes",
                              style: TextStyle(
                                color: Colors.white54,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        showReportDialog(context, userProfile, classList);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 6,
                              spreadRadius: 4,
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: const BoxDecoration(
                                color: Color(0xFFF0EEFA),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.home_filled,
                                color: Color(0xFF7165D6),
                                size: 35,
                              ),
                            ),
                            const SizedBox(height: 30),
                            const Text(
                              "Reports",
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 5),
                            const Text(
                              "View Reports",
                              style: TextStyle(
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 25),
                const Padding(
                  padding: EdgeInsets.only(left: 15),
                  child: Text(
                    "What is there about your classes?",
                    style: TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.w500,
                      color: Colors.black54,
                    ),
                  ),
                ),
                SizedBox(
                  height: 70,
                  child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: 1,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 10),
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF4F6FA),
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 4,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Text(
                            'hi you',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.black54,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 15),
                const Padding(
                  padding: EdgeInsets.only(left: 15),
                  child: Text(
                    "Your Classes",
                    style: TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.w500,
                      color: Colors.black54,
                    ),
                  ),
                ),
                GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: Responsive.isMobile(context) ? 2 : 4,
                    crossAxisSpacing: 40, // Adjust the spacing between columns
                    mainAxisSpacing: 70,
                  ),
                  padding: const EdgeInsets.all(26),
                  itemCount: classList.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    var classItem = classList[index];
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AssessmentSubject(
                              subjectName: classItem.subjectName,
                              className: classItem.className,
                            ),
                          ),
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.all(10),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 4,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            //CircleAvatar(
                            // radius: 35,
                            // backgroundImage:
                            //      AssetImage("images/${imgs[index]}"),
                            // ),
                            Text(
                              classItem.className,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: Colors.black54,
                              ),
                            ),
                            Text(
                              classItem.subjectName,
                              style: const TextStyle(
                                color: Colors.black45,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ));
  }

  Future<String?> getUserData(BuildContext context) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('x-auth-token');

      if (token == null) {
        prefs.setString('x-auth-token', ''); // empty string
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
        setState(() {
          userProfile = jsonEncode(userData);
        });

        //print(userProfile);
      }
    } catch (e) {
      showSnackBar(context, e.toString());
    }
    return null;
  }
}

void showSubjectDialog(BuildContext context, userProfile) {
  var userData = jsonDecode(userProfile!);
  showDialog(
    context: context,
    builder: (BuildContext context) {
      String email = userData['email'];
      String subjectName = '';
      String className = '';

      return AlertDialog(
        title: const Text('Enter Subject and Grade'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              onChanged: (value) {
                subjectName = value;
              },
              decoration: const InputDecoration(labelText: 'Subject'),
            ),
            TextField(
              onChanged: (value) {
                className = value;
              },
              decoration: const InputDecoration(labelText: 'Grade'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () async {
              Map<String, dynamic> requestData = {
                'email': email,
                'subjectName': subjectName,
                'className': className,
              };

              try {
                // Send the data to the API
                http.Response response = await http.post(
                  Uri.parse('$uri/api/addClass'),
                  body: jsonEncode(requestData),
                  headers: <String, String>{
                    'Content-Type': 'application/json; charset=UTF-8',
                  },
                );

                if (response.statusCode == 200) {
                  showSnackBar(
                    context,
                    ' class info created!',
                  );
                } else {
                  // Handle the error or unexpected response from the API
                }
              } catch (e) {
                // Handle any exceptions that occur during the API call
              }

              Navigator.pop(context); // Close the dialog
            },
            child: const Text('Save'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close the dialog
            },
            child: const Text('Cancel'),
          ),
        ],
      );
    },
  );
}

Future<void> getUserClasses(
    String? userProfile, _AssessmentScreenState state) async {
  var userData = jsonDecode(userProfile!);
  String email = userData['email'];

  try {
    var response = await http.get(
      Uri.parse('$uri/getClasses?email=$email'),
    );

    if (response.statusCode == 200) {
      var classesData = jsonDecode(response.body);

      state.setState(() {
        state.classList = List<ClassModel>.from(classesData.map(
          (classAS) => ClassModel(
            subjectName: classAS['subjectName'],
            email: classAS['email'],
            className: classAS['className'],
          ),
        ));
      });
    } else {}
  } catch (error) {}
}

void showReportDialog(BuildContext context, userProfile, classList) {
  // Assuming classList is a list of items with properties className and subjectName

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('List of classes'),
        content: Container(
          width: double.maxFinite,
          height: 400, // Set the desired height
          child: ListView.builder(
            padding: const EdgeInsets.all(26),
            itemCount: classList.length,
            itemBuilder: (context, index) {
              var classItem = classList[index];
              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ReportAssessment(
                        subjectName: classItem.subjectName,
                        className: classItem.className,
                      ),
                    ),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.all(10),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 4,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        classItem.className,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.black54,
                        ),
                      ),
                      Text(
                        classItem.subjectName,
                        style: const TextStyle(
                          color: Colors.black45,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Close'),
          ),
        ],
      );
    },
  );
}
