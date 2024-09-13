import 'package:flutter/material.dart';
import 'package:student/Admin/adminSections/header.dart';
import 'package:student/Admin/constants/color_constants.dart';

class AdminScreen extends StatefulWidget {
  static const String routeName = '/admin-screen';
  const AdminScreen({Key? key}) : super(key: key);

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Container(
          height: 12,
          width: 20,
          padding: const EdgeInsets.all(defaultPadding),
          child: const Column(children: [
            Header(),
          ])),
    ));
  }
}
