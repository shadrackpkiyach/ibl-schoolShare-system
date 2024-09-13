// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:student/constants/error_handling.dart';
import 'package:student/constants/global_variables.dart';

import 'package:student/constants/utils.dart';
import 'package:student/models/emails.dart';

class AdminMessageService {
  // sign up admin
  void sendMessage({
    required BuildContext context,
    required String text,
    required String subject,
    required List<emailModel> emails,
  }) async {
    try {
      final data = {
        'text': text,
        'subject': subject,
        'recipients': emails.map((email) => email.emails).toList(),
      };
      print(data);
      final jData = json.encode(data);
      print(jData);
      http.Response res = await http.post(
        Uri.parse('$uri/sendMail'),
        body: jData, // Convert the data to JSON format
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          showSnackBar(
            context,
            ' Emails sent!',
          );
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }
}
