import 'package:flutter/material.dart';
import 'package:student/Admin/schoolInformation/admin_add.dart';
import 'package:student/Admin/schoolInformation/student_add.dart';
import 'package:student/Admin/schoolInformation/subject_add.dart';

class AdminData extends StatefulWidget {
  static const String routeName = '/adminData-screen';
  const AdminData({Key? key}) : super(key: key);

  @override
  State<AdminData> createState() => _AdminDataState();
}

class _AdminDataState extends State<AdminData>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin input Data'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Students'),
            Tab(text: 'Subjects & Topics'),
            Tab(text: 'Admin'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          AddStudent(),
          AddSubject(),
          AdminAddScreen(),
        ],
      ),
    );
  }
}
