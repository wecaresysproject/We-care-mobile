import 'package:equatable/equatable.dart';

class ChatMessage extends Equatable {
  final String id;
  final String content;
  final DateTime timestamp;
  final bool isUserMessage;

  const ChatMessage({
    required this.id,
    required this.content,
    required this.timestamp,
    required this.isUserMessage,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'] as String,
      content: json['content'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      isUserMessage: json['isUserMessage'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'timestamp': timestamp.toIso8601String(),
      'isUserMessage': isUserMessage,
    };
  }

  ChatMessage copyWith({
    String? id,
    String? content,
    DateTime? timestamp,
    bool? isUserMessage,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      content: content ?? this.content,
      timestamp: timestamp ?? this.timestamp,
      isUserMessage: isUserMessage ?? this.isUserMessage,
    );
  }

  @override
  List<Object?> get props => [id, content, timestamp, isUserMessage];
}
