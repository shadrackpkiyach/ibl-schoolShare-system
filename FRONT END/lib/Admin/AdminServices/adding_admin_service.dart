// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:student/constants/error_handling.dart';
import 'package:student/constants/global_variables.dart';

import 'package:student/constants/utils.dart';

import 'package:student/models/user.dart';

class AdminAuthService {
  // sign up admin
  void signUpAdmin(
      {required BuildContext context,
      required String email,
      required String password,
      required String name,
      required String phoneNumber}) async {
    try {
      User user = User(
        id: '',
        name: name,
        password: password,
        email: email,
        phoneNumber: phoneNumber,
        address: '',
        type: '',
        token: '',
      );

      http.Response res = await http.post(
        Uri.parse('$uri/api/addAdmin'),
        body: user.toJson(),
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
            ' Account created!',
          );
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }
}
