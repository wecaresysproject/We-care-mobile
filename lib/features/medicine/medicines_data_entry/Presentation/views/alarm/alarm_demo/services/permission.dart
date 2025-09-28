import 'package:alarm/alarm.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:we_care/core/global/Helpers/app_logger.dart';

class AlarmPermissions {
  static Future<void> checkNotificationPermission() async {
    final status = await Permission.notification.status;
    if (status.isDenied) {
      AppLogger.info('Requesting notification permission...');
      final res = await Permission.notification.request();
      AppLogger.info(
        'Notification permission ${res.isGranted ? '' : 'not '}granted',
      );
    }
  }

  static Future<void> checkAndroidExternalStoragePermission() async {
    final status = await Permission.storage.status;
    if (status.isDenied) {
      AppLogger.info('Requesting external storage permission...');
      final res = await Permission.storage.request();
      AppLogger.info(
        'External storage permission ${res.isGranted ? '' : 'not'} granted',
      );
    }
  }

  static Future<void> checkAndroidScheduleExactAlarmPermission() async {
    if (!Alarm.android) return;
    final status = await Permission.scheduleExactAlarm.status;
    AppLogger.info('Schedule exact alarm permission: $status.');
    if (status.isDenied) {
      AppLogger.info('Requesting schedule exact alarm permission...');
      final res = await Permission.scheduleExactAlarm.request();
      AppLogger.info(
        'Schedule exact alarm permission ${res.isGranted ? '' : 'not'} granted',
      );
    }
  }
}
