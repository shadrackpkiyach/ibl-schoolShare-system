import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddStudent extends StatefulWidget {
  const AddStudent({Key? key}) : super(key: key);

  @override
  State<AddStudent> createState() => _AddStudentState();
}

class _AddStudentState extends State<AddStudent> {
  String? selectedGrade;
  String? grade;
  String? name;
  String? assessNo; // Variable to store the selected grade from the dropdown.

  // List of available grades for the dropdown. You can customize this as needed.
  List<String> grades = [
    'Grade 1',
    'Grade 2',
    'Grade 3',
    'Grade 4',
    'Grade 5',
    'Grade 6',
    'Grade 7'
  ];

  // Controllers for the text form fields.
  TextEditingController nameController = TextEditingController();
  TextEditingController assessmentController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    assessmentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DropdownButtonFormField<String>(
              value: selectedGrade,
              onChanged: (value) {
                setState(() {
                  grade = value!;
                });
              },
              decoration: const InputDecoration(
                labelText: 'Grade',
                border: OutlineInputBorder(),
              ),
              items: grades.map((grade) {
                return DropdownMenuItem<String>(
                  value: grade,
                  child: Text(grade),
                );
              }).toList(),
            ),

            const SizedBox(height: 16),
            // Student Name TextField
            TextFormField(
              onChanged: (value) {
                name = value;
              },
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Student Name'),
            ),
            const SizedBox(height: 16),

            // Assessment Number TextField
            TextFormField(
              onChanged: (value) {
                assessNo = value;
              },
              controller: assessmentController,
              decoration: const InputDecoration(labelText: 'Assessment Number'),
            ),
            const SizedBox(height: 16),

            ElevatedButton(
              onPressed: () {
                // Perform the upload to Firestore using the provided data
                // You can implement your logic here

                // Upload the PDF file to Firestore using the `path` variable
                // You can implement your upload logic here

                if (grade!.isEmpty || name!.isEmpty || assessNo == null) {
                  // Validate that all fields are filled
                  return;
                }

                // Initialize Firebase
                Firebase.initializeApp();

                // Create a new document in Firestore collection
                CollectionReference documentsCollection =
                    FirebaseFirestore.instance.collection(grade!);
                DocumentReference newDocument = documentsCollection.doc();

                // Upload the file to Firebase Storage (replace "fileName.pdf" with the desired file name)

                // Create a new document with the provided data
                newDocument.set({
                  'grade': grade,
                  'name': name,
                  'assessNo': assessNo,
                });
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('student added'),
                      content: const Text(
                          'The student has been added successfully.'),
                      actions: <Widget>[
                        TextButton(
                          child: const Text('OK'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );

                // Close the dialog
              },
              child: const Text('Add Student'),
            ),
          ],
        ),
      ),
    );
  }

  void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 2),
    ));
  }
}
