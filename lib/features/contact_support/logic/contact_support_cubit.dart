import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/app_logger.dart';
import 'package:we_care/features/contact_support/data/models/chat_message_model.dart';
import 'package:we_care/features/contact_support/data/repos/contact_support_repository.dart';

part 'contact_support_state.dart';

class ContactSupportCubit extends Cubit<ContactSupportState> {
  final ContactSupportRepository repository;
  StreamSubscription? _messagesSubscription;

  ContactSupportCubit(this.repository) : super(ContactSupportState.initial());

  /// Load initial messages and subscribe to updates
  Future<void> loadMessages() async {
    emit(state.copyWith(requestStatus: RequestStatus.loading));
    try {
      // Subscribe to real-time updates
      _messagesSubscription = repository.messagesStream.listen(
        (messages) {
          emit(
            state.copyWith(
              messages: messages,
              requestStatus: RequestStatus.success,
            ),
          );
        },
      );
    } catch (e) {
      emit(
        state.copyWith(
          requestStatus: RequestStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  /// Send a message
  Future<void> sendMessage(String content) async {
    if (content.trim().isEmpty) return;

    final response = await repository.sendMessage(content.trim());

    response.when(
      success: (_) {
        // Stream will update the messages
        AppLogger.info('Message sent successfully');
      },
      failure: (error) {
        emit(
          state.copyWith(
            requestStatus: RequestStatus.failure,
            errorMessage: error.errors.isNotEmpty
                ? error.errors.first
                : 'Failed to send message',
          ),
        );
        AppLogger.error('Failed to send message: ${error.errors}');
      },
    );
  }

  @override
  Future<void> close() {
    closeWebSocketConnection();
    return super.close();
  }

  void closeWebSocketConnection() {
    AppLogger.info('Closing chat & WebSocket connection');
    _messagesSubscription?.cancel();
    repository.closeWebSocket();
  }
}
