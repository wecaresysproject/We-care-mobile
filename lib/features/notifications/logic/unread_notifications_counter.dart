import 'package:flutter/foundation.dart';
import 'package:we_care/core/di/dependency_injection.dart';
import 'package:we_care/features/notifications/data/repos/notifications_repo.dart';

/// عدد الرسائل غير المقروءة اللى بيظهر على جرس الهوم — بيتحدث لما الهوم
/// يفتح، لما رسالة FCM توصل والتطبيق مفتوح، ولما المستخدم يقرا رسالة.
class UnreadNotificationsCounter {
  UnreadNotificationsCounter._();

  static final ValueNotifier<int> count = ValueNotifier<int>(0);

  static Future<void> refresh() async {
    final result = await getIt<NotificationsRepo>().getUnreadCount();
    result.when(
      success: (unread) => count.value = unread,
      // الجرس بيفضل على آخر عدد معروف لو الطلب فشل.
      failure: (_) {},
    );
  }

  static void decrement() {
    if (count.value > 0) count.value--;
  }
}
