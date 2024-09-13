import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:student/Admin/TeacherTasks/assessing.dart';

class AssessmentSubject extends StatefulWidget {
  final String subjectName;
  final String className;

  const AssessmentSubject({
    Key? key,
    required this.subjectName,
    required this.className,
  }) : super(key: key);

  @override
  State<AssessmentSubject> createState() => _AssessmentSubjectState();
}

class _AssessmentSubjectState extends State<AssessmentSubject> {
  List<String> topics = [];
  Map<String, List<String>> subtopics = {};
  List<List<bool>> subtopicChecklist = [];

  @override
  void initState() {
    super.initState();
    // Initialize the checklist with false values for each subtopic
    fetchTopicsAndSubtopics();
  }

  void fetchTopicsAndSubtopics() async {
    try {
      // Access the Firestore instance
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Construct the Firestore collection reference where the data is stored
      CollectionReference topicsCollection =
          firestore.collection('${widget.className}_${widget.subjectName}');

      // Query the topics collection to get all documents
      QuerySnapshot topicsSnapshot = await topicsCollection.get();

      // Process each topic document and retrieve the topic and subtopics
      for (var topicDoc in topicsSnapshot.docs) {
        String topic = topicDoc.get('topic');
        List<String> subtopicList = List<String>.from(topicDoc.get('subtopic'));
        List<bool> topicChecklist =
            List.generate(subtopicList.length, (_) => false);

        // Add the topic and subtopics to the lists
        topics.add(topic);
        subtopics[topic] = subtopicList;
        subtopicChecklist.add(topicChecklist);
      }

      // Trigger a rebuild to display the fetched data
      setState(() {});
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
          List<String>? subtopicList = subtopics[topic];
          List<bool>? topicChecklist = subtopicChecklist[index];

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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AccessingStudent(
                          subjectName: widget.subjectName,
                          className: widget.className,
                        ),
                      ),
                    );
                  },
                  child: const Text('add access'),
                ),
              ),
              if (subtopicList != null)
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: subtopicList.length,
                  itemBuilder: (context, subIndex) {
                    String subtopic = subtopicList[subIndex];
                    bool isChecked = topicChecklist[subIndex];

                    return ListTile(
                      leading: Checkbox(
                        value: isChecked,
                        onChanged: (value) {
                          setState(() {
                            topicChecklist[subIndex] = value ?? false;
                          });
                        },
                      ),
                      title: Text(subtopic),
                    );
                  },
                ),
            ],
          );
        },
      ),
    );
  }
}
