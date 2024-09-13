import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddSubject extends StatefulWidget {
  const AddSubject({Key? key}) : super(key: key);

  @override
  State<AddSubject> createState() => _AddSubjectState();
}

class _AddSubjectState extends State<AddSubject> {
  String? selectedGrade;
  String? grade;
  String? subject;
  String? topic;
  String? subtopic; // Variable to store the selected grade from the dropdown.

  // List of available grades for the dropdown. You can customize this as needed.
  List<String> grades = [
    'Grade 1',
    'Grade 2',
    'Grade 3',
    'Grade 5',
    'Grade 6',
    'Grade 7'
  ];

  List<String> subjects = ['Mathematics', 'English', 'Kiswahili', 'Science'];

  // Controllers for the text form fields.
  TextEditingController nameController = TextEditingController();
  TextEditingController assessmentController = TextEditingController();
  List<TextEditingController> subTopicControllers = [TextEditingController()];

  @override
  void dispose() {
    nameController.dispose();
    assessmentController.dispose();
    for (var controller in subTopicControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
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

            DropdownButtonFormField<String>(
              value: subject,
              onChanged: (newValue) {
                setState(() {
                  subject = newValue;
                });
              },
              items: subjects.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              hint: const Text('Select Subject'),
            ),
            // Student Name TextField
            TextFormField(
              onChanged: (value) {
                topic = value;
              },
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Topic'),
            ),
            const SizedBox(height: 16),

            // Assessment Number TextField
            ListView.builder(
              shrinkWrap: true,
              itemCount: subTopicControllers.length,
              itemBuilder: (context, index) {
                return TextFormField(
                  controller: subTopicControllers[index],
                  decoration:
                      InputDecoration(labelText: 'Sub-topic ${index + 1}'),
                );
              },
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  subTopicControllers.add(TextEditingController());
                });
              },
              child: const Text('Add Sub-topic'),
            ),
            const SizedBox(height: 36),

            ElevatedButton(
              onPressed: () {
                List<String> subtopic = subTopicControllers
                    .map((controller) => controller.text)
                    .where((subTopic) => subTopic.isNotEmpty)
                    .toList();

                if (grade!.isEmpty || subject!.isEmpty || topic == null) {
                  return;
                }

                Firebase.initializeApp();

                CollectionReference documentsCollection = FirebaseFirestore
                    .instance
                    .collection('${grade!}_${subject!}');
                DocumentReference newDocument = documentsCollection.doc();

                newDocument.set({
                  'grade': grade,
                  'subject': subject,
                  'topic': topic,
                  'subtopic': subtopic
                });
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('topic added'),
                      content:
                          const Text('The Topic has been added successfully.'),
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
              },
              child: const Text('Add Topic'),
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
