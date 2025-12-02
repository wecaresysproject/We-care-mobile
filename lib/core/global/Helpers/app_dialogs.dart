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
  bool showDietPlan = false,
  VoidCallback? onDelete,
  VoidCallback? onViewPlan, // NEW
}) {
  return showDialog<void>(
    context: context,
    fullscreenDialog: true,
    builder: (context) {
      final screenWidth = MediaQuery.of(context).size.width;

      return AlertDialog(
        insetPadding: EdgeInsets.zero, // مفيش مسافة من الأطراف

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        backgroundColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        titlePadding: EdgeInsets.only(top: 12.h),
        title: Column(
          children: [
            Row(
              children: [
                /// LEFT SIDE — Button if showDietPlan = true
                if (showDietPlan)
                  Expanded(
                    flex: 3,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton(
                        onPressed: () {
                          if (onViewPlan != null) onViewPlan();
                        },
                        child: FittedBox(
                          child: Text(
                            "مشاهدة الخطة",
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                              color: AppColorsManager.mainDarkBlue,
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                else

                  /// If no button, keep same width for alignment balance
                  const Expanded(flex: 3, child: SizedBox()),

                /// CENTER — Warning Icon + Text
                Expanded(
                  flex: 4,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.warning_amber_rounded,
                        color: Colors.orange,
                        size: 22,
                      ),
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
                ),

                /// RIGHT SIDE — Empty space equal to button width for balance
                const Expanded(flex: 3, child: SizedBox()),
              ],
            )
          ],
        ),
        content: SizedBox(
          width: screenWidth * 0.825,
          child: Column(
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
                          style:
                              TextStyle(color: Colors.white, fontSize: 15.sp),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}
