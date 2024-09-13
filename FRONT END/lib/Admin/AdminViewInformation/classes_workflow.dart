import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class WorkflowScreen extends StatefulWidget {
  static const String routeName = '/workflow-screen';
  const WorkflowScreen({Key? key}) : super(key: key);

  @override
  State<WorkflowScreen> createState() => _WorkflowScreenState();
}

TextEditingController titleController = TextEditingController();
TextEditingController workflowController = TextEditingController();
TextEditingController dateController = TextEditingController();

class _WorkflowScreenState extends State<WorkflowScreen> {
  Map<String, bool> cardExpandedMap = {};

  Future<void> deleteDocument(String documentId) async {
    await FirebaseFirestore.instance
        .collection('workflow')
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
        // automaticallyImplyLeading: false,
        title: const Text('Work flows available for the parents'),
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
                  child: Text('Add workflow '),
                ),
              ),
            ],
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('workflow').snapshots(),
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

              String title = data['title'] ?? 'No Subject';
              String grade = data['grade'] ?? 'No Grade';
              String week = data['week'] ?? 'No week';
              String date = data['date'] ?? 'No date';

              String expandedText = data['workflow'] ?? 'No workflow';

              bool isExpanded = cardExpandedMap[document.id] ?? false;

              return Card(
                child: Column(
                  children: [
                    ListTile(
                      title: Text('$grade - $title-  $date'),
                      subtitle: Text(
                        week,
                        maxLines: isExpanded ? null : 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: DropdownButtonHideUnderline(
                        child: DropdownButton<bool>(
                          value: isExpanded,
                          icon: const Icon(Icons.expand_more),
                          onChanged: (bool? newValue) {
                            setState(() {
                              cardExpandedMap[document.id] = newValue!;
                            });
                          },
                          items: const [
                            DropdownMenuItem<bool>(
                              value: false,
                              child: Text('Less'),
                            ),
                            DropdownMenuItem<bool>(
                              value: true,
                              child: Text('More'),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (isExpanded)
                      LayoutBuilder(
                        builder:
                            (BuildContext context, BoxConstraints constraints) {
                          final shouldShowButton = shouldShowMore(expandedText,
                              Theme.of(context).textTheme.bodyMedium!, 3);

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(expandedText),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text('Delete Workflow'),
                                        content: const Text(
                                          'Are you sure you want to delete this workflow?',
                                        ),
                                        actions: <Widget>[
                                          TextButton(
                                            child: const Text('Cancel'),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                          TextButton(
                                            child: const Text('Delete'),
                                            onPressed: () {
                                              deleteDocument(document.id);
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                              ),
                              if (shouldShowButton)
                                TextButton(
                                  onPressed: () {
                                    setState(() {
                                      cardExpandedMap[document.id] = false;
                                    });
                                  },
                                  child: const Text('Show Less'),
                                ),
                            ],
                          );
                        },
                      ),
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
      String? grade;
      String title = '';
      String? week;
      String? workflow;
      String date = '';

      List<String> weeks = [
        'week 1',
        'week 2',
        'week 3',
        'week 5',
        'week 6',
        'week 7'
      ];
      List<String> grades = ['grades 1', 'grades 2', 'grades 3', 'grades 4'];

      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Submit the classes Workflow'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: titleController,
                    onChanged: (value) {
                      title = value;
                    },
                    decoration: const InputDecoration(
                      labelText: 'Title',
                    ),
                  ),
                  DropdownButton<String>(
                    value: week,
                    onChanged: (newValue) {
                      setState(() {
                        week = newValue;
                      });
                    },
                    items: weeks.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    hint: const Text('Select Week workflow'),
                  ),
                  TextField(
                    controller: dateController,
                    onChanged: (value) {
                      date = value;
                    },
                    decoration: const InputDecoration(
                      labelText: 'Date',
                    ),
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
                        workflow = value;
                      },
                      decoration: const InputDecoration(
                        labelText: 'grade workflow',
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

                  if (title.isEmpty ||
                      date.isEmpty ||
                      grade!.isEmpty ||
                      week == null ||
                      workflow == null) {
                    // Validate that all fields are filled
                    return;
                  }

                  // Initialize Firebase
                  await Firebase.initializeApp();

                  // Create a new document in Firestore collection
                  CollectionReference documentsCollection =
                      FirebaseFirestore.instance.collection('workflow');
                  DocumentReference newDocument = documentsCollection.doc();

                  // Upload the file to Firebase Storage (replace "fileName.pdf" with the desired file name)

                  // Create a new document with the provided data
                  await newDocument.set({
                    'title': title,
                    'date': date,
                    'week': week,
                    'grade': grade,
                    'workflow': workflow,
                  });
                  setState(() {
                    titleController.clear();
                    dateController.clear();
                    workflowController.clear();
                  });
                  // ignore: use_build_context_synchronously
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
                child: const Text('save workflow'),
              ),
            ],
          );
        },
      );
    },
  );
}
