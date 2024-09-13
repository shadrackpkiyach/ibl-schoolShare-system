import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DocumentAdminCardListView extends StatelessWidget {
  const DocumentAdminCardListView({Key? key}) : super(key: key);

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
            String grade = data['grade'] ?? 'No grade';
            String title = data['title'] ?? 'No title';
            // String pdfURL = data['pdfURL'] ?? 'No pdfURL';

            return Card(
              child: ListTile(
                title: Text('$subject - $grade'),
                subtitle: Text(title),
                trailing: ElevatedButton(
                  onPressed: () {
                    // Handle button press, e.g., launch download
                    // You can use the 'downloadUrl' variable here
                  },
                  child: const Text('Download'),
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
