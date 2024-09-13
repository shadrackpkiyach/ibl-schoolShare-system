// ignore_for_file: sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:student/Admin/AdminServices/adding_admin_service.dart';
import 'package:student/customs_common/custom_button.dart';

class AdminAddScreen extends StatefulWidget {
  const AdminAddScreen({Key? key}) : super(key: key);

  @override
  State<AdminAddScreen> createState() => _AdminAddScreenState();
  //final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
}

class _AdminAddScreenState extends State<AdminAddScreen> {
  bool checkBoxValue = false;
  final _signUpKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final TextEditingController _phoneNumberController = TextEditingController();
  final AdminAuthService authService = AdminAuthService();
  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _phoneNumberController.dispose();
  }

  void signUpAdmin() {
    authService.signUpAdmin(
        context: context,
        email: _emailController.text,
        password: _passwordController.text,
        name: _nameController.text,
        phoneNumber: _phoneNumberController.text);
  }

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    final scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Form(
              key: _signUpKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      fillColor: Color.fromARGB(255, 7, 7, 7),
                      hintText: 'Name',
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      fillColor: Color.fromARGB(255, 7, 7, 7),
                      hintText: 'email address',
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: _phoneNumberController,
                    decoration: const InputDecoration(
                      fillColor: Color.fromARGB(255, 7, 7, 7),
                      hintText: 'Phone number',
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: _passwordController,
                    decoration: const InputDecoration(
                      fillColor: Color.fromARGB(255, 7, 7, 7),
                      hintText: 'password',
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                      child: Row(
                    children: [
                      Checkbox(
                        value: checkBoxValue,
                        onChanged: (bool? value) {
                          setState(() {
                            checkBoxValue = value!;
                          });
                        },
                      ),
                      const Text(
                        'Accept Terms and Conditions',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  )),
                  CustomButton(
                    onTap: () {
                      if (_signUpKey.currentState!.validate()) {
                        signUpAdmin();
                      }
                    },
                    text: 'Add Admin',
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
