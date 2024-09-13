class ChatEverModel {
  // Existing properties and constructor...
  final String senderId;
  final String targetId;
  final String content;
  final String name;

  DateTime? timestamp;

  ChatEverModel({
    required this.senderId,
    required this.targetId,
    required this.content,
    required this.name,
    this.timestamp,
  });
  // Named constructor for deserializing JSON data
  factory ChatEverModel.fromJson(Map<String, dynamic> json) {
    return ChatEverModel(
      // Parse the JSON data to populate the MessageModel properties
      // Make sure the keys match the keys in your server's response
      senderId: json['senderId'],
      targetId: json['targetId'],
      content: json['content'],
      name: json['name'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
}
