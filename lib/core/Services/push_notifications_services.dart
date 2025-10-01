import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:we_care/core/global/Helpers/app_logger.dart';
import 'package:we_care/core/routing/routes.dart';
import 'package:we_care/features/medical_illnesses/data/models/fcm_message_model.dart';
import 'package:we_care/features/medicine/medicines_data_entry/Presentation/views/alarm/alarm_demo/services/local_notifications_services.dart';
import 'package:we_care/firebase_options.dart';

class PushNotificationsService {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  static Future<void> init(GlobalKey<NavigatorState> navigatorKey) async {
    await _messaging.requestPermission();
    // await getAndAppLogger.infoToken();
    // final token = await _messaging.getToken();
    // AppLogger.info('FCM Token: $token');
    // Set the navigator key in LocalNotificationService
    // await LocalNotificationService.init();
    LocalNotificationService.setNavigatorKey(navigatorKey);

    //!when the app is in the background or terminated.
    FirebaseMessaging.onBackgroundMessage(_handleBackgroundMessage);
    _handleForegroundNotifications(navigatorKey);
    _handleNotificationTap(navigatorKey);
  }

  Future<String> getAndLogToken() async {
    final token = await _messaging.getToken();
    AppLogger.info('FCM Token: $token');
    return token ?? '';
  }

  @pragma('vm:entry-point') // 👈 ADD THIS LINE
  static Future<void> _handleBackgroundMessage(RemoteMessage message) async {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);

    AppLogger.info(
        'Background message received: ${message.notification?.title ?? 'No title'}');
  }

  static void _handleForegroundNotifications(
      GlobalKey<NavigatorState> navigatorKey) {
    FirebaseMessaging.onMessage.listen(
      (RemoteMessage message) {
        AppLogger.info(
            "Foreground notification message.notification?.title: ${message.notification?.title}");
        AppLogger.info(
            "Foreground notification message.notification?.body}: ${message.notification?.body}");
        AppLogger.info(
            "Foreground notification message.notification?.android: ${message.notification?.android}");
        AppLogger.info(
            "Foreground notification message.data.toString: ${message.data.toString()}");
        AppLogger.info(
            "Foreground notification message.data['questions']: ${message.data['questions']}");
        AppLogger.info(
            "Foreground notification message.data['pageRoute']: ${message.data['pageRoute']}");
        if (message.notification != null) {
          LocalNotificationService.showForgroundFcmNotification(message);

          // _navigateBasedOnNotification(navigatorKey, message);
        }
      },
    );
  }

  static void _handleNotificationTap(GlobalKey<NavigatorState> navigatorKey) {
    // Handle notification taps when the app is in the background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      AppLogger.info(
          " onMessageOpenedApp Notification tapped in background: ${message.data} ");
      _navigateBasedOnNotification(navigatorKey, message);
    });
    // Handle notification taps when the app is in the terminated state
    _messaging.getInitialMessage().then(
      (message) {
        // Check after first frame
        WidgetsBinding.instance.addPostFrameCallback(
          (_) {
            if (message != null) {
              _navigateBasedOnNotification(navigatorKey, message);
            }
          },
        );
      },
    );
  }

  static void _navigateBasedOnNotification(
    GlobalKey<NavigatorState> navigatorKey,
    RemoteMessage message,
  ) {
    try {
      final msgPayload = message.data['payload'] as String?;
      if (msgPayload == null) {
        AppLogger.error("No payload found in notification");
        return;
      }

      final Map<String, dynamic> bodyJson = jsonDecode(msgPayload);

      final pageRoute = bodyJson['pageRoute'] as String?;
      if (pageRoute == null) {
        AppLogger.error("No pageRoute found in payload");
        return;
      }

      AppLogger.info("Received notification for pageRoute: $pageRoute");

      WidgetsBinding.instance.addPostFrameCallback((_) {
        switch (pageRoute) {
          case Routes.mentalUmbrellaHealthQuestionnairePage:
            final fcmMessage = FcmMessageModel.fromJson(bodyJson);
            AppLogger.info(
              'FCM Questions:\n${fcmMessage.questions.map((q) => q.toJson().toString()).join('\n')}',
            );
            navigatorKey.currentState?.pushNamed(
              Routes.mentalUmbrellaHealthQuestionnairePage,
              arguments: {'questions': fcmMessage.questions},
            );

            break;

          case Routes.mentalIllnessFollowUpReports: // مثال لصفحة أخرى
            navigatorKey.currentState?.pushNamed(
              Routes.mentalIllnessFollowUpReports,
            );
            break;

          default:
            AppLogger.error("Unknown pageRoute: $pageRoute");
            break;
        }
      });
    } catch (e, stack) {
      AppLogger.error("Error navigating from notification: $e");
      AppLogger.error(stack.toString());
    }
  }

  static void sendTokenToServer(String token) {
    // Implement API call to send token to your backend if needed
  }
}
