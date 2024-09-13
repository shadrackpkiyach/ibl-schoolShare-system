import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:student/constants/global_variables.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class QuizUserCardListView extends StatefulWidget {
  const QuizUserCardListView({Key? key}) : super(key: key);

  @override
  State<QuizUserCardListView> createState() => _QuizUserCardListViewState();
}

class _QuizUserCardListViewState extends State<QuizUserCardListView> {
  late Future<String> _userProfile;

  @override
  void initState() {
    super.initState();
    _userProfile = getUserData();
  }

  Future<String> getUserData() async {
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

        return jsonEncode(userData);
      } else {
        return ''; // Return empty string if response is false
      }
    } catch (e) {
      return ''; // Return empty string in case of error
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: _userProfile,
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(
            width: 20.0,
            height: 20.0,
            child: CircularProgressIndicator(
              strokeWidth: 2.0,
            ),
          );
        }

        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        String userProfile =
            snapshot.data ?? ''; // Assign empty string as default
        Map<String, dynamic> userProfileData = jsonDecode(userProfile);

        // Extract email and name from userProfileData
        String email = userProfileData['email'] ?? '';
        String name = userProfileData['name'] ?? '';

        // Use email and name to query Firestore
        return StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('documents')
              .where('uploaderId', isEqualTo: '$name-contact on-$email')
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const SizedBox(
                width: 20.0,
                height: 20.0,
                child: CircularProgressIndicator(
                  strokeWidth: 2.0,
                ),
              );
            }

            return ListView(
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> data =
                    document.data() as Map<String, dynamic>;

                String subject = data['subject'] ?? 'No Subject';
                String grade = data['grade'] ?? 'No grade';
                String title = data['title'] ?? 'No title';

                String uploaderId = data['uploaderId'] ?? 'unknown';

                return Card(
                  child: ListTile(
                    title: Text('$subject - $grade'),
                    subtitle: Text('$title--$uploaderId'),
                    trailing: TextButton(
                      onPressed: () {
                        _showDeleteConfirmationDialog(context, document.id);
                      },
                      child: const Text(
                          'Delete'), // Change button text to 'Delete'
                    ),
                  ),
                );
              }).toList(),
            );
          },
        );
      },
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, String documentId) {
    // Show confirmation dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Deletion'),
          content: Text('Are you sure you want to delete this document?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _deleteDocument(documentId); // Call delete function
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void _deleteDocument(String documentId) {
    // Delete document from Firestore
    FirebaseFirestore.instance.collection('notes').doc(documentId).delete();
  }
}
