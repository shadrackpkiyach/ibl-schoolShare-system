import 'package:flutter/material.dart';

class NavigationModel {
  late String title;
  late IconData icon;

  NavigationModel({required this.title, required this.icon});
}

List<NavigationModel> navigationItems = [
  NavigationModel(title: "Notes", icon: Icons.insert_chart),
  NavigationModel(title: "questions", icon: Icons.book),
  NavigationModel(title: "links", icon: Icons.document_scanner),
  NavigationModel(title: "novels", icon: Icons.book),
  NavigationModel(title: "activities", icon: Icons.label),
];
