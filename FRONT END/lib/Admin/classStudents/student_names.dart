import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:student/Admin/classStudents/grade_five.dart';
import 'package:student/Admin/classStudents/grade_four.dart';
import 'package:student/Admin/classStudents/grade_one.dart';
import 'package:student/Admin/classStudents/grade_seven.dart';
import 'package:student/Admin/classStudents/grade_six.dart';
import 'package:student/Admin/classStudents/grade_three.dart';
import 'package:student/Admin/classStudents/grade_two.dart';

class StudentData extends StatefulWidget {
  static const String routeName = '/studentData-screen';
  const StudentData({Key? key}) : super(key: key);

  @override
  State<StudentData> createState() => _StudentDataState();
}

class _StudentDataState extends State<StudentData>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 7, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> deleteDocument(String documentId) async {
    await FirebaseFirestore.instance
        .collection('Activities')
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
            Navigator.pop(context);
          },
        ),
        title: const Text('student Data'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Grade 1'),
            Tab(text: 'Grade 2'),
            Tab(text: 'Grade 3'),
            Tab(text: 'Grade 4'),
            Tab(text: 'Grade 5'),
            Tab(text: 'Grade 6'),
            Tab(text: 'Grade 7'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          GradeOne(),
          GradeTwo(),
          GradeThree(),
          GradeFour(),
          GradeFive(),
          GradeSix(),
          GradeSeven(),
        ],
      ),
    );
  }

  Widget _buildStudentTab() {
    // Implement the UI for posting student names to the database here
    return const Center(
      child: Text('Student Tab Placeholder'),
    );
  }

  Widget _buildSubjectsAndTopicsTab() {
    // Implement the UI for posting subjects and topics to the database here
    return const Center(
      child: Text('Subjects & Topics Tab Placeholder'),
    );
  }
}
