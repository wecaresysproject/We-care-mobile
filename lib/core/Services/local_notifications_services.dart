import 'dart:async';
import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:we_care/core/global/theming/color_manager.dart';

class LocalNotificationService {
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  static StreamController<NotificationResponse> streamController =
      StreamController();
  // @pragma('vm:entry-point')
  // static notificationTapBackground(NotificationResponse notificationResponse) {
  //   LocalNotificationService.onTap(notificationResponse);
  // }

  static onTap(NotificationResponse notificationResponse) {
    // log(notificationResponse.id!.toString());
    // log(notificationResponse.payload!.toString());
    // streamController.add(notificationResponse);
    // Navigator.push(context, route);
    // final payload = notificationResponse.payload;
    // if (payload != null) {
    //   final Map<String, dynamic> bodyJson = jsonDecode(payload);
    //   final fcmMessage = FcmMessageModel.fromJson(bodyJson);

    //   if (fcmMessage.pageRoute ==
    //       Routes.mentalUmbrellaHealthQuestionnairePage) {
    //     navigatorKey.currentState?.pushNamed(
    //       Routes.mentalUmbrellaHealthQuestionnairePage,
    //       arguments: {'questions': fcmMessage.questions},
    //     );
    //   }
    // }

    log('for ground on tap xxx id : ${notificationResponse.id}');
    log('for ground on tap xxx data : ${notificationResponse.payload}');
    log('for ground on tap xxx data payload : ${notificationResponse.data['payload']}');
    log('for ground on tap xxx notification type: ${notificationResponse.notificationResponseType.name}');
  }

  static Future init() async {
    InitializationSettings settings = const InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(),
    );
    flutterLocalNotificationsPlugin.initialize(
      settings,
      onDidReceiveNotificationResponse: onTap,
      onDidReceiveBackgroundNotificationResponse: onTap,
    );
  }

  //basic Notification
  static void showBasicNotification(
    RemoteMessage message,
  ) async {
    AndroidNotificationDetails android = AndroidNotificationDetails(
      'channel_id',
      'channel_name',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      color: AppColorsManager.mainDarkBlue,
      // colorized:

      // sound: RawResourceAndroidNotificationSound(
      //     'long_notification_sound'.split('.').first),
    );
    NotificationDetails details = NotificationDetails(
      android: android,
    );
    await flutterLocalNotificationsPlugin.show(
      0,
      message.notification?.title,
      message.notification?.body,
      details,
    );
  }
}
