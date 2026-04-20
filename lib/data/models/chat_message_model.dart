class ChatMessage {
  final String id;
  final String senderId;
  final String text;
  final DateTime timestamp;
  final String type;
  final Map<String, dynamic>? offer;

  ChatMessage({
    required this.id,
    required this.senderId,
    required this.text,
    required this.timestamp,
    this.type = 'text',
    this.offer,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'] ?? '',
      senderId: json['senderId'] ?? '',
      text: json['text'] ?? '',
      timestamp: json['timestamp'] is DateTime
          ? json['timestamp']
          : DateTime.parse(json['timestamp'] ?? DateTime.now().toString()),
      type: json['type'] ?? 'text',
      offer: json['offer'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'senderId': senderId,
        'text': text,
        'timestamp': timestamp.toIso8601String(),
        'type': type,
        'offer': offer,
      };
}
