// ignore_for_file: non_constant_identifier_names, unnecessary_this

//import 'package:student/constants/enums.dart';

abstract class AbstractDocument {
  late String id;
  bool isDownloaded = false;
  //late Document path;
  late String subjectName;
  late int subjectId;
  late String title;
  late String url;
  late int pages;
  late String size;
  late String type;
  late String uploader_id;
  late String GDriveLink;
  late DateTime uploadDate;

  set setDate(DateTime setDate) {}
  set setSize(String size);
  set setUrl(String url);
  set setPages(int value) => this.pages = value;

  set setId(String id) {
    this.id = id;
  }

  set setSubjectId(int id) {
    this.subjectId = id;
  }

  set setUploaderId(String id) {
    this.uploader_id = id;
  }

  // set setPath(Document path);
  set setIsDownloaded(bool id) {
    this.isDownloaded = id;
  }

  set setTitle(String value);

  Map<String, dynamic> toJson();
}
