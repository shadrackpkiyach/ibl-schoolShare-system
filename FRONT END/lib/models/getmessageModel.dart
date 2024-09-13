class MessageModel1 {
  // Existing properties and constructor...
  final String senderId;
  final String targetId;
  final String content;
  DateTime? timestamp;

  MessageModel1({
    required this.senderId,
    required this.targetId,
    required this.content,
    this.timestamp,
  });
  // Named constructor for deserializing JSON data
  factory MessageModel1.fromJson(Map<String, dynamic> json) {
    return MessageModel1(
      // Parse the JSON data to populate the MessageModel properties
      // Make sure the keys match the keys in your server's response
      senderId: json['senderId'],
      targetId: json['targetId'],
      content: json['content'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
}
