// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class NovelsCardListView extends StatelessWidget {
  const NovelsCardListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('novels').snapshots(),
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

        // Organize data into sections by grade
        Map<String, List<DocumentSnapshot>> sections = {};
        for (var document in snapshot.data!.docs) {
          Map<String, dynamic> data = document.data() as Map<String, dynamic>;
          String grade = data['grade'] ?? 'No grade';
          sections.putIfAbsent(grade, () => []).add(document);
        }

        return ListView.builder(
          itemCount: sections.length,
          itemBuilder: (BuildContext context, int index) {
            String grade = sections.keys.elementAt(index);
            List<DocumentSnapshot> documents = sections.values.elementAt(index);

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Grade $grade',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: documents.length,
                  itemBuilder: (BuildContext context, int index) {
                    DocumentSnapshot document = documents[index];
                    Map<String, dynamic> data =
                        document.data() as Map<String, dynamic>;

                    String subject = data['subject'] ?? 'No Subject';
                    String title = data['title'] ?? 'No title';
                    String pdfURL = data['pdfURL'] ?? 'No pdfURL';
                    String uploaderId = data['uploaderId'] ?? 'unknown';

                    return Card(
                      child: ListTile(
                        title: Text(subject),
                        subtitle: Text('$title -- $uploaderId'),
                        trailing: ElevatedButton(
                          onPressed: () {
                            _launchPDFDownload(context, pdfURL);
                          },
                          child: const Text('Download'),
                        ),
                      ),
                    );
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _launchPDFDownload(BuildContext context, String pdfURL) async {
    if (await canLaunch(pdfURL)) {
      await launch(pdfURL);
    } else {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Error'),
          content: const Text('Could not launch the download.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }
}
