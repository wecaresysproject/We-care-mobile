import 'dart:async';
import 'dart:convert';
import 'dart:math' show Random;

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/app_logger.dart';
import 'package:we_care/core/networking/auth_api_constants.dart';
import 'package:we_care/core/routing/routes.dart';
import 'package:we_care/features/medical_illnesses/data/models/fcm_message_model.dart';

class LocalNotificationService {
  static const _iosCategoryId = 'sample_category';
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
      AppLogger.debug('⚠️ Already initialized, skipping...');
      return;
    }

    AppLogger.debug('🚀 === INITIALIZING UNIFIED NOTIFICATIONS ===');

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
      AppLogger.info('✅ Unified notifications initialized successfully');
    } else {
      AppLogger.error('❌ Failed to initialize unified notifications');
    }
    _initCompleter.complete();
  }

  @pragma('vm:entry-point')
  static void notificationTapForeground(
      NotificationResponse notificationResponse) {
    AppLogger.info('🎯 notificationTapForeground: $notificationResponse');
    AppLogger.debug('🎯 === UNIFIED NOTIFICATION TAP DETECTED ===');
    AppLogger.debug('🎯 ID: ${notificationResponse.id}');
    AppLogger.debug('🎯 Payload: ${notificationResponse.payload}');
    AppLogger.debug(
        '🎯 Response Type: ${notificationResponse.notificationResponseType}');

    _handleNotificationTap(notificationResponse);
  }

  @pragma('vm:entry-point')
  static void notificationTapBackground(
      NotificationResponse notificationResponse) {
    AppLogger.info('🔄 notificationTapBackground: $notificationResponse');
    AppLogger.debug('🔄 Background notification tap detected');
    _handleNotificationTap(notificationResponse);
  }

  static void _handleNotificationTap(
      NotificationResponse notificationResponse) {
    try {
      final payload = notificationResponse.payload;
      if (payload == null || payload.isEmpty) {
        AppLogger.error("❌ No payload found in notification");
        return;
      }

      // Check if it's an FCM notification with navigation data
      if (_isFcmNotification(payload)) {
        AppLogger.debug("📱 Handling FCM notification");
        _handleFcmNotification(payload);
      } else {
        AppLogger.debug("⏰ Handling alarm notification");
        _handleAlarmNotification(payload);
      }
    } catch (e, stack) {
      AppLogger.error("❌ Error handling notification tap: $e");
      AppLogger.error("❌ Stack trace: $stack");
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
        AppLogger.error("❌ No pageRoute found in FCM payload");
        return;
      }

      AppLogger.debug("✅ FCM PageRoute: $pageRoute");

      WidgetsBinding.instance.addPostFrameCallback((_) {
        _navigateBasedOnFcmPayload(bodyJson, pageRoute);
      });
    } catch (e, stack) {
      AppLogger.error("❌ Error handling FCM notification: $e");
      AppLogger.error("❌ Stack trace: $stack");
    }
  }

  static void _handleAlarmNotification(String payload) {
    AppLogger.debug("⏰ Handling alarm notification with payload: $payload");
    // Add your alarm-specific logic here
    // This could be showing alarm UI, stopping alarm sound, etc.
  }

  static void _navigateBasedOnFcmPayload(
      Map<String, dynamic> bodyJson, String pageRoute) {
    //* Patient-only destinations: ignore taps while a doctor is signed in.
    if (currentUserType != UserTypes.patient) return;

    AppLogger.debug('🚀 === FCM NAVIGATION ATTEMPT ===');
    AppLogger.debug(
        '🚀 Navigator key available: ${_navigatorKey?.currentState != null}');

    if (_navigatorKey?.currentState == null) {
      AppLogger.error("❌ Navigator key is null, cannot navigate");
      return;
    }

    try {
      switch (pageRoute) {
        case Routes.mentalUmbrellaHealthQuestionnairePage:
          final fcmMessage = FcmMessageModel.fromJson(bodyJson);
          AppLogger.debug(
              '✅ FCM Message parsed, questions: ${fcmMessage.questions.length}');

          _navigatorKey!.currentState!.pushNamed(
            Routes.mentalUmbrellaHealthQuestionnairePage,
            arguments: {
              'questions': fcmMessage.questions,
              'patchNumber': fcmMessage.patchNumber,
            },
          );
          AppLogger.debug('✅ Navigation to questionnaire completed');
          break;

        case Routes.mentalIllnessFollowUpReports:
          _navigatorKey!.currentState!
              .pushNamed(Routes.mentalIllnessFollowUpReports);
          AppLogger.debug('✅ Navigation to follow-up reports completed');
          break;

        default:
          AppLogger.error("❌ Unknown FCM pageRoute: $pageRoute");
          break;
      }
    } catch (e, stack) {
      AppLogger.error('❌ FCM Navigation error: $e');
      AppLogger.error('❌ Stack trace: $stack');
    }
  }

  static Future<void> _requestPermissions() async {
    final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
        _plugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    if (androidImplementation != null) {
      final bool? granted =
          await androidImplementation.requestNotificationsPermission();
      AppLogger.info('✅ Android permission granted: $granted');
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

      AppLogger.debug('✅ All notification channels created');
    }
  }

  // FCM Notification Display
  static Future<void> showForgroundFcmNotification(
      RemoteMessage message) async {
    await _initCompleter.future;

    AppLogger.debug('📱 === SHOWING FCM NOTIFICATION ===');

    final payload = message.data['payload'] as String?;
    if (payload == null || payload.isEmpty) {
      AppLogger.error('❌ No FCM payload available');
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
      AppLogger.debug('✅ FCM notification displayed with ID: $notificationId');
    } catch (e, stack) {
      AppLogger.error('❌ Error showing FCM notification: $e');
      AppLogger.error('❌ Stack trace: $stack');
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
    AppLogger.info('Alarm notification shown.');
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
