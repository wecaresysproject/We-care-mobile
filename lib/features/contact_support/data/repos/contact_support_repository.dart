import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:uuid/uuid.dart';
import 'package:we_care/core/global/Helpers/app_logger.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/networking/api_error_handler.dart';
import 'package:we_care/core/networking/api_result.dart';
import 'package:we_care/core/networking/dio_serices.dart';
import 'package:we_care/features/contact_support/data/models/chat_message_model.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class ContactSupportRepository {
  // WebSocket URL
  static const String kDummyWebSocketUrl = 'ws://147.93.57.70/hubs/chat';
  // In-memory storage for messages
  final List<ChatMessage> _messages = [];
  final Uuid _uuid = const Uuid();

  // WebSocket handling
  WebSocketChannel? _channel;
  final StreamController<List<ChatMessage>> _messagesController =
      StreamController<List<ChatMessage>>.broadcast();

  // Expose messages stream
  Stream<List<ChatMessage>> get messagesStream => _messagesController.stream;

  ContactSupportRepository() {
    _initWebSocket();
  }
  String? _extractAccessToken() {
    final authHeader = DioServices.getUserToken();
    if (authHeader.isEmptyOrNull) return null;

    // Remove "Bearer "
    return authHeader.replaceFirst('Bearer ', '');
  }

  void _initWebSocket() {
    try {
      final token = _extractAccessToken();

      _channel = WebSocketChannel.connect(
        Uri.parse('$kDummyWebSocketUrl?access_token=$token'),
      );

      /// Send SignalR handshake
      final handshakePayload =
          '${jsonEncode({"protocol": "json", "version": 1})}\u001e';
      _channel!.sink.add(handshakePayload);

      _channel!.stream.listen(
        (message) {
          log("message: $message");

          /// 🔽 Then handle SignalR messages normally
          try {
            final raw = message.toString();
            final frames = raw.split('\u001e');

            for (final frame in frames) {
              if (frame.trim().isEmpty) continue;

              final data = jsonDecode(frame);

              // 🔕 Ignore SignalR protocol frames
              if (data is Map && (data['type'] == 6 || data['type'] == 7)) {
                continue;
              }

              // ✅ Handle app messages
              if (data is Map &&
                  data['type'] == 1 &&
                  data['target'] == 'SendMessage' &&
                  data['arguments'] is List &&
                  data['arguments'].isNotEmpty) {
                final msg = data['arguments'][0];

                if (msg is Map && msg['type'] == 'message') {
                  final chatMessage = ChatMessage(
                    id: _uuid.v4(),
                    content: msg['content'],
                    timestamp: DateTime.parse(msg['timestamp']),
                    isUserMessage: msg['senderType'] == 'user', // false
                  );

                  _addMessage(chatMessage);
                }
              }
            }
          } catch (e) {
            AppLogger.error('WS parse error: $e');
          }
        },
        onError: (error) {
          AppLogger.error('WebSocket error: $error');
        },
        onDone: () {},
      );
    } catch (e) {
      AppLogger.error('Error connecting to WebSocket: $e');
    }
  }

  void _addMessage(ChatMessage message) {
    _messages.add(message);
    // Sort by timestamp
    _messages.sort((a, b) => a.timestamp.compareTo(b.timestamp));
    _messagesController.add(List.from(_messages));
  }

  /// Send a message
  Future<ApiResult<List<ChatMessage>>> sendMessage(String content) async {
    try {
      // Send to WebSocket with new structure
      if (_channel != null) {
        final payload = '${jsonEncode(
          {
            "type": 1,
            "target": "SendMessage",
            "arguments": [
              {
                "type": "message",
                "content": content,
                "senderType": "user",
              }
            ],
          },
        )}\u001e';

        _channel!.sink.add(payload);
      }

      return ApiResult.success(_messages);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  void closeWebSocket() {
    try {
      AppLogger.info("closeWebSocket called");
      _channel?.sink.close();
      _channel = null;

      if (!_messagesController.isClosed) {
        _messagesController.close();
      }

      _messages.clear();
    } catch (e) {
      AppLogger.error('Error closing WebSocket: $e');
    }
  }
}
