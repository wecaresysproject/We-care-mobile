import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
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
    fullscreenDialog: true,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        backgroundColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        titlePadding: EdgeInsets.only(top: 12.h),
        title: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.warning_amber_rounded,
                    color: Colors.orange, size: 22),
                SizedBox(width: 6.w),
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
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTextStyles.font20blackWeight600.copyWith(
                // fontSize: 16.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: 20.h),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColorsManager.mainDarkBlue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 10.h),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                      if (onConfirm != null) onConfirm();
                    },
                    child: Text(
                      confirmText,
                      style: TextStyle(color: Colors.white, fontSize: 15.sp),
                    ),
                  ),
                ),
                if (hasDelete) SizedBox(width: 30.w),
                if (hasDelete)
                  Expanded(
                    flex: 1,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.shade700,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 8.h),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                        if (onDelete != null) onDelete();
                      },
                      icon: const Icon(Icons.delete, color: Colors.white),
                      label: Text(
                        "حذف",
                        style: TextStyle(color: Colors.white, fontSize: 15.sp),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      );
    },
  );
}
