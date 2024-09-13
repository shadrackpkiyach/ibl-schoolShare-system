import 'package:flutter/material.dart';

class AdminProfile extends StatefulWidget {
  static const String routeName = '/adminprofile';
  const AdminProfile({Key? key}) : super(key: key);

  @override
  State<AdminProfile> createState() => _AdminProfileState();
}

class _AdminProfileState extends State<AdminProfile> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('profile')),
    );
  }
}
