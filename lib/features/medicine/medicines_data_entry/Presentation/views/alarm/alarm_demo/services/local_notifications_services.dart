import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:math' show Random;

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// ignore: depend_on_referenced_packages
import 'package:logging/logging.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart';
import 'package:we_care/core/routing/routes.dart';
import 'package:we_care/features/medical_illnesses/data/models/fcm_message_model.dart';

class LocalNotificationService {
  static const _iosCategoryId = 'sample_category';
  static final _log = Logger('Notifications');
  static final _plugin = FlutterLocalNotificationsPlugin();
  static final _initCompleter = Completer<void>();
  static bool _isInitialized = false;

  // For FCM navigation
  static GlobalKey<NavigatorState>? _navigatorKey;

  static void setNavigatorKey(GlobalKey<NavigatorState> navigatorKey) {
    _navigatorKey = navigatorKey;
  }

  static Future<void> init() async {
    if (_isInitialized) {
      log('⚠️ Already initialized, skipping...');
      return;
    }

    log('🚀 === INITIALIZING UNIFIED NOTIFICATIONS ===');

    // Initialize timezone for alarm functionality
    tz.initializeTimeZones();
    setLocalLocation(getLocation('America/New_York'));

    // Request permissions
    await _requestPermissions();
    // await _createNotificationChannels();

    final success = await _plugin.initialize(
      InitializationSettings(
        iOS: DarwinInitializationSettings(
          requestSoundPermission: true,
          requestBadgePermission: true,
          requestAlertPermission: true,
          notificationCategories: [
            DarwinNotificationCategory(
              _iosCategoryId,
              actions: [
                DarwinNotificationAction.plain(
                  'sample_action',
                  'Sample Action',
                  options: {DarwinNotificationActionOption.foreground},
                ),
              ],
              options: {
                DarwinNotificationCategoryOption.hiddenPreviewShowTitle,
                DarwinNotificationCategoryOption.hiddenPreviewShowSubtitle,
                DarwinNotificationCategoryOption.allowAnnouncement,
              },
            ),
          ],
        ),
        android: const AndroidInitializationSettings('@mipmap/ic_launcher'),
      ),
      onDidReceiveNotificationResponse: notificationTapForeground,
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );

    _isInitialized = success ?? false;
    if (_isInitialized) {
      _log.info('✅ Unified notifications initialized successfully');
    } else {
      _log.severe('❌ Failed to initialize notifications');
    }
    _initCompleter.complete();
  }

  @pragma('vm:entry-point')
  static void notificationTapForeground(
      NotificationResponse notificationResponse) {
    _log.info('🎯 notificationTapForeground: $notificationResponse');
    log('🎯 === UNIFIED NOTIFICATION TAP DETECTED ===');
    log('🎯 ID: ${notificationResponse.id}');
    log('🎯 Payload: ${notificationResponse.payload}');
    log('🎯 Response Type: ${notificationResponse.notificationResponseType}');

    _handleNotificationTap(notificationResponse);
  }

  @pragma('vm:entry-point')
  static void notificationTapBackground(
      NotificationResponse notificationResponse) {
    _log.info('🔄 notificationTapBackground: $notificationResponse');
    log('🔄 Background notification tap detected');
    _handleNotificationTap(notificationResponse);
  }

  static void _handleNotificationTap(
      NotificationResponse notificationResponse) {
    try {
      final payload = notificationResponse.payload;
      if (payload == null || payload.isEmpty) {
        log("❌ No payload found in notification");
        return;
      }

      // Check if it's an FCM notification with navigation data
      if (_isFcmNotification(payload)) {
        log("📱 Handling FCM notification");
        _handleFcmNotification(payload);
      } else {
        log("⏰ Handling alarm notification");
        _handleAlarmNotification(payload);
      }
    } catch (e, stack) {
      log("❌ Error handling notification tap: $e");
      log("❌ Stack trace: $stack");
    }
  }

  static bool _isFcmNotification(String payload) {
    try {
      return payload != 'alarm_payload';
    } catch (e) {
      return false;
    }
  }

  static void _handleFcmNotification(String payload) {
    try {
      final Map<String, dynamic> bodyJson = jsonDecode(payload);
      final pageRoute = bodyJson['pageRoute'] as String?;

      if (pageRoute == null) {
        log("❌ No pageRoute found in FCM payload");
        return;
      }

      log("✅ FCM PageRoute: $pageRoute");

      WidgetsBinding.instance.addPostFrameCallback((_) {
        _navigateBasedOnFcmPayload(bodyJson, pageRoute);
      });
    } catch (e, stack) {
      log("❌ Error handling FCM notification: $e");
      log("❌ Stack trace: $stack");
    }
  }

  static void _handleAlarmNotification(String payload) {
    log("⏰ Handling alarm notification with payload: $payload");
    // Add your alarm-specific logic here
    // This could be showing alarm UI, stopping alarm sound, etc.
  }

  static void _navigateBasedOnFcmPayload(
      Map<String, dynamic> bodyJson, String pageRoute) {
    log('🚀 === FCM NAVIGATION ATTEMPT ===');
    log('🚀 Navigator key available: ${_navigatorKey?.currentState != null}');

    if (_navigatorKey?.currentState == null) {
      log("❌ Navigator key is null, cannot navigate");
      return;
    }

    try {
      switch (pageRoute) {
        case Routes.mentalUmbrellaHealthQuestionnairePage:
          final fcmMessage = FcmMessageModel.fromJson(bodyJson);
          log('✅ FCM Message parsed, questions: ${fcmMessage.questions.length}');

          _navigatorKey!.currentState!.pushNamed(
            Routes.mentalUmbrellaHealthQuestionnairePage,
            arguments: {'questions': fcmMessage.questions},
          );
          log('✅ Navigation to questionnaire completed');
          break;

        case Routes.mentalIllnessFollowUpReports:
          _navigatorKey!.currentState!
              .pushNamed(Routes.mentalIllnessFollowUpReports);
          log('✅ Navigation to follow-up reports completed');
          break;

        default:
          log("❌ Unknown FCM pageRoute: $pageRoute");
          break;
      }
    } catch (e, stack) {
      log('❌ FCM Navigation error: $e');
      log('❌ Stack trace: $stack');
    }
  }

  static Future<void> _requestPermissions() async {
    final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
        _plugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    if (androidImplementation != null) {
      final bool? granted =
          await androidImplementation.requestNotificationsPermission();
      log('✅ Android permission granted: $granted');
    }
  }

  static Future<void> _createNotificationChannels() async {
    final AndroidFlutterLocalNotificationsPlugin? androidPlugin =
        _plugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    if (androidPlugin != null) {
      // Channel for FCM notifications
      await androidPlugin.createNotificationChannel(
        const AndroidNotificationChannel(
          'we_care_fcm_channel',
          'We Care FCM Notifications',
          description: 'Important FCM notifications from We Care app',
          importance: Importance.max,
          playSound: true,
          enableVibration: true,
        ),
      );

      // Channel for alarm notifications
      await androidPlugin.createNotificationChannel(
        const AndroidNotificationChannel(
          'sample_channel',
          'Sample Channel',
          description: 'Alarm notifications',
          importance: Importance.max,
          playSound: true,
          enableVibration: true,
        ),
      );

      log('✅ All notification channels created');
    }
  }

  // FCM Notification Display
  static Future<void> showForgroundFcmNotification(
      RemoteMessage message) async {
    await _initCompleter.future;

    log('📱 === SHOWING FCM NOTIFICATION ===');

    final payload = message.data['payload'] as String?;
    if (payload == null || payload.isEmpty) {
      log('❌ No FCM payload available');
      return;
    }

    final int notificationId =
        DateTime.now().millisecondsSinceEpoch.remainder(100000);

    const AndroidNotificationDetails android = AndroidNotificationDetails(
      'we_care_fcm_channel', // Use FCM-specific channel
      'We Care FCM Notifications',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
      autoCancel: true,
      // color: AppColorsManager.mainDarkBlue,
    );

    const NotificationDetails details = NotificationDetails(android: android);

    try {
      await _plugin.show(
        notificationId,
        message.notification?.title ?? 'We Care',
        message.notification?.body ?? 'New message',
        details,
        payload: payload,
      );
      log('✅ FCM notification displayed with ID: $notificationId');
    } catch (e, stack) {
      log('❌ Error showing FCM notification: $e');
      log('❌ Stack trace: $stack');
    }
  }

  // Alarm Package Methods (keep existing functionality)
  Future<void> showNotification() async {
    await _initCompleter.future;

    await _plugin.show(
      _randomId,
      'Alarm Notification',
      'This is an alarm notification.',
      const NotificationDetails(
        iOS: DarwinNotificationDetails(
          badgeNumber: 1,
          categoryIdentifier: _iosCategoryId,
          interruptionLevel: InterruptionLevel.timeSensitive,
        ),
        android: AndroidNotificationDetails('sample_channel', 'Sample Channel'),
      ),
      payload: 'alarm_payload',
    );
    _log.info('Alarm notification shown.');
  }

  // Future<void> scheduleNotification() async {
  //   await _initCompleter.future;

  //   await _plugin.zonedSchedule(
  //     _randomId,
  //     'Scheduled Alarm',
  //     'This is a scheduled alarm notification.',
  //     TZDateTime.now(local).add(const Duration(seconds: 5)),
  //     const NotificationDetails(
  //       iOS: DarwinNotificationDetails(
  //         badgeNumber: 1,
  //         categoryIdentifier: _iosCategoryId,
  //         interruptionLevel: InterruptionLevel.timeSensitive,
  //       ),
  //       android: AndroidNotificationDetails('sample_channel', 'Sample Channel'),
  //     ),
  //     androidScheduleMode: AndroidScheduleMode.exact,
  //     payload: 'scheduled_alarm_payload',
  //   );
  //   _log.info('Alarm notification scheduled.');
  // }

  int get _randomId {
    const min = -0x80000000;
    const max = 0x7FFFFFFF;
    return Random().nextInt(max - min) + min;
  }
}
