import 'package:equatable/equatable.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/features/home_tab/models/message_notification_model.dart';

class HomeState extends Equatable {
  final List<CrausalMessageModel> notifications;
  final RequestStatus requestStatus;
  final String? errorMessage;

  const HomeState({
    required this.notifications,
    required this.requestStatus,
    this.errorMessage,
  });

  factory HomeState.initial() {
    return const HomeState(
      notifications: [],
      requestStatus: RequestStatus.initial,
      errorMessage: null,
    );
  }

  HomeState copyWith({
    List<CrausalMessageModel>? notifications,
    RequestStatus? requestStatus,
    String? errorMessage,
  }) {
    return HomeState(
      notifications: notifications ?? this.notifications,
      requestStatus: requestStatus ?? this.requestStatus,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [notifications, requestStatus, errorMessage];
}
