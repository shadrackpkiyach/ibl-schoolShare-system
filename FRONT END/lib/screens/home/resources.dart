// ignore_for_file: use_build_context_synchronously, prefer_const_constructors

import 'dart:typed_data';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:student/constants/global_variables.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:student/screens/home/userResources/user_uploaded_links.dart';
import 'package:student/screens/home/userResources/user_uploaded_notes.dart';
import 'package:student/screens/home/userResources/user_uploaded_quiz.dart';

class ResourcesPage extends StatefulWidget {
  const ResourcesPage({Key? key}) : super(key: key);

  @override
  State<ResourcesPage> createState() => _ResourcesPageState();
}

class _ResourcesPageState extends State<ResourcesPage>
    with SingleTickerProviderStateMixin {
  double maxWidth = 180;
  double minWidth = 70;
  bool isCollapsed = false;
  late ValueNotifier<bool> sidebarCollapsedNotifier;
  late TabController _tabController;
  late Animation<double> widthAnimation;
  int currentSelectedIndex = 0;

  String? userProfile;

  @override
  void initState() {
    super.initState();
    getUserData();
    _tabController = TabController(length: 4, vsync: this);
  }

  double get animationWidth => widthAnimation.value;

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> getUserData() async {
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

        userProfile = jsonEncode(userData);
      }
    } catch (e) {
      //showSnackBar(context, e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Stack(children: [
        FloatingActionButton(
          onPressed: () {
            showModalBottomSheet(
                context: context,
                builder: (builder) => bottomSheet(context, userProfile));
          },
          child: const Icon(Icons.upload),
        ),
        Positioned(
          bottom: 70, // Adjust this value to position the text vertically
          left: 0,
          right: 0,
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.7),
              borderRadius: BorderRadius.circular(8),
            ),
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Text(
              'Your message here',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ]),
      body: Column(
        children: [
          Container(
            color: Colors.blue,
            child: TabBar(
              controller: _tabController,
              tabs: const [
                Tab(text: 'Notes'),
                Tab(text: 'Q/A questions'),
                Tab(text: 'media links'),
                Tab(text: 'Novels'),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [
                // Your content for Tab 1
                NotesUserCardListView(),
                QuizUserCardListView(),
                LinksUserCardListView(),
                NotesUserCardListView(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Widget bottomSheet(BuildContext context, userProfile) {
  var userData = jsonDecode(userProfile!);
  return SizedBox(
    height: 270,
    width: MediaQuery.of(context).size.width,
    child: Card(
      margin: const EdgeInsets.all(18),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                creation(Icons.insert_drive_file, Colors.indigo, "Documents",
                    () {
                  showUploadDialog(context, userData);
                }),
                const SizedBox(width: 30),
                creation(Icons.insert_photo, Colors.indigo, "Audio links", () {
                  showUploadlinksDialog(context, userData);
                }),
                const SizedBox(width: 30),
                creation(Icons.camera, Colors.indigo, "Videos links", () {
                  showUploadlinksDialog(context, userData);
                }),
              ],
            ),
            const SizedBox(width: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                creation(Icons.insert_drive_file, Colors.indigo, "notes", () {
                  showUploadNotesDialog(context, userData);
                }),
                const SizedBox(width: 30),
                creation(Icons.insert_photo, Colors.indigo, "Novels", () {
                  showUploadNovelsDialog(context, userData);
                }),
                const SizedBox(width: 30),
                creation(Icons.camera, Colors.indigo, "questions", () {
                  showUploadDialog(context, userData);
                }),
              ],
            )
          ],
        ),
      ),
    ),
  );
}

void showUploadDialog(BuildContext context, userData) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      String title = "";
      String uploaderId1 = userData['name'];
      String uploaderId2 = userData['email'];
      String uploaderId = '$uploaderId1-contact on-$uploaderId2';
      String? grade;
      String? subject;

      Uint8List? fileBytes;

      List<String> subjects = [
        'Mathematics',
        'English',
        'Kiswahili',
        'Science'
      ];
      List<String> grades = ['Grades 1', 'Grades 2', 'Grades 3', 'Grades 4'];

      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Upload PDF'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  onChanged: (value) {
                    title = value;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Title',
                  ),
                ),
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
                  hint: const Text('Select Subject'),
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
                ElevatedButton(
                  onPressed: () async {
                    FilePickerResult? result =
                        await FilePicker.platform.pickFiles(
                      type: FileType.custom,
                      allowedExtensions: ['pdf'],
                    );

                    if (result != null) {
                      PlatformFile file = result.files.first;
                      fileBytes = file.bytes;
                      //print('Selected file: ${file.name}');
                      Text('Selected file: ${file.name}');
                    }
                  },
                  child: const Text('Select PDF'),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  "close",
                ),
              ),
              TextButton(
                onPressed: () async {
                  if (title.isEmpty ||
                      grade!.isEmpty ||
                      subject == null ||
                      uploaderId.isEmpty ||
                      fileBytes == null) {
                    return;
                  }

                  await Firebase.initializeApp();

                  CollectionReference documentsCollection =
                      FirebaseFirestore.instance.collection('documents');
                  DocumentReference newDocument = documentsCollection.doc();

                  String filePath = 'documents/${newDocument.id}/upload.pdf';
                  Reference storageReference =
                      FirebaseStorage.instance.ref().child(filePath);
                  UploadTask uploadTask = storageReference.putData(fileBytes!);
                  TaskSnapshot uploadSnapshot =
                      await uploadTask.whenComplete(() {});

                  String downloadURL =
                      await uploadSnapshot.ref.getDownloadURL();

                  await newDocument.set({
                    'title': title,
                    'subject': subject,
                    'grade': grade,
                    'pdfURL': downloadURL,
                    'uploaderId': uploaderId,
                  });
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('File Upload'),
                        content:
                            Text('The file has been uploaded successfully.'),
                        actions: <Widget>[
                          TextButton(
                            child: Text('OK'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
                child: const Text('Upload'),
              ),
            ],
          );
        },
      );
    },
  );
}

void showUploadlinksDialog(BuildContext context, userData) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      String title = "";
      String? grade;
      String? subject;
      String link = "";
      String uploaderId1 = userData['name'];
      String uploaderId2 = userData['email'];
      String uploaderId = '$uploaderId1-contact on-$uploaderId2';

      List<String> subjects = [
        'Mathematics',
        'English',
        'Kiswahili',
        'Science'
      ];
      List<String> grades = ['Grades 1', 'Grades 2', 'Grades 3', 'Grades 4'];

      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Upload  link'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  onChanged: (value) {
                    title = value;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Title',
                  ),
                ),
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
                  hint: const Text('Select Subject'),
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
                TextField(
                  onChanged: (value) {
                    link = value;
                  },
                  decoration: const InputDecoration(
                    labelText: 'link',
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  "close",
                ),
              ),
              TextButton(
                onPressed: () async {
                  if (title.isEmpty ||
                      grade!.isEmpty ||
                      subject == null ||
                      link.isEmpty) {
                    return;
                  }

                  await Firebase.initializeApp();

                  CollectionReference documentsCollection =
                      FirebaseFirestore.instance.collection('links');
                  DocumentReference newDocument = documentsCollection.doc();

                  await newDocument.set({
                    'title': title,
                    'subject': subject,
                    'grade': grade,
                    'uploaderId': uploaderId,
                    'link': link,
                  });
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('link Upload'),
                        content:
                            Text('The link has been uploaded successfully.'),
                        actions: <Widget>[
                          TextButton(
                            child: Text('OK'),
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
                child: const Text('Upload'),
              ),
            ],
          );
        },
      );
    },
  );
}

void showUploadNotesDialog(BuildContext context, userData) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      String title = "";
      String? grade;
      String? subject;
      String uploaderId1 = userData['name'];
      String uploaderId2 = userData['email'];
      String uploaderId = '$uploaderId1-contact on-$uploaderId2';
      // String? path;
      Uint8List? fileBytes;
      //PlatformFile? selectedFile;

      List<String> subjects = [
        'Mathematics',
        'English',
        'Kiswahili',
        'Science'
      ];
      List<String> grades = ['Grades 1', 'Grades 2', 'Grades 3', 'Grades 4'];

      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Upload notes PDF'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  onChanged: (value) {
                    title = value;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Title',
                  ),
                ),
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
                  hint: const Text('Select Subject'),
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
                ElevatedButton(
                  onPressed: () async {
                    FilePickerResult? result =
                        await FilePicker.platform.pickFiles(
                      type: FileType.custom,
                      allowedExtensions: ['pdf'],
                    );

                    if (result != null) {
                      PlatformFile file = result.files.first;
                      fileBytes = file.bytes;
                      //print('Selected file: ${file.name}');
                      Text('Selected file: ${file.name}');
                    }
                  },
                  child: const Text('Select PDF'),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
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
                      grade!.isEmpty ||
                      subject == null ||
                      fileBytes == null) {
                    // Validate that all fields are filled
                    return;
                  }

                  // Initialize Firebase
                  await Firebase.initializeApp();

                  // Create a new document in Firestore collection
                  CollectionReference documentsCollection =
                      FirebaseFirestore.instance.collection('notes');
                  DocumentReference newDocument = documentsCollection.doc();

                  // Upload the file to Firebase Storage (replace "fileName.pdf" with the desired file name)
                  String filePath = 'documents/${newDocument.id}/upload.pdf';
                  Reference storageReference =
                      FirebaseStorage.instance.ref().child(filePath);
                  UploadTask uploadTask = storageReference.putData(fileBytes!);
                  TaskSnapshot uploadSnapshot =
                      await uploadTask.whenComplete(() {});

                  // Get the download URL of the uploaded file
                  String downloadURL =
                      await uploadSnapshot.ref.getDownloadURL();

                  // Create a new document with the provided data
                  await newDocument.set({
                    'title': title,
                    'subject': subject,
                    'grade': grade,
                    'pdfURL': downloadURL,
                    'uploaderId': uploaderId,
                  });
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('File Upload'),
                        content: Text(
                            'The notes file has been uploaded successfully.'),
                        actions: <Widget>[
                          TextButton(
                            child: Text('OK'),
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
                child: const Text('Upload'),
              ),
            ],
          );
        },
      );
    },
  );
}

void showUploadNovelsDialog(BuildContext context, userData) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      String title = "";
      String? grade;
      String? subject;
      String uploaderId1 = userData['name'];
      String uploaderId2 = userData['email'];
      String uploaderId = '$uploaderId1-contact on-$uploaderId2';
      // String? path;
      Uint8List? fileBytes;
      //PlatformFile? selectedFile;

      List<String> subjects = [
        'Mathematics',
        'English',
        'Kiswahili',
        'Science'
      ];
      List<String> grades = ['Grades 1', 'Grades 2', 'Grades 3', 'Grades 4'];

      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Upload novels PDF'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  onChanged: (value) {
                    title = value;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Title',
                  ),
                ),
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
                  hint: const Text('Select Subject'),
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
                ElevatedButton(
                  onPressed: () async {
                    FilePickerResult? result =
                        await FilePicker.platform.pickFiles(
                      type: FileType.custom,
                      allowedExtensions: ['pdf'],
                    );

                    if (result != null) {
                      PlatformFile file = result.files.first;
                      fileBytes = file.bytes;
                      //print('Selected file: ${file.name}');
                      Text('Selected file: ${file.name}');
                    }
                  },
                  child: const Text('Select PDF'),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
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
                      grade!.isEmpty ||
                      subject == null ||
                      fileBytes == null) {
                    // Validate that all fields are filled
                    return;
                  }

                  // Initialize Firebase
                  await Firebase.initializeApp();

                  // Create a new document in Firestore collection
                  CollectionReference documentsCollection =
                      FirebaseFirestore.instance.collection('novels');
                  DocumentReference newDocument = documentsCollection.doc();

                  // Upload the file to Firebase Storage (replace "fileName.pdf" with the desired file name)
                  String filePath = 'documents/${newDocument.id}/upload.pdf';
                  Reference storageReference =
                      FirebaseStorage.instance.ref().child(filePath);
                  UploadTask uploadTask = storageReference.putData(fileBytes!);
                  TaskSnapshot uploadSnapshot =
                      await uploadTask.whenComplete(() {});

                  // Get the download URL of the uploaded file
                  String downloadURL =
                      await uploadSnapshot.ref.getDownloadURL();

                  // Create a new document with the provided data
                  await newDocument.set({
                    'title': title,
                    'subject': subject,
                    'grade': grade,
                    'pdfURL': downloadURL,
                    'uploaderId': uploaderId,
                  });
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('File Upload'),
                        content: Text(
                            'The notes file has been uploaded successfully.'),
                        actions: <Widget>[
                          TextButton(
                            child: Text('OK'),
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
                child: const Text('Upload'),
              ),
            ],
          );
        },
      );
    },
  );
}

Widget creation(IconData icon, Color color, String text, VoidCallback onTap) {
  return InkWell(
    onTap: onTap,
    child: Column(
      children: [
        CircleAvatar(
            radius: 30, backgroundColor: color, child: Icon(icon, size: 29)),
        const SizedBox(
          height: 5,
        ),
        Text(text)
      ],
    ),
  );
}
