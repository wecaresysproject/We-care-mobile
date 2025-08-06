import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:we_care/core/Services/local_notifications_services.dart';
import 'package:we_care/core/routing/routes.dart';
import 'package:we_care/firebase_options.dart';

class PushNotificationsService {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  static Future<void> init(GlobalKey<NavigatorState> navigatorKey) async {
    await _messaging.requestPermission();
    await _getAndLogToken();
    //!when the app is in the background or terminated.
    FirebaseMessaging.onBackgroundMessage(_handleBackgroundMessage);
    _handleForegroundNotifications(navigatorKey);
    _handleNotificationTap(navigatorKey);
  }

  static Future<String> _getAndLogToken() async {
    final token = await _messaging.getToken();
    log('FCM Token: $token');
    return token ?? '';
  }

  static Future<void> _handleBackgroundMessage(RemoteMessage message) async {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);

    log('Background message received: ${message.notification?.title ?? 'No title'}');
  }

  static void _handleForegroundNotifications(
      GlobalKey<NavigatorState> navigatorKey) {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      log("Foreground notification: ${message.notification?.title}");
      if (message.notification != null) {
        LocalNotificationService.showBasicNotification(message);
        // _navigateBasedOnNotification(navigatorKey, message);
      }
    });
  }

  static void _handleNotificationTap(GlobalKey<NavigatorState> navigatorKey) {
    // Handle notification taps when the app is in the background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      log(" onMessageOpenedApp Notification tapped in background: ${message.data} ");
      _navigateBasedOnNotification(navigatorKey, message);
    });
    // Handle notification taps when the app is in the terminated state
    _messaging.getInitialMessage().then((message) {
      if (message != null) {
        log("Notification tapped from terminated state: ${message.data}");
        _navigateBasedOnNotification(navigatorKey, message);
      }
    });
  }

  static void _navigateBasedOnNotification(
      GlobalKey<NavigatorState> navigatorKey, RemoteMessage message) {
    //! Add check here according to route name comes from message.data , navigate to needed screen
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        navigatorKey.currentState
            ?.pushNamed(Routes.mentalUmbrellaHealthQuestionnairePage);
      },
    );
  }

  static void sendTokenToServer(String token) {
    // Implement API call to send token to your backend if needed
  }
}
