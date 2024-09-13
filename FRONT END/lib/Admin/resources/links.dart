import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class LinksCardAdminListView extends StatefulWidget {
  const LinksCardAdminListView({super.key});

  @override
  _LinksCardAdminListViewState createState() => _LinksCardAdminListViewState();
}

class _LinksCardAdminListViewState extends State<LinksCardAdminListView> {
  Map<String, bool> cardExpandedMap = {};

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('documents').snapshots(),
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
            Map<String, dynamic> data = document.data() as Map<String, dynamic>;

            String subject = data['subject'] ?? 'No Subject';
            String grade = data['grade'] ?? 'No Grade';
            String title = data['title'] ?? 'No Title';

            bool isExpanded = cardExpandedMap[document.id] ?? false;

            return Card(
              child: Column(
                children: [
                  ListTile(
                    title: Text('$subject - $grade'),
                    subtitle: Text(title),
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
                    Container(
                      padding: const EdgeInsets.all(16.0),
                      child: const Text('More information goes here'),
                    ),
                ],
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
