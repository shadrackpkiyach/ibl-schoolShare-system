// ignore_for_file: file_names
class ChatModel {
  String name;
  String icon;
  bool isGroup;
  String time;
  String currentMessage;
  String id;

  ChatModel(
      {required this.name,
      required this.icon,
      required this.time,
      required this.currentMessage,
      required this.isGroup,
      required this.id});
}
