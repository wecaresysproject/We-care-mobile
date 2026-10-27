part of 'notifications_cubit.dart';

class NotificationsState extends Equatable {
  /// حالة تحميل أول صفحة.
  final RequestStatus requestStatus;
  final List<AppNotificationModel> notifications;
  final String errorMessage;

  /// فيه صفحات تانية لسه متحملتش.
  final bool hasMore;

  /// صفحة تانية بتتحمل دلوقتى تحت القايمة.
  final bool isLoadingMore;

  const NotificationsState({
    this.requestStatus = RequestStatus.initial,
    this.notifications = const [],
    this.errorMessage = '',
    this.hasMore = false,
    this.isLoadingMore = false,
  });

  NotificationsState copyWith({
    RequestStatus? requestStatus,
    List<AppNotificationModel>? notifications,
    String? errorMessage,
    bool? hasMore,
    bool? isLoadingMore,
  }) {
    return NotificationsState(
      requestStatus: requestStatus ?? this.requestStatus,
      notifications: notifications ?? this.notifications,
      errorMessage: errorMessage ?? this.errorMessage,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }

  @override
  List<Object?> get props =>
      [requestStatus, notifications, errorMessage, hasMore, isLoadingMore];
}
