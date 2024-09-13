// ignore_for_file: use_build_context_synchronously, unused_local_variable

import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:readmore/readmore.dart';

class ClassTShownActivities extends StatefulWidget {
  static const String routeName = '/class_shown_activities-screen';
  const ClassTShownActivities({super.key});

  @override
  State<ClassTShownActivities> createState() => _ClassTShownActivitiesState();
}

String? selectedFile;
late Uint8List? selectedImageInBytes;
int imageCounts = 0;
List<Uint8List?> pickedImagesInBytes = [];
List<String> imageUrls = [];
late String imageURL;

File? imageFile;
Uint8List? fileBytes;

TextEditingController titleController = TextEditingController();
TextEditingController workflowController = TextEditingController();

class _ClassTShownActivitiesState extends State<ClassTShownActivities> {
  Map<String, bool> cardExpandedMap = {};

  Future<void> deleteDocument(String documentId) async {
    await FirebaseFirestore.instance
        .collection('ShownActivity')
        .doc(documentId)
        .delete();
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
        title: const Text('Activities Done by the students'),
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
                                  return;
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

// ignore: unused_element
Future<void> _selectFile(
    bool imageFrom, void Function(VoidCallback) setStateParent) async {
  FilePickerResult? fileResult =
      await FilePicker.platform.pickFiles(allowMultiple: true);

  if (fileResult != null) {
    selectedFile = fileResult.files.first.name;
    for (var element in fileResult.files) {
      setStateParent(() {
        // pickedImagesInBytes.add(element.bytes);
        selectedImageInBytes = fileResult.files.first.bytes;
        imageCounts += 1;
      });
    }
  }
}
