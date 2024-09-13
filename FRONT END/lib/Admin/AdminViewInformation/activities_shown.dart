// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:readmore/readmore.dart';

import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firabase_storage;

class ClassShownActivities extends StatefulWidget {
  static const String routeName = '/class_shown_activities-screen';
  const ClassShownActivities({super.key});

  @override
  State<ClassShownActivities> createState() => _ClassShownActivitiesState();
}

String? selectedFile;
late Uint8List? selectedImageInBytes;
int imageCounts = 0;
List<Uint8List?> pickedImagesInBytes = [];
List<String> imageUrls = [];
late String imageURL;

File? imageFile;
Uint8List? fileBytes;
final ImagePicker _picker = ImagePicker();

TextEditingController titleController = TextEditingController();
TextEditingController workflowController = TextEditingController();

class _ClassShownActivitiesState extends State<ClassShownActivities> {
  Map<String, bool> cardExpandedMap = {};

  Future<void> deleteDocument(String documentId) async {
    await FirebaseFirestore.instance
        .collection('ShownActivity')
        .doc(documentId)
        .delete();
  }

  bool shouldShowMore(String text, TextStyle style, int maxLines) {
    final span = TextSpan(text: text, style: style);
    //const constraints = BoxConstraints(maxWidth: double.infinity);
    final textPainter = TextPainter(
      text: span,
      textAlign: TextAlign.left,
      textDirection: TextDirection.ltr,
      maxLines: maxLines,
    );

    textPainter.layout(minWidth: 0, maxWidth: double.infinity);
    return textPainter.didExceedMaxLines;
  }

// ...

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
        title: const Text('Activities Done by the students'),
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
                  child: Text('post Activities'),
                ),
              ),
            ],
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance.collection('ShownActivity').snapshots(),
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

              // firbaseStorage.Reference storageRef = storage.ref('product');
//......
              // final imgUrl =  storageRef
              //.child('ImagePath')
              // .getDownloadURL();

              String subject = data['subject'] ?? 'No Subject';
              String grade = data['grade'] ?? 'No Grade';
              String student = data['student'] ?? 'No week';
              String imageURL = data['imageURL'] ?? 'no image';
              String expandedText = data['information'] ?? 'No workflow';

              return Card(
                child: Column(
                  children: [
                    ListTile(
                      title: Text('$grade - $subject'),
                      subtitle: Column(
                        children: [
                          Text('this work was done by:$student'),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.2,
                            height: MediaQuery.of(context).size.height * 0.3,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                fit: BoxFit.fitWidth,
                                image: NetworkImage(
                                  imageURL,
                                ),
                                onError: (error, stackTrace) {
                                  print("Error loading image: $error");
                                  // Return a placeholder or an error indicator widget here.
                                  // You can use Image.asset() to show a local placeholder image.
                                  return; // Replace 'assets/error_placeholder.png' with your own error image asset.
                                },
                              ),
                            ),
                          ),
                          ReadMoreText(
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
                        ],
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

Future<void> _selectFile(
    bool imageFrom, void Function(VoidCallback) setStateParent) async {
  FilePickerResult? fileResult =
      await FilePicker.platform.pickFiles(allowMultiple: true);

  if (fileResult != null) {
    selectedFile = fileResult.files.first.name;
    fileResult.files.forEach((element) {
      setStateParent(() {
        // pickedImagesInBytes.add(element.bytes);
        selectedImageInBytes = fileResult.files.first.bytes;
        imageCounts += 1;
      });
    });
  }
  print(selectedFile);
}

void showUploadDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      String? subject;
      String? grade;

      String? student;
      String? information;

      List<String> subjects = [
        'english',
        'kiswahili',
        'mathematics',
        'science',
        'arts and craft ',
        'home science'
      ];

      List<String> grades = ['grades 1', 'grades 2', 'grades 3', 'grades 4'];

      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Submit the classes Activities samples'),
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
                      onChanged: (value) {
                        student = value;
                      },
                      decoration: const InputDecoration(
                        labelText: 'student name',
                      ),
                      maxLines: null,
                    ),
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
                  ListTile(
                      leading: const Icon(
                        Icons.photo_library,
                      ),
                      title: const Text(
                        'Gallery',
                        style: TextStyle(),
                      ),
                      onTap: () {
                        _selectFile(true, setState);
                      }),
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
                  if (subject == null ||
                      grade == null ||
                      student == null ||
                      information == null) {
                    // Validate that all fields are filled
                    return;
                  }

                  if (selectedFile == null || selectedImageInBytes == null) {
                    // Check if the required data is null
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Missing Data'),
                          content:
                              const Text('Please select an image and file.'),
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
                    return; // Return without saving the document if required data is null
                  }

                  // Initialize Firebase
                  await Firebase.initializeApp();

                  // Create a new document in Firestore collection
                  CollectionReference documentsCollection =
                      FirebaseFirestore.instance.collection('ShownActivity');
                  DocumentReference newDocument = documentsCollection.doc();

                  String imageUrl; // Initialize the imageUrl variable

                  try {
                    firabase_storage.UploadTask uploadTask;

                    firabase_storage.Reference ref = firabase_storage
                        .FirebaseStorage.instance
                        .ref()
                        .child('ShownActivity')
                        .child('$selectedFile');

                    uploadTask = ref.putData(
                      selectedImageInBytes!,
                    );

                    await uploadTask.whenComplete(() => null);
                    imageUrl = await ref.getDownloadURL();
                    print(imageUrl);
                  } catch (e) {
                    print(e);
                    return; // If an error occurs during image upload, return without saving the document
                  }

                  // Upload the file to Firebase Storage (replace "fileName.pdf" with the desired file name)

                  // Create a new document with the provided data
                  await newDocument.set({
                    'subject': subject,
                    'student': student,
                    'grade': grade,
                    'information': information,
                    'imageURL': imageUrl,
                    'createdOn': DateTime.now().toIso8601String(),
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
