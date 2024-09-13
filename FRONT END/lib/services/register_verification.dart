// ignore_for_file: use_build_context_synchronously
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:student/Admin/constants/error_handling.dart';
import 'package:student/Admin/constants/utils.dart';
import 'package:student/constants/global_variables.dart';
import 'package:student/screens/authentication_screen.dart';

class VerificationScreen extends StatefulWidget {
  final String email;
  const VerificationScreen(this.email, {super.key});

  @override
  _VerificationScreenState createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  final TextEditingController _verificationCodeController =
      TextEditingController();
  final TextEditingController _verificationEmailController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Verification"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(36.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _verificationEmailController,
              decoration: const InputDecoration(
                labelText: "Confirm the email",
                border: OutlineInputBorder(),
              ),
            ),
            TextField(
              controller: _verificationCodeController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Verification Code",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Call a function to post the verification code
                _postVerificationCode();
              },
              child: const Text("Submit"),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _postVerificationCode() async {
    // Get the verification code from the controller
    String verificationCode = _verificationCodeController.text.trim();
    String email = _verificationEmailController.text.trim();
    try {
      http.Response res = await http.post(
        Uri.parse(
            '$uri/api/verify'), // Replace with your server endpoint for verification
        body: jsonEncode({
          'email': email,
          'verificationCode': verificationCode,
        }),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const AuthenticationScreen()),
          );
          showSnackBar(context, 'Account verified successfully');
        },
      );
    } catch (e) {
      // Handle any API call error
      showSnackBar(context, 'Failed to verify. Please try again.');
    }
  }
}
