import 'package:we_care/core/networking/api_error_handler.dart';
import 'package:we_care/core/networking/api_result.dart';
import 'package:we_care/features/notifications/data/models/app_notification_model.dart';
import 'package:we_care/features/notifications/notifications_services.dart';

class NotificationsRepo {
  NotificationsRepo(this._notificationsServices);

  final NotificationsServices _notificationsServices;

  Future<ApiResult<AppNotificationsPage>> getNotifications({
    required int pageNumber,
    required int pageSize,
  }) async {
    try {
      final response = await _notificationsServices.getNotifications(
        pageNumber,
        pageSize,
      );
      // `data` بيرجع القايمة نفسها، ولو رجع `{items, totalCount}` بنقراه برضه.
      final data = response is Map ? response['data'] : null;
      final rawItems = data is List
          ? data
          : (data is Map ? data['items'] as List? : null) ?? const [];
      final items = rawItems
          .whereType<Map<String, dynamic>>()
          .map(AppNotificationModel.fromJson)
          .toList();
      final totalCount = data is Map ? data['totalCount'] : null;
      return ApiResult.success(
        AppNotificationsPage(
          items: items,
          // من غير `totalCount`: صفحة كاملة معناها إن ممكن يكون فيه بعدها.
          hasMore: totalCount is num
              ? pageNumber * pageSize < totalCount
              : items.length >= pageSize,
        ),
      );
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<int>> getUnreadCount() async {
    try {
      final response = await _notificationsServices.getUnreadCount();
      // `data` ممكن يرجع الرقم نفسه أو `{count}`.
      final data = response is Map ? response['data'] : null;
      final count = data is Map ? data['count'] ?? data['unreadCount'] : data;
      return ApiResult.success(count is num ? count.toInt() : 0);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<bool>> markAsRead(String notificationId) async {
    try {
      await _notificationsServices.markAsRead(notificationId);
      return const ApiResult.success(true);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }
}
