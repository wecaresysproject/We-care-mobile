part of 'contact_support_cubit.dart';

class ContactSupportState extends Equatable {
  final List<ChatMessage> messages;
  final RequestStatus requestStatus;
  final String? errorMessage;

  const ContactSupportState({
    required this.messages,
    required this.requestStatus,
    this.errorMessage,
  });

  factory ContactSupportState.initial() {
    return const ContactSupportState(
      messages: [],
      requestStatus: RequestStatus.initial,
      errorMessage: null,
    );
  }

  ContactSupportState copyWith({
    List<ChatMessage>? messages,
    RequestStatus? requestStatus,
    String? errorMessage,
  }) {
    return ContactSupportState(
      messages: messages ?? this.messages,
      requestStatus: requestStatus ?? this.requestStatus,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [messages, requestStatus, errorMessage];
}
