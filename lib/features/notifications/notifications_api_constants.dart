class NotificationsApiConstants {
  static const baseUrl = "http://147.93.57.70/api";

  /// رسائل المستخدم الحالى، الأحدث الأول — `?pageNumber=&pageSize=`.
  static const getNotifications = "/Notifications";

  /// عدد الرسائل غير المقروءة — من غير parameters.
  static const getUnreadCount = "/Notifications/unread-count";

  /// تعليم رسالة كمقروءة — `PUT` و`{id}` فى المسار.
  static const markAsRead = "/Notifications/{id}/read";
}
