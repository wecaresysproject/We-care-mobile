import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/features/notifications/data/models/app_notification_model.dart';
import 'package:we_care/features/notifications/data/repos/notifications_repo.dart';
import 'package:we_care/features/notifications/logic/unread_notifications_counter.dart';

part 'notifications_state.dart';

class NotificationsCubit extends Cubit<NotificationsState>
    with SafeEmitMixin<NotificationsState> {
  NotificationsCubit(this._notificationsRepo)
      : super(const NotificationsState());

  final NotificationsRepo _notificationsRepo;

  static const int _pageSize = 20;
  int _loadedPages = 0;

  /// أول صفحة — بتتنده عند فتح الشاشة ومع السحب للتحديث.
  Future<void> loadNotifications() async {
    if (state.notifications.isEmpty) {
      safeEmit(state.copyWith(requestStatus: RequestStatus.loading));
    }
    final result = await _notificationsRepo.getNotifications(
      pageNumber: 1,
      pageSize: _pageSize,
    );

    result.when(
      success: (page) {
        _loadedPages = 1;
        safeEmit(
          state.copyWith(
            requestStatus: RequestStatus.success,
            notifications: page.items,
            hasMore: page.hasMore,
          ),
        );
      },
      failure: (error) {
        safeEmit(
          state.copyWith(
            requestStatus: RequestStatus.failure,
            errorMessage: error.errors.first,
          ),
        );
      },
    );
    UnreadNotificationsCounter.refresh();
  }

  /// الصفحة اللى بعدها — لما المستخدم يوصل لآخر القايمة.
  Future<void> loadMore() async {
    if (!state.hasMore || state.isLoadingMore) return;
    safeEmit(state.copyWith(isLoadingMore: true));

    final result = await _notificationsRepo.getNotifications(
      pageNumber: _loadedPages + 1,
      pageSize: _pageSize,
    );

    result.when(
      success: (page) {
        _loadedPages++;
        final notifications = [...state.notifications, ...page.items];
        safeEmit(
          state.copyWith(
            notifications: notifications,
            isLoadingMore: false,
            hasMore: page.items.isNotEmpty && page.hasMore,
          ),
        );
      },
      // فشل صفحة إضافية مايمسحش اللى اتحمل — المستخدم يقدر يكمل سكرول.
      failure: (_) => safeEmit(state.copyWith(isLoadingMore: false)),
    );
  }

  /// الرسالة بتتعلم مقروءة على الشاشة على طول، والطلب بيتبعت فى الخلفية.
  Future<void> markAsRead(AppNotificationModel notification) async {
    if (notification.isRead) return;
    safeEmit(
      state.copyWith(
        notifications: [
          for (final current in state.notifications)
            current.id == notification.id
                ? current.copyWith(isRead: true)
                : current,
        ],
      ),
    );
    UnreadNotificationsCounter.decrement();
    await _notificationsRepo.markAsRead(notification.id);
  }
}
