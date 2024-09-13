// ignore_for_file: use_build_context_synchronously, prefer_const_constructors

import 'dart:typed_data';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:student/Admin/resources/classactivities.dart';
import 'package:student/Admin/resources/documentsadmin.dart';
import 'package:student/Admin/resources/links.dart';
import 'package:student/Admin/resources/sidebarcolapsing.dart';
import 'package:student/constants/themes.dart';
import 'package:student/models/navigationmodel.dart';

import 'package:student/screens/home/activities.dart';

class ResourcesAdminPage extends StatefulWidget {
  const ResourcesAdminPage({Key? key}) : super(key: key);
  static const String routeName = '/teacher-resource';

  @override
  State<ResourcesAdminPage> createState() => _ResourcesPageAdminState();
}

class _ResourcesPageAdminState extends State<ResourcesAdminPage>
    with SingleTickerProviderStateMixin {
  double maxWidth = 180;
  double minWidth = 70;
  bool isCollapsed = false;
  late ValueNotifier<bool> sidebarCollapsedNotifier;
  late AnimationController _animationController;
  late Animation<double> widthAnimation;
  int currentSelectedIndex = 0;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    widthAnimation = Tween<double>(begin: maxWidth, end: minWidth)
        .animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();

    super.dispose();
  }

  double get animationWidth => widthAnimation.value;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('resources available for the parents'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
              context: context, builder: (builder) => bottomSheet(context));
        },
        child: const Icon(Icons.upload),
      ),
      body: Row(
        children: <Widget>[
          AnimatedBuilder(
            animation: _animationController,
            builder: (context, widget) => getWidget(context, widget),
            //child: getWidget(context, widget)
          ),
          Expanded(
            child: AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(
                    widthAnimation.value - maxWidth,
                    0,
                  ),
                  child: child,
                );
              },
              child: getPageByIndex(currentSelectedIndex),
            ),
          ),
        ],
      ),
    );
  }

  Widget getPageByIndex(int counter) {
    // Return the corresponding page widget based on the index
    switch (counter) {
      case 0:
        return const ActivitiesListView();
      case 1:
        return const DocumentAdminCardListView();
      case 2:
        return LinksCardAdminListView();
      case 3:
        return const DocumentAdminCardListView();
      case 4:
        return ActivitiesAdminCardListView();
      default:
        return const DocumentAdminCardListView();
    }
  }

  Widget getWidget(context, widget) {
    return Material(
      elevation: 80.0,
      child: Container(
        width: widthAnimation.value,
        color: drawerBackgroundColor,
        child: Column(
          children: <Widget>[
            CollapsingAdminListTile(
              title: 'Techie',
              icon: Icons.person,
              animationController: _animationController,
              onTap: () {
                // Navigator.push(
                //  context,
                //  MaterialPageRoute(builder: (context) => Activities()),
                //);
              },
            ),
            const Divider(
              color: Colors.grey,
              height: 40.0,
            ),
            Expanded(
              child: ListView.separated(
                separatorBuilder: (context, counter) {
                  return const Divider(height: 12.0);
                },
                itemBuilder: (context, counter) {
                  return CollapsingAdminListTile(
                    onTap: () {
                      setState(() {
                        currentSelectedIndex = counter;
                      });
                      getPageByIndex(counter);
                    },
                    isSelected: currentSelectedIndex == counter,
                    title: navigationItems[counter].title,
                    icon: navigationItems[counter].icon,
                    animationController: _animationController,
                  );
                },
                itemCount: navigationItems.length,
              ),
            ),
            const SizedBox(
              height: 50.0,
            ),
          ],
        ),
      ),
    );
  }
}

Widget bottomSheet(BuildContext context) {
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
                  showUploadDialog(context);
                }),
                const SizedBox(width: 30),
                creation(Icons.insert_photo, Colors.indigo, "Gallery", () {
                  showUploadDialog(context);
                }),
                const SizedBox(width: 30),
                creation(Icons.camera, Colors.indigo, "Videos", () {
                  showUploadDialog(context);
                }),
              ],
            ),
            const SizedBox(width: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                creation(Icons.insert_drive_file, Colors.indigo, "Documents",
                    () {
                  showUploadDialog(context);
                }),
                const SizedBox(width: 30),
                creation(Icons.insert_photo, Colors.indigo, "Gallery", () {
                  showUploadDialog(context);
                }),
                const SizedBox(width: 30),
                creation(Icons.camera, Colors.indigo, "Videos", () {
                  showUploadDialog(context);
                }),
              ],
            )
          ],
        ),
      ),
    ),
  );
}

void showUploadDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      String title = "";
      String? grade;
      String? subject;
      Uint8List? fileBytes;

      List<String> subjects = [
        'Mathematics',
        'English',
        'Kiswahili',
        'Science'
      ];
      List<String> grades = ['grades 1', 'grades 2', 'grades 3', 'grades 4'];

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

                  // Get the download URL of the uploaded file
                  String downloadURL =
                      await uploadSnapshot.ref.getDownloadURL();

                  // Create a new document with the provided data
                  await newDocument.set({
                    'title': title,
                    'subject': subject,
                    'grade': grade,
                    'pdfURL': downloadURL,
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
