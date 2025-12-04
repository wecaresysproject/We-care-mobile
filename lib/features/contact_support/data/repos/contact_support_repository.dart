import 'package:uuid/uuid.dart';
import 'package:we_care/core/networking/api_error_handler.dart';
import 'package:we_care/core/networking/api_result.dart';
import 'package:we_care/features/contact_support/data/models/chat_message_model.dart';

class ContactSupportRepository {
  // In-memory storage for messages - will be replaced with API calls later
  final List<ChatMessage> _messages = [];
  final Uuid _uuid = const Uuid();
  int _replyIndex = 0;

  // Mock auto-reply messages in Arabic
  final List<String> _autoReplies = [
    'شكراً على تواصلك معنا. سنرد عليك قريباً',
    'تم استلام رسالتك. فريق الدعم سيتواصل معك قريباً',
    'نحن هنا لمساعدتك. كيف يمكننا خدمتك؟',
    'رسالتك مهمة بالنسبة لنا. سيتم الرد عليك في أقرب وقت',
    'شكراً لتواصلك. نحن نعمل على حل استفسارك',
  ];

  ContactSupportRepository() {
    // Add initial welcome message
    _messages.add(
      ChatMessage(
        id: _uuid.v4(),
        content: 'مرحباً بك في خدمة الدعم. كيف يمكننا مساعدتك اليوم؟',
        timestamp: DateTime.now(),
        isUserMessage: false,
      ),
    );
  }

  /// Get all messages
  Future<ApiResult<List<ChatMessage>>> getAllMessages() async {
    try {
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 300));

      // Return messages sorted by timestamp (oldest first)
      final sortedMessages = List<ChatMessage>.from(_messages)
        ..sort((a, b) => a.timestamp.compareTo(b.timestamp));

      return ApiResult.success(sortedMessages);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  /// Send a message and get auto-reply
  Future<ApiResult<List<ChatMessage>>> sendMessage(String content) async {
    try {
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 500));

      // Create user message
      final userMessage = ChatMessage(
        id: _uuid.v4(),
        content: content,
        timestamp: DateTime.now(),
        isUserMessage: true,
      );

      _messages.add(userMessage);

      // Simulate slight delay before auto-reply
      await Future.delayed(const Duration(milliseconds: 300));

      // Create system auto-reply
      final systemMessage = ChatMessage(
        id: _uuid.v4(),
        content: _autoReplies[_replyIndex % _autoReplies.length],
        timestamp: DateTime.now(),
        isUserMessage: false,
      );

      _messages.add(systemMessage);
      _replyIndex++;

      // Return all messages sorted by timestamp
      final sortedMessages = List<ChatMessage>.from(_messages)
        ..sort((a, b) => a.timestamp.compareTo(b.timestamp));

      return ApiResult.success(sortedMessages);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }
}
