import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ReportAssessment extends StatefulWidget {
  final String subjectName;
  final String className;

  const ReportAssessment({
    Key? key,
    required this.subjectName,
    required this.className,
  }) : super(key: key);

  @override
  State<ReportAssessment> createState() => _AssessmentSubjectState();
}

class _AssessmentSubjectState extends State<ReportAssessment> {
  List<String> topics = [];

  @override
  void initState() {
    super.initState();

    fetchTopics();
  }

  void fetchTopicsAndSubtopics() async {
    try {
      // Access the Firestore instance
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Construct the Firestore collection reference where the data is stored
      CollectionReference topicsCollection =
          firestore.collection('${widget.subjectName}_${widget.className}');

      // Query the topics collection to get all documents
      QuerySnapshot topicsSnapshot = await topicsCollection.get();
      topics.clear();
      // Process each topic document and retrieve the topic and subtopics
      for (var doc in topicsSnapshot.docs) {
        // Get the topic name
        String topic = doc.id;

        topics.add(topic);
      }

      // Trigger a rebuild to display the fetched data
      setState(() {});
    } catch (e) {
      print('Error fetching topics and subtopics: $e');
    }
  }

  void fetchTopics() async {
    try {
      // Access the Firestore instance
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Construct the Firestore collection reference where the data is stored
      CollectionReference topicsCollection =
          firestore.collection('${widget.subjectName}_${widget.className}');

      // Query the topics collection to get all documents
      QuerySnapshot topicsSnapshot = await topicsCollection.get();
      List<String> fetchedTopics = []; // Create a list to store fetched topics
      // Process each topic document and retrieve the topic and subtopics
      for (var doc in topicsSnapshot.docs) {
        // Get the topic name
        String topic = doc.id;

        fetchedTopics.add(topic);
      }

      // Call setState() outside of the asynchronous function
      setState(() {
        topics.clear();
        topics.addAll(fetchedTopics);
      });
    } catch (e) {
      print('Error fetching topics and subtopics: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Assessment:${widget.className}--${widget.subjectName}'),
      ),
      body: ListView.builder(
        itemCount: topics.length,
        itemBuilder: (context, index) {
          String topic = topics[index];

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                title: Text(
                  topic,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                trailing: ElevatedButton(
                  onPressed: () {
                    // Handle button press for the topic
                    // You can perform any action here
                  },
                  child: const Text('view report'),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
