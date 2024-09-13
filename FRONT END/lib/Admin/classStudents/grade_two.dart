import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GradeTwo extends StatefulWidget {
  const GradeTwo({super.key});

  @override
  State<GradeTwo> createState() => _GradeTwoState();
}

class _GradeTwoState extends State<GradeTwo> {
  Future<void> deleteDocument(String documentId) async {
    await FirebaseFirestore.instance
        .collection('Grade 2')
        .doc(documentId)
        .delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('Grade 2').snapshots(),
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

              String assessNo = data['assessNo'] ?? 'No assessment';
              String name = data['name'] ?? 'No name';

              return Card(
                child: Column(
                  children: [
                    ListTile(
                      title: Text('$assessNo -- $name'),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          onPressed: () {
                            deleteDocument(document.id);
                          },
                          icon: const Icon(Icons.delete),
                        ),
                      ],
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
