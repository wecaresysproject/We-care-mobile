import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/app_logger.dart';
import 'package:we_care/features/contact_support/data/models/chat_message_model.dart';
import 'package:we_care/features/contact_support/data/repos/contact_support_repository.dart';

part 'contact_support_state.dart';

class ContactSupportCubit extends Cubit<ContactSupportState> {
  final ContactSupportRepository repository;

  ContactSupportCubit(this.repository) : super(ContactSupportState.initial());

  /// Load initial messages
  Future<void> loadMessages() async {
    emit(state.copyWith(requestStatus: RequestStatus.loading));

    final response = await repository.getAllMessages();

    response.when(
      success: (messages) {
        emit(state.copyWith(
          messages: messages,
          requestStatus: RequestStatus.success,
        ));
        AppLogger.info('Loaded ${messages.length} chat messages');
      },
      failure: (error) {
        emit(state.copyWith(
          requestStatus: RequestStatus.failure,
          errorMessage: error.errors.isNotEmpty
              ? error.errors.first
              : 'Failed to load messages',
        ));
        AppLogger.error('Failed to load chat messages: ${error.errors}');
      },
    );
  }

  /// Send a message and receive auto-reply
  Future<void> sendMessage(String content) async {
    if (content.trim().isEmpty) return;

    emit(state.copyWith(requestStatus: RequestStatus.loading));

    final response = await repository.sendMessage(content.trim());

    response.when(
      success: (updatedMessages) {
        emit(state.copyWith(
          messages: updatedMessages,
          requestStatus: RequestStatus.success,
        ));
        AppLogger.info('Message sent successfully, total messages: ${updatedMessages.length}');
      },
      failure: (error) {
        emit(state.copyWith(
          requestStatus: RequestStatus.failure,
          errorMessage: error.errors.isNotEmpty
              ? error.errors.first
              : 'Failed to send message',
        ));
        AppLogger.error('Failed to send message: ${error.errors}');
      },
    );
  }
}
