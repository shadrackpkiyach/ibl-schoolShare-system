import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class DocumentCardListView extends StatelessWidget {
  const DocumentCardListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('documents').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        // Organize documents into sections according to grade
        final documentsByGrade = <String, List<DocumentSnapshot>>{};
        snapshot.data!.docs.forEach((document) {
          final grade = document['grade'] ?? 'No grade';
          documentsByGrade.putIfAbsent(grade, () => []).add(document);
        });

        return ListView.builder(
          itemCount: documentsByGrade.length,
          itemBuilder: (BuildContext context, int index) {
            final grade = documentsByGrade.keys.elementAt(index);
            final documents = documentsByGrade[grade]!;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: Text(
                    'Grade $grade',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: documents.length,
                  itemBuilder: (BuildContext context, int index) {
                    final document = documents[index];
                    return DocumentCard(document: document);
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }
}

class DocumentCard extends StatelessWidget {
  final DocumentSnapshot document;

  const DocumentCard({Key? key, required this.document}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final data = document.data() as Map<String, dynamic>;
    final subject = data['subject'] ?? 'No Subject';
    final title = data['title'] ?? 'No title';
    final pdfURL = data['pdfURL'] ?? 'No pdfURL';
    final uploaderId = data['uploaderId'] ?? 'unknown';

    return Card(
      child: ListTile(
        title: Text(subject),
        subtitle: Text(title + ' - ' + uploaderId),
        trailing: ElevatedButton(
          onPressed: () {
            _launchPDFDownload(context, pdfURL);
          },
          child: const Text('Download'),
        ),
      ),
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
