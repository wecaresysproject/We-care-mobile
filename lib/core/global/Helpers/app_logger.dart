import 'dart:developer';

import 'package:flutter/foundation.dart';

enum LogLevel { debug, info, warning, error }

class AppLogger {
  static void logMessage(String message, {LogLevel level = LogLevel.debug}) {
    // منع الطباعة في وضع Release
    if (kReleaseMode) return;

    final prefix = _getPrefix(level);
    log('$prefix $message');
  }

  static void debug(String message) =>
      logMessage(message, level: LogLevel.debug);
  static void info(String message) => logMessage(message, level: LogLevel.info);
  static void warning(String message) =>
      logMessage(message, level: LogLevel.warning);
  static void error(String message) =>
      logMessage(message, level: LogLevel.error);

  static String _getPrefix(LogLevel level) {
    switch (level) {
      case LogLevel.debug:
        return '[DEBUG]';
      case LogLevel.info:
        return '[INFO]';
      case LogLevel.warning:
        return '[WARNING]';
      case LogLevel.error:
        return '[ERROR]';
    }
  }
}
