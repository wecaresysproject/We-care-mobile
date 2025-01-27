import 'dart:async';

import 'package:flutter/material.dart';

class Debouncer {
  Debouncer({required this.milliseconds});
  final int milliseconds;
  VoidCallback? _action;
  Timer? _timer;
  void call(VoidCallback action) {
// Let the latest action override whatever was there before
    _action = action;
// Always cancel and restart the timer
    _timer?.cancel();
    _timer = Timer(
      Duration(
        milliseconds: milliseconds,
      ),
      _callAction,
    );
  }

  void _callAction() {
    _action?.call(); // If we have an action queued up, complete
    _timer = null;
  }

  void reset() {
    _action = null;
    _timer = null;
  }
}
