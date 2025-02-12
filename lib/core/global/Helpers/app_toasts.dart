import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:we_care/core/global/theming/color_manager.dart';

Future<void> showError(String error) async {
  await Fluttertoast.cancel();
  await Fluttertoast.showToast(
    msg: error, //TODO: translate error messages after backend meeting later
    backgroundColor: AppColorsManager.warningColor,
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.BOTTOM,
  );
}

Future<void> showSuccess(String message) async {
  await Fluttertoast.cancel();
  await Fluttertoast.showToast(
    backgroundColor: AppColorsManager.doneColor,
    textColor: Colors.white,
    msg: message, //TODO: translate error messages after backend meeting later
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.BOTTOM,
  );
}
