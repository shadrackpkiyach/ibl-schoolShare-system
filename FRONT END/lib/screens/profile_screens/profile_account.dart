import 'package:flutter/material.dart';

import 'package:student/constants/global_variables.dart';

import 'package:student/screens/profile_screens/profile_menu.dart';
import 'package:student/services/authentication_services.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final AuthenticationService authenticationService = AuthenticationService();

  String? userProfile;

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: AppBar(
          leading: const Icon(
            Icons.arrow_back,
          ),
          flexibleSpace: Container(
            decoration:
                const BoxDecoration(gradient: GlobalVariables.appBarGradient),
          ),
          title:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            RichText(
              text: const TextSpan(
                  text: 'account',
                  style: TextStyle(
                    fontSize: 22,
                    color: Colors.black,
                  )),
            ),
            Container(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Padding(
                    padding: EdgeInsets.only(right: 15),
                    child: Icon(Icons.notifications_outlined),
                  ),
                  Icon(Icons.search)
                ],
              ),
            )
          ]),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          Align(
            alignment: Alignment.center,
            child: SizedBox(
              height: 115,
              width: 115,
              child: Stack(
                fit: StackFit.expand,
                clipBehavior: Clip.none,
                children: [
                  const CircleAvatar(),
                  Positioned(
                    right: -16,
                    bottom: 0,
                    child: SizedBox(
                      height: 48,
                      width: 48,
                      child: TextButton(
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                            side: const BorderSide(color: Colors.white),
                          ),
                          backgroundColor: const Color(0xFFF5F6F9),
                        ),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('profile Image'),
                                content: const Text(
                                    'Adding profile image is under development'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('Ok'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: const Row(children: [
                          Icon(
                            Icons.add,
                            color: Colors.blue,
                          ),
                        ]),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          ProfileMenu(
            text: "My Account",
            icon: "",
            press: () => {
              showModalBottomSheet(
                  context: context,
                  builder: (builder) =>
                      bottomAccountSheet(context, userProfile))
            },
          ),
          ProfileMenu(
            text: "Notifications",
            icon: "",
            press: () {
              showNotificationMenu(context);
            },
          ),
          ProfileMenu(
            text: "Settings",
            icon: "",
            press: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Settings'),
                    content: const Text('The feature is under development'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Ok'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
          ProfileMenu(
            text: "Help Center",
            icon: " ",
            press: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Help Center'),
                    content: const Text('The feature is under development'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Ok'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
          ProfileMenu(
            text: "Log Out",
            icon: " ",
            press: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('LOG OUT'),
                    content: const Text('Do you want to Log Out'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('No'),
                      ),
                      TextButton(
                        onPressed: () {
                          AuthenticationService()
                              .logoutUser(context); // Call logout method
                          Navigator.of(context).pop();
                        },
                        child: const Text('Yes'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ]),
      ),
    );
  }

  Future<void> getUserData() async {
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

        userProfile = jsonEncode(userData);
      }
    } catch (e) {
      //showSnackBar(context, e.toString());
    }
  }

  void showNotificationMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Wrap(
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.notifications_active),
              title: const Text('Enable Notifications'),
              onTap: () {
                // Handle enabling notifications
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.notifications_off),
              title: const Text('Disable Notifications'),
              onTap: () {
                // Handle disabling notifications
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}

Widget bottomAccountSheet(BuildContext context, userProfile) {
  var userData = jsonDecode(userProfile!);
  return SizedBox(
    height: 500,
    width: MediaQuery.of(context).size.width,
    child: Card(
      margin: const EdgeInsets.all(18),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Name',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            Text(
              userData['name'],
              style: const TextStyle(fontSize: 16.0),
            ),
            const SizedBox(height: 16.0),
            const Text(
              'Child Name',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            const Text(
              "*****",
              //userData['email'],
              style: TextStyle(fontSize: 16.0),
            ),
            const SizedBox(height: 16.0),
            const Text(
              'Email',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            Text(
              userData['email'],
              style: const TextStyle(fontSize: 16.0),
            ),
            const SizedBox(height: 16.0),
            const Text(
              'Password',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            const Text(
              "*****",
              style: TextStyle(fontSize: 16.0),
            ),
          ],
        ),
      ),
    ),
  );
}
