import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class LinksCardListView extends StatefulWidget {
  const LinksCardListView({Key? key}) : super(key: key);

  @override
  _LinksCardListViewState createState() => _LinksCardListViewState();
}

class _LinksCardListViewState extends State<LinksCardListView> {
  Map<String, bool> cardExpandedMap = {};

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('links').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
              strokeWidth: 2.0,
            ),
          );
        }

        // Organize documents by grade
        Map<String, List<DocumentSnapshot>> documentsByGrade = {};
        snapshot.data!.docs.forEach((DocumentSnapshot document) {
          Map<String, dynamic> data = document.data() as Map<String, dynamic>;
          String grade = data['grade'] ?? 'No Grade';
          documentsByGrade.putIfAbsent(grade, () => []).add(document);
        });

        return ListView.builder(
          itemCount: documentsByGrade.length,
          itemBuilder: (BuildContext context, int index) {
            String grade = documentsByGrade.keys.toList()[index];
            List<DocumentSnapshot> documents = documentsByGrade[grade] ?? [];

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
                Column(
                  children: documents.map((DocumentSnapshot document) {
                    Map<String, dynamic> data =
                        document.data() as Map<String, dynamic>;

                    String subject = data['subject'] ?? 'No Subject';
                    String title = data['title'] ?? 'No Title';
                    String link = data['link'] ?? '';

                    bool isExpanded = cardExpandedMap[document.id] ?? false;

                    return Card(
                      child: Column(
                        children: [
                          ListTile(
                            title: Text(subject),
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
                              child: Text(link),
                            ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
