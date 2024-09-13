// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

enum BodyType {
  DataTableBody,
  TextBody,
}

class AccessingStudent extends StatefulWidget {
  final String subjectName;
  final String className;

  const AccessingStudent({
    Key? key,
    required this.subjectName,
    required this.className,
  }) : super(key: key);

  @override
  State<AccessingStudent> createState() => _AccessingStudentState();
}

class _AccessingStudentState extends State<AccessingStudent> {
  String collectionName = '';
  List<String> students = [
    'Student 1',
    'Student 2',
    'Student 3',
    'Student 4',
  ];

  List<String> coreOptions = [
    'EE (80 – 100%)',
    ' ME (65 - 79%)',
    ' AE(50 - 64%)',
    'BE (0 – 49%)',
  ];

  List<String> additionalScoreOptions = [];

  Map<String, String> studentScores = {};
  BodyType currentBody = BodyType.DataTableBody;

  @override
  void initState() {
    super.initState();

    fetchStudents();
  }

  void fetchStudents() async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      CollectionReference studentsCollection =
          firestore.collection(widget.className);

      QuerySnapshot studentsSnapshot = await studentsCollection.get();

      studentsSnapshot.docs.forEach((studentDoc) {
        String student = studentDoc.get('name');

        students.add(student);
      });

      setState(() {});
    } catch (e) {
      print('Error fetching topics and subtopics: $e');
    }
  } // Default body type

  @override
  Widget build(BuildContext context) {
    List<String> scoreOptions = currentBody == BodyType.DataTableBody
        ? coreOptions
        : additionalScoreOptions;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Score Table'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            currentBody == BodyType.DataTableBody
                ? SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columnSpacing: 20,
                      columns: [
                        const DataColumn(
                          label: Text('Student Name'),
                        ),
                        ...scoreOptions.map((scoreOption) => DataColumn(
                              label: Text(scoreOption),
                            )),
                      ],
                      rows: List.generate(
                        students.length,
                        (index) => DataRow(
                          cells: [
                            DataCell(
                              Text(students[index]),
                            ),
                            ...scoreOptions.map((scoreOption) => DataCell(
                                  Radio(
                                    value: scoreOption,
                                    groupValue: studentScores[students[index]],
                                    onChanged: (value) {
                                      setState(() {
                                        studentScores[students[index]] =
                                            value.toString();
                                      });
                                    },
                                  ),
                                )),
                          ],
                        ),
                      ),
                    ),
                  )
                : SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columnSpacing: 20,
                      columns: [
                        const DataColumn(
                          label: Text('Student Name'),
                        ),
                        ...scoreOptions.map((scoreOption) => DataColumn(
                              label: Text(scoreOption),
                            )),
                      ],
                      rows: List.generate(
                        students.length,
                        (index) => DataRow(
                          cells: [
                            DataCell(
                              Text(students[index]),
                            ),
                            ...scoreOptions.map((scoreOption) {
                              final studentName = students[index];
                              final TextEditingController controller =
                                  TextEditingController(
                                text: studentScores[studentName],
                              );

                              return DataCell(
                                TextFormField(
                                  controller: controller,
                                  onChanged: (newValue) {
                                    studentScores[studentName] = newValue;
                                  },
                                  decoration: const InputDecoration(
                                    isDense: true,
                                    contentPadding: EdgeInsets.symmetric(
                                      vertical: 8.0,
                                      horizontal: 12.0,
                                    ),
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(),
                                    ),
                                  ),
                                  keyboardType: TextInputType.number,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                  ),
                                ),
                              );
                            }),
                          ],
                        ),
                      ),
                    ),
                  ),
            const SizedBox(
              width: 12,
            ),
            if (currentBody ==
                BodyType.TextBody) // Show the button only for the second body
              ElevatedButton(
                onPressed: () {
                  // Show a dialog to add a new score option.
                  showDialog(
                    context: context,
                    builder: (context) => const AddScoreOptionDialog(),
                  ).then((newOption) {
                    if (newOption != null && newOption.isNotEmpty) {
                      setState(() {
                        additionalScoreOptions.add(newOption);
                      });
                    }
                  });
                },
                child: const Text('Add Score Option'),
              ),
            const SizedBox(
              width: 12,
            ),
            ElevatedButton(
              onPressed: () {
                _showCollectionNameDialog();
              },
              child: const Text('save data'),
            )
          ],
        ),
      ),
      floatingActionButton: Stack(
        children: [
          FloatingActionButton(
            onPressed: () {
              setState(() {
                currentBody = currentBody == BodyType.DataTableBody
                    ? BodyType.TextBody
                    : BodyType.DataTableBody;
              });
            },
            child: const Icon(Icons.swap_horiz),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerTop,
    );
  }

  void _showCollectionNameDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Enter Collection Name'),
        content: TextField(
          onChanged: (value) {
            setState(() {
              collectionName = value;
            });
          },
          decoration: const InputDecoration(
            hintText: 'Enter collection name',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              // Save the data to Firestore with the entered collection name
              await _saveScoreToFirestore(collectionName, studentScores);
              Navigator.of(context).pop();
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  Future<void> _saveScoreToFirestore(
      String collectionName, Map<String, String> scores) async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Construct the reference to the Firestore main collection where the data will be stored
      CollectionReference scoresCollection =
          firestore.collection('${widget.subjectName}_${widget.className}');

      // Loop through the studentScores map and save each student's score
      for (var student in scores.keys) {
        String score = scores[student] ?? ''; // Get the student's score

        // Create a subcollection for each student
        CollectionReference studentSubcollection =
            scoresCollection.doc(collectionName).collection(student);

        await studentSubcollection.doc('score').set({
          'studentName': student,
          'subjectName': widget.subjectName,
          'className': widget.className,
          'score': score,
        });
      }
    } catch (e) {
      print('Error saving student scores to Firestore: $e');
    }
  }
}

class AddScoreOptionDialog extends StatefulWidget {
  const AddScoreOptionDialog({super.key});

  @override
  _AddScoreOptionDialogState createState() => _AddScoreOptionDialogState();
}

class _AddScoreOptionDialogState extends State<AddScoreOptionDialog> {
  TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Score Option'),
      content: TextField(
        controller: _controller,
        decoration: const InputDecoration(
          hintText: 'Enter the new score option',
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context)
                .pop(); // Close the dialog without adding anything.
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(_controller
                .text); // Pass the entered value back to the previous screen.
          },
          child: const Text('Add'),
        ),
      ],
    );
  }
}
