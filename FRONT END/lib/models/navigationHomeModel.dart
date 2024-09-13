// ignore_for_file: file_names

import 'package:flutter/material.dart';

class NavigationHomeModel {
  late String title;
  late IconData icon;

  NavigationHomeModel({required this.title, required this.icon});
}

List<NavigationHomeModel> navigationHomeItems = [
  NavigationHomeModel(title: "Workflow", icon: Icons.insert_chart),
  NavigationHomeModel(title: "Assignment", icon: Icons.book),
  NavigationHomeModel(title: "assessments", icon: Icons.book),
  NavigationHomeModel(title: "activities", icon: Icons.label),
];
