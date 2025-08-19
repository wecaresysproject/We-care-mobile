// import 'dart:async';
// import 'dart:convert';
// import 'dart:developer';

// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:we_care/core/routing/routes.dart';
// import 'package:we_care/features/medical_illnesses/data/models/fcm_message_model.dart';

// class LocalNotificationService {
//   static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();
//   static StreamController<NotificationResponse> streamController =
//       StreamController();

//   // Store the navigator key to handle navigation
//   static GlobalKey<NavigatorState>? _navigatorKey;

//   static void setNavigatorKey(GlobalKey<NavigatorState> navigatorKey) {
//     _navigatorKey = navigatorKey;
//     log('✅ Navigator key set in LocalNotificationService');
//   }

//   // Background notification response handler
//   @pragma('vm:entry-point')
//   static void notificationTapBackground(
//       NotificationResponse notificationResponse) {
//     log('🔄 Background notification tapped - ID: ${notificationResponse.id}');
//     log('🔄 Background notification tapped - Payload: ${notificationResponse.payload}');

//     // Call the same handler for consistency
//     notificationTapForeground(notificationResponse);
//   }

//   // Main notification tap handler - RENAMED TO MATCH YOUR LOG
//   static void notificationTapForeground(
//       NotificationResponse notificationResponse) {
//     log('🎯 === NOTIFICATION TAP DETECTED ===');
//     log('🎯 Notification ID: ${notificationResponse.id}');
//     log('🎯 Payload: ${notificationResponse.payload}');
//     log('🎯 Response Type: ${notificationResponse.notificationResponseType}');
//     log('🎯 Action ID: ${notificationResponse.actionId}');

//     try {
//       final payload = notificationResponse.payload;
//       if (payload == null || payload.isEmpty) {
//         log("❌ No payload found in notification tap");
//         return;
//       }

//       log('✅ Payload found, attempting to parse JSON');
//       final Map<String, dynamic> bodyJson = jsonDecode(payload);
//       final pageRoute = bodyJson['pageRoute'] as String?;

//       if (pageRoute == null) {
//         log("❌ No pageRoute found in payload");
//         return;
//       }

//       log("✅ PageRoute found: $pageRoute");

//       // Navigate based on the pageRoute
//       WidgetsBinding.instance.addPostFrameCallback((_) {
//         log('🔄 PostFrameCallback executed - attempting navigation');
//         _navigateBasedOnPayload(bodyJson, pageRoute);
//       });
//     } catch (e, stack) {
//       log("❌ Error handling notification tap: $e");
//       log("❌ Stack trace: $stack");
//     }
//   }

//   static void _navigateBasedOnPayload(
//       Map<String, dynamic> bodyJson, String pageRoute) {
//     log('🚀 === NAVIGATION ATTEMPT ===');
//     log('🚀 Navigator key null: ${_navigatorKey == null}');
//     log('🚀 Current state null: ${_navigatorKey?.currentState == null}');

//     if (_navigatorKey?.currentState == null) {
//       log("❌ Navigator key is null, cannot navigate");
//       return;
//     }

//     log('✅ Navigator available, proceeding with navigation');

//     try {
//       switch (pageRoute) {
//         case Routes.mentalUmbrellaHealthQuestionnairePage:
//           final fcmMessage = FcmMessageModel.fromJson(bodyJson);
//           log('✅ FCM Message parsed, questions: ${fcmMessage.questions.length}');

//           _navigatorKey!.currentState!.pushNamed(
//             Routes.mentalUmbrellaHealthQuestionnairePage,
//             arguments: {
//               'questions': fcmMessage.questions,
//             },
//           );
//           log('✅ Navigation to questionnaire completed');
//           break;

//         case Routes.mentalIllnessFollowUpReports:
//           _navigatorKey!.currentState!.pushNamed(
//             Routes.mentalIllnessFollowUpReports,
//           );
//           log('✅ Navigation to follow-up reports completed');
//           break;

//         default:
//           log("❌ Unknown pageRoute: $pageRoute");
//           break;
//       }
//     } catch (e, stack) {
//       log('❌ Navigation error: $e');
//       log('❌ Stack trace: $stack');
//     }
//   }

//   static Future<void> init() async {
//     log('🚀 === INITIALIZING LOCAL NOTIFICATIONS ===');

//     // Request permissions first
//     await _requestPermissions();

//     // Create notification channel
//     await _createNotificationChannel();

//     const AndroidInitializationSettings initializationSettingsAndroid =
//         AndroidInitializationSettings('@mipmap/ic_launcher');

//     const DarwinInitializationSettings initializationSettingsDarwin =
//         DarwinInitializationSettings(
//       requestSoundPermission: true,
//       requestBadgePermission: true,
//       requestAlertPermission: true,
//     );

//     const InitializationSettings initializationSettings =
//         InitializationSettings(
//       android: initializationSettingsAndroid,
//       iOS: initializationSettingsDarwin,
//       macOS: initializationSettingsDarwin,
//     );

//     final bool? initialized = await flutterLocalNotificationsPlugin.initialize(
//       initializationSettings,
//       onDidReceiveNotificationResponse: notificationTapForeground,
//       onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
//     );

//     log('✅ Local notifications initialized: $initialized');

//     // Listen to stream for background notifications
//     streamController.stream.listen((NotificationResponse response) {
//       log('🔄 Processing notification from background stream');
//       notificationTapForeground(response);
//     });
//   }

//   static Future<void> _requestPermissions() async {
//     log('🔐 Requesting notification permissions...');

//     // Android 13+ permission request
//     final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
//         flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
//             AndroidFlutterLocalNotificationsPlugin>();

//     if (androidImplementation != null) {
//       final bool? granted =
//           await androidImplementation.requestNotificationsPermission();
//       log('✅ Android notification permission granted: $granted');
//     }

//     // iOS permission request
//     final IOSFlutterLocalNotificationsPlugin? iosImplementation =
//         flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
//             IOSFlutterLocalNotificationsPlugin>();

//     if (iosImplementation != null) {
//       final bool? granted = await iosImplementation.requestPermissions(
//         alert: true,
//         badge: true,
//         sound: true,
//       );
//       log('✅ iOS notification permission granted: $granted');
//     }
//   }

//   static Future<void> _createNotificationChannel() async {
//     log('📢 Creating notification channel...');

//     const AndroidNotificationChannel channel = AndroidNotificationChannel(
//       'we_care_high_importance', // Changed from generic 'channel_id'
//       'We Care Important Notifications',
//       description: 'This channel is used for important We Care notifications.',
//       importance: Importance.max,
//       playSound: true,
//       enableVibration: true,
//     );

//     final AndroidFlutterLocalNotificationsPlugin? androidPlugin =
//         flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
//             AndroidFlutterLocalNotificationsPlugin>();

//     if (androidPlugin != null) {
//       await androidPlugin.createNotificationChannel(channel);
//       log('✅ Notification channel created: ${channel.id}');
//     }
//   }

//   // Enhanced notification display
//   static void showBasicNotification(RemoteMessage message) async {
//     log('📱 === SHOWING LOCAL NOTIFICATION ===');

//     final payload = message.data['payload'] as String?;
//     log('📦 Payload to be attached: $payload');

//     if (payload == null || payload.isEmpty) {
//       log('❌ No payload in FCM message, cannot attach to local notification');
//       return;
//     }

//     // Use timestamp as unique ID to avoid conflicts
//     final int notificationId =
//         DateTime.now().millisecondsSinceEpoch.remainder(100000);

//     const AndroidNotificationDetails android = AndroidNotificationDetails(
//       'we_care_high_importance', // Must match the channel created above
//       'We Care Important Notifications',
//       channelDescription:
//           'This channel is used for important We Care notifications.',
//       importance: Importance.max,
//       priority: Priority.high,
//       playSound: true,
//       enableVibration: true,
//       autoCancel: true,
//       ticker: 'We Care Notification',
//       // color: AppColorsManager.mainDarkBlue,
//     );

//     const DarwinNotificationDetails iOS = DarwinNotificationDetails(
//       presentAlert: true,
//       presentBadge: true,
//       presentSound: true,
//     );

//     const NotificationDetails details = NotificationDetails(
//       android: android,
//       iOS: iOS,
//     );

//     try {
//       await flutterLocalNotificationsPlugin.show(
//         notificationId,
//         message.notification?.title ?? 'We Care Notification',
//         message.notification?.body ?? 'You have a new message',
//         details,
//         payload: payload, // This is crucial!
//       );
//       log('✅ Local notification displayed with ID: $notificationId');
//       log('✅ Payload attached: ${payload.substring(0, 50)}...');
//     } catch (e, stack) {
//       log('❌ Error showing notification: $e');
//       log('❌ Stack trace: $stack');
//     }
//   }

//   // Test method - call this to test if notifications work
//   static Future<void> showTestNotification() async {
//     log('🧪 Showing test notification...');

//     const AndroidNotificationDetails android = AndroidNotificationDetails(
//       'we_care_high_importance',
//       'We Care Important Notifications',
//       channelDescription:
//           'This channel is used for important We Care notifications.',
//       importance: Importance.max,
//       priority: Priority.high,
//       playSound: true,
//       enableVibration: true,
//       autoCancel: true,
//     );

//     const NotificationDetails details = NotificationDetails(android: android);

//     final testPayload = jsonEncode({
//       'pageRoute': Routes.mentalUmbrellaHealthQuestionnairePage,
//       'questions': []
//     });

//     await flutterLocalNotificationsPlugin.show(
//       999,
//       'Test Notification',
//       'Tap me to test navigation!',
//       details,
//       payload: testPayload,
//     );
//   }
// }
