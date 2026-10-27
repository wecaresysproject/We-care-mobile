import 'package:flutter/material.dart';
import 'package:we_care/core/di/dependency_injection.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/app_logger.dart';
import 'package:we_care/core/networking/auth_api_constants.dart';
import 'package:we_care/core/routing/routes.dart';
import 'package:we_care/features/medical_illnesses/data/models/fcm_message_model.dart';
import 'package:we_care/features/notifications/data/models/app_notification_model.dart';
import 'package:we_care/features/notifications/data/repos/notifications_repo.dart';
import 'package:we_care/features/notifications/logic/unread_notifications_counter.dart';
import 'package:we_care/features/online_doctor/presentation/consultation_call_launcher.dart';

/// بيفتح الشاشة المناسبة لما المستخدم يضغط على إشعار FCM — مشترك بين
/// إشعارات النظام (`PushNotificationsService`) وإشعارات التطبيق وهو مفتوح
/// (`LocalNotificationService`). التوجيه حسب `pageRoute` فى الـ payload.
class FcmNotificationRouter {
  FcmNotificationRouter._();

  static void navigate(NavigatorState navigator, Map<String, dynamic> payload) {
    //* Patient-only destinations: ignore taps while a doctor is signed in.
    if (currentUserType != UserTypes.patient) return;

    final pageRoute = payload['pageRoute'] as String?;
    AppLogger.info("FCM tap → pageRoute: $pageRoute");

    switch (pageRoute) {
      case Routes.mentalUmbrellaHealthQuestionnairePage:
        final fcmMessage = FcmMessageModel.fromJson(payload);
        navigator.pushNamed(
          Routes.mentalUmbrellaHealthQuestionnairePage,
          arguments: {
            'questions': fcmMessage.questions,
            'patchNumber': fcmMessage.patchNumber,
          },
        );

      case Routes.mentalIllnessFollowUpReports:
        navigator.pushNamed(Routes.mentalIllnessFollowUpReports);

      // الإشعار بيفتح تفاصيل الدعوة على طول من بياناته، وبيتعلم مقروء.
      case final route
          when route == AppNotificationType.meetingParticipantAdded.name:
        _openInvitation(navigator, payload);

      case final route
          when route == AppNotificationType.consultationStarted.name:
        ConsultationCallLauncher.open(
          navigator,
          appointmentId: payload['appointmentId']?.toString() ?? '',
        );

      default:
        AppLogger.error("Unknown FCM pageRoute: $pageRoute");
    }
  }

  static void _openInvitation(
    NavigatorState navigator,
    Map<String, dynamic> payload,
  ) {
    final notification = AppNotificationModel.fromJson({
      ...payload,
      'id': payload['notificationId'] ?? payload['id'],
      'type': AppNotificationType.meetingParticipantAdded.name,
      'isRead': false,
    });
    if (!notification.isMeetingInvitation) {
      navigator.pushNamed(Routes.notificationsScreen);
      return;
    }
    navigator.pushNamed(
      Routes.meetingInvitationDetailsView,
      arguments: notification,
    );
    if (notification.id.isNotEmpty) {
      getIt<NotificationsRepo>()
          .markAsRead(notification.id)
          .then((_) => UnreadNotificationsCounter.refresh());
    }
  }
}
