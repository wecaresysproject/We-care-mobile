import 'dart:convert';
import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:we_care/core/Services/local_notifications_services.dart';
import 'package:we_care/core/routing/routes.dart';
import 'package:we_care/features/medical_illnesses/data/models/fcm_message_model.dart';
import 'package:we_care/firebase_options.dart';

class PushNotificationsService {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  static Future<void> init(GlobalKey<NavigatorState> navigatorKey) async {
    await _messaging.requestPermission();
    // await getAndLogToken();
    //!when the app is in the background or terminated.
    FirebaseMessaging.onBackgroundMessage(_handleBackgroundMessage);
    _handleForegroundNotifications(navigatorKey);
    _handleNotificationTap(navigatorKey);
  }

  Future<String> getAndLogToken() async {
    final token = await _messaging.getToken();
    log('FCM Token: $token');
    return token ?? '';
  }

  @pragma('vm:entry-point') // 👈 ADD THIS LINE
  static Future<void> _handleBackgroundMessage(RemoteMessage message) async {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);

    log('Background message received: ${message.notification?.title ?? 'No title'}');
  }

  static void _handleForegroundNotifications(
      GlobalKey<NavigatorState> navigatorKey) {
    FirebaseMessaging.onMessage.listen(
      (RemoteMessage message) {
        log("Foreground notification message.notification?.title: ${message.notification?.title}");
        log("Foreground notification message.notification?.body}: ${message.notification?.body}");
        log("Foreground notification message.notification?.android: ${message.notification?.android}");
        log("Foreground notification message.data.toString: ${message.data.toString()}");
        log("Foreground notification message.data['questions']: ${message.data['questions']}");
        log("Foreground notification message.data['pageRoute']: ${message.data['pageRoute']}");
        if (message.notification != null) {
          LocalNotificationService.showBasicNotification(message);
          // _navigateBasedOnNotification(navigatorKey, message);
        }
      },
    );
  }

  static void _handleNotificationTap(GlobalKey<NavigatorState> navigatorKey) {
    // Handle notification taps when the app is in the background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      log(" onMessageOpenedApp Notification tapped in background: ${message.data} ");
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
      FcmMessageModel? fcmMessage;
      if (msgPayload != null) {
        final Map<String, dynamic> bodyJson = jsonDecode(msgPayload);
        // نحول الـ data لـ model مباشرة
        fcmMessage = FcmMessageModel.fromJson(bodyJson);
        log(
          'FCM Message questions seperated by one line : ${fcmMessage.questions.map((question) => question.toJson().toString()).join('\n')}',
        );
      }

      WidgetsBinding.instance.addPostFrameCallback(
        (_) {
          if (fcmMessage!.pageRoute ==
              Routes.mentalUmbrellaHealthQuestionnairePage) {
            navigatorKey.currentState?.pushNamed(
              Routes.mentalUmbrellaHealthQuestionnairePage,
              arguments: {
                'questions': fcmMessage.questions,
              },
            );
          } else {
            log("Unknown pageRoute: ${fcmMessage.pageRoute}");
          }
        },
      );
    } catch (e, stack) {
      log("Error navigating from notification: $e");
      log(stack.toString());
    }
  }

  static void sendTokenToServer(String token) {
    // Implement API call to send token to your backend if needed
  }
}
