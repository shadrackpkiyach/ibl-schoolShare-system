import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NotesCardListView extends StatelessWidget {
  const NotesCardListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('notes').snapshots(),
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
        final Map<String, List<DocumentSnapshot>> gradeSections = {};
        snapshot.data!.docs.forEach((DocumentSnapshot document) {
          Map<String, dynamic> data = document.data() as Map<String, dynamic>;
          String grade = data['grade'] ?? 'No grade';
          gradeSections.putIfAbsent(grade, () => []).add(document);
        });

        return ListView.builder(
          itemCount: gradeSections.length,
          itemBuilder: (BuildContext context, int index) {
            String grade = gradeSections.keys.toList()[index];
            List<DocumentSnapshot> documents = gradeSections[grade] ?? [];

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Grade: $grade',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: documents.length,
                  itemBuilder: (BuildContext context, int index) {
                    Map<String, dynamic> data =
                        documents[index].data() as Map<String, dynamic>;

                    String subject = data['subject'] ?? 'No Subject';
                    String title = data['title'] ?? 'No title';
                    String pdfURL = data['pdfURL'] ?? 'No pdfURL';
                    String uploaderId = data['uploaderId'] ?? 'unknown';

                    return Card(
                      child: ListTile(
                        title: Text('$subject'),
                        subtitle: Text('$title - $uploaderId'),
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
      // ignore: use_build_context_synchronously
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
