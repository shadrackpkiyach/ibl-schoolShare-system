import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:readmore/readmore.dart';

class ClassActivities extends StatefulWidget {
  static const String routeName = '/class_activities-screen';
  const ClassActivities({super.key});

  @override
  State<ClassActivities> createState() => _ClassActivitiesState();
}

TextEditingController titleController = TextEditingController();
TextEditingController workflowController = TextEditingController();

class _ClassActivitiesState extends State<ClassActivities> {
  Map<String, bool> cardExpandedMap = {};

  Future<void> deleteDocument(String documentId) async {
    await FirebaseFirestore.instance
        .collection('Activities')
        .doc(documentId)
        .delete();
  }

  bool shouldShowMore(String text, TextStyle style, int maxLines) {
    final span = TextSpan(text: text, style: style);
    final textPainter = TextPainter(
      text: span,
      textAlign: TextAlign.left,
      textDirection: TextDirection.ltr,
      maxLines: maxLines,
    );

    textPainter.layout(minWidth: 0, maxWidth: double.infinity);
    return textPainter.didExceedMaxLines;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(
                context); // This will pop the current screen and go back to the previous screen.
          },
        ),
        title: const Text('Activities given to the students'),
      ),
      floatingActionButton: SizedBox(
        width: 200,
        child: FloatingActionButton(
          onPressed: () {
            showUploadDialog(context);
          },
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
                Radius.circular(8.0)), // Set the desired radius
          ),
          child: const Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: Icon(Icons.add),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: EdgeInsets.only(bottom: 8.0),
                  child: Text('Add Activities'),
                ),
              ),
            ],
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('Activities').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
              String grade = data['grade'] ?? 'No Grade';

              String expandedText = data['information'] ?? 'No workflow';

              return Card(
                child: Column(
                  children: [
                    ListTile(
                      title: Text('$grade - $subject'),
                      subtitle: ReadMoreText(
                        expandedText,
                        trimLines: 3,
                        textAlign: TextAlign.justify,
                        trimMode: TrimMode.Line,
                        trimCollapsedText: " Show More ",
                        trimExpandedText: " Show Less ",
                        lessStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.green[700],
                        ),
                        moreStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.green[700],
                        ),
                        style: const TextStyle(
                          fontSize: 16,
                          height: 2,
                        ),
                      ),
                    )
                  ],
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}

void showUploadDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      String? subject;
      String? grade;

      String? pay;
      String? information;

      List<String> subjects = [
        'english',
        'kiswahili',
        'mathematics',
        'science',
        'arts and craft ',
        'home science'
      ];
      List<String> pays = ['yes', 'no'];

      List<String> grades = ['grades 1', 'grades 2', 'grades 3', 'grades 4'];

      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Submit the classes Workflow'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButton<String>(
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
                    hint: const Text('subjects activities '),
                  ),
                  DropdownButton<String>(
                    value: pay,
                    onChanged: (newValue) {
                      setState(() {
                        pay = newValue;
                      });
                    },
                    items: pays.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    hint: const Text('is there any payments '),
                  ),
                  DropdownButton<String>(
                    value: grade,
                    onChanged: (newValue) {
                      setState(() {
                        grade = newValue;
                      });
                    },
                    items: grades.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    hint: const Text('Select Grade'),
                  ),
                  SizedBox(
                    width: 300,
                    child: TextField(
                      controller: workflowController,
                      onChanged: (value) {
                        information = value;
                      },
                      decoration: const InputDecoration(
                        labelText: 'grade Activities',
                      ),
                      maxLines: null,
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text(
                  "close",
                ),
              ),
              TextButton(
                onPressed: () async {
                  // Perform the upload to Firestore using the provided data
                  // You can implement your logic here

                  // Upload the PDF file to Firestore using the `path` variable
                  // You can implement your upload logic here

                  if (subject == null ||
                      grade == null ||
                      pay == null ||
                      information == null) {
                    // Validate that all fields are filled
                    return;
                  }

                  // Initialize Firebase
                  await Firebase.initializeApp();

                  // Create a new document in Firestore collection
                  CollectionReference documentsCollection =
                      FirebaseFirestore.instance.collection('Activities');
                  DocumentReference newDocument = documentsCollection.doc();

                  // Upload the file to Firebase Storage (replace "fileName.pdf" with the desired file name)

                  // Create a new document with the provided data
                  await newDocument.set({
                    'subject': subject,
                    'pay': pay,
                    'grade': grade,
                    'information': information,
                  });
                  setState(() {
                    titleController.clear();
                    workflowController.clear();
                  });
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('File Upload'),
                        content: const Text(
                            'The file has been uploaded successfully.'),
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
                  //Navigator.of(context).pop();
                },
                child: const Text('save Activities'),
              ),
            ],
          );
        },
      );
    },
  );
}
