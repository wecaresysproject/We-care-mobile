import 'package:we_care/core/global/Helpers/app_logger.dart';

/// لوجز فلو مكالمة الفيديو — كلها بـ tag واحد `[VideoCall]` عشان تتفلتر
/// بسهولة فى الـ debug console. مش بتطبع فى الـ release.
class VideoCallLogger {
  static const String _tag = '[VideoCall]';

  static void info(String message) => AppLogger.info('$_tag $message');

  static void warning(String message) => AppLogger.warning('$_tag $message');

  static void error(String message) => AppLogger.error('$_tag $message');
}
