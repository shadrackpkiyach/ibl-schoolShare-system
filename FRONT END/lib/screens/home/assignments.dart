import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AssignmentsScreen extends StatefulWidget {
  static const String routeName = '/assignments-screen';
  const AssignmentsScreen({Key? key}) : super(key: key);

  @override
  State<AssignmentsScreen> createState() => _AssignmentsScreenState();
}

TextEditingController titleController = TextEditingController();
TextEditingController workflowController = TextEditingController();

class _AssignmentsScreenState extends State<AssignmentsScreen> {
  Map<String, bool> cardExpandedMap = {};

  bool shouldShowMore(String text, TextStyle style, int maxLines) {
    final span = TextSpan(text: text, style: style);
    final textPainter = TextPainter(
      text: span,
      textAlign: TextAlign.left,
      textDirection: TextDirection.ltr,
      maxLines: maxLines,
    );

    textPainter.layout(minWidth: 0, maxWidth: double.infinity);
    return textPainter.didExceedMaxLines;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance.collection('assignments').snapshots(),
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

          // Group documents by grade
          final groupedData = <String, List<DocumentSnapshot>>{};
          for (var document in snapshot.data!.docs) {
            String grade = document['grade'] ?? 'No Grade';
            groupedData.putIfAbsent(grade, () => []).add(document);
          }

          return ListView.builder(
            itemCount: groupedData.length,
            itemBuilder: (BuildContext context, int index) {
              final grade = groupedData.keys.toList()[index];
              final documents = groupedData[grade]!;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Grade $grade',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: documents.length,
                    itemBuilder: (BuildContext context, int index) {
                      DocumentSnapshot document = documents[index];
                      String title = document['title'] ?? 'No Subject';
                      String week = document['week'] ?? 'No week';
                      String date = document['date'] ?? 'No Date stated';
                      String expandedText =
                          document['assignment'] ?? 'No assignment';
                      bool isExpanded = cardExpandedMap[document.id] ?? false;

                      return Card(
                        child: Column(
                          children: [
                            ListTile(
                              title: Text('$week - $date'),
                              subtitle: Text(
                                title,
                                maxLines: isExpanded ? null : 3,
                                overflow: TextOverflow.ellipsis,
                              ),
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
                              LayoutBuilder(
                                builder: (BuildContext context,
                                    BoxConstraints constraints) {
                                  final shouldShowButton = shouldShowMore(
                                    expandedText,
                                    Theme.of(context).textTheme.bodyMedium!,
                                    3,
                                  );

                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(expandedText),
                                      if (shouldShowButton)
                                        TextButton(
                                          onPressed: () {
                                            setState(() {
                                              cardExpandedMap[document.id] =
                                                  false;
                                            });
                                          },
                                          child: const Text('Show Less'),
                                        ),
                                    ],
                                  );
                                },
                              ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
