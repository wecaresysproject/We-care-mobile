import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/theming/color_manager.dart';

Future<void> showWarningDialog(
  BuildContext context, {
  String title = "تنبيه",
  required String message,
  String confirmText = "حسناً",
  VoidCallback? onConfirm,
  bool hasDelete = false,
  VoidCallback? onDelete,
}) {
  return showDialog<void>(
    context: context,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        backgroundColor: Colors.white,
        title: Row(
          children: [
            const Icon(Icons.warning_amber_rounded,
                color: Colors.orange, size: 28),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: AppColorsManager.mainDarkBlue,
              ),
            ),
          ],
        ),
        content: Text(
          message,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16.sp, color: Colors.black87),
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: AppColorsManager.mainDarkBlue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  if (onConfirm != null) onConfirm();
                },
                child: Text(
                  confirmText,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
              if (hasDelete)
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 5.w),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1), // soft red background
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: IconButton(
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.red,
                      size: 26,
                    ),
                    tooltip: 'حذف',
                    splashColor: Colors.redAccent.withOpacity(0.2),
                    highlightColor: Colors.redAccent.withOpacity(0.1),
                    onPressed: () {
                      Navigator.of(context).pop();
                      if (onDelete != null) onDelete();
                    },
                  ),
                ),
            ],
          ),
        ],
      );
    },
  );
}
