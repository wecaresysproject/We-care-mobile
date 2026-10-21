import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/SharedWidgets/bottom_nav_bar.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/core/networking/models/care_context_manager_model.dart';
import 'package:we_care/core/routing/routes.dart';

class GlobalCareContextBanner extends StatelessWidget {
  final Widget child;

  const GlobalCareContextBanner({super.key, required this.child});

  /// "3:05 م" — local time of the access end.
  static String _timeLabel(DateTime time) {
    final local = time.toLocal();
    final hour = local.hour % 12 == 0 ? 12 : local.hour % 12;
    final minute = local.minute.toString().padLeft(2, '0');
    return '$hour:$minute ${local.hour < 12 ? 'ص' : 'م'}';
  }

  void _showExitConfirmation(CareContext activeContext) {
    final context = navigatorKey.currentContext;
    if (context == null) return;
    final isDoctor = activeContext.source == CareAccessSource.doctorBooking;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  isDoctor ? 'إغلاق الملف' : 'إنهاء الرعاية',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColorsManager.mainDarkBlue,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16.h),
                Text(
                  isDoctor
                      ? 'هل تريد إغلاق الملف الطبي للمريض ${activeContext.patientName}؟'
                      : 'أنت حالياً تتصفح الملف الطبي لـ ${activeContext.patientName}. هل تريد العودة إلى ملفك الطبي الشخصي؟',
                  style: TextStyle(
                    fontSize: 14.sp,
                    height: 1.5,
                    color: AppColorsManager.mainDarkBlue.withValues(alpha: 0.8),
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 32.h),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(ctx),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(
                              color: AppColorsManager.mainDarkBlue),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 14.h),
                        ),
                        child: Text(
                          'استمرار',
                          style: TextStyle(
                            color: AppColorsManager.mainDarkBlue,
                            fontWeight: FontWeight.bold,
                            fontSize: 14.sp,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(ctx); // Close the bottom sheet
                          if (isDoctor) {
                            // Back to the call/bookings screen that opened
                            // the file — never reset the stack mid-call.
                            activeContext.onClose?.call(null);
                            return;
                          }
                          CareContextManager.exit();

                          // Navigate back to the home view and clear the stack
                          navigatorKey.currentState?.pushNamedAndRemoveUntil(
                            Routes.bottomNavBar,
                            (route) => false,
                          );

                          // Show success snackbar
                          final scaffoldContext = navigatorKey.currentContext;
                          if (scaffoldContext != null) {
                            // ScaffoldMessenger.of(scaffoldContext).showSnackBar(
                            //   SnackBar(
                            //     content: Text(
                            //       'تمت العودة إلى ملفك الطبي الشخصي',
                            //       style: TextStyle(
                            //         fontFamily: 'Cairo',
                            //         fontSize: 14.sp,
                            //         fontWeight: FontWeight.w600,
                            //       ),
                            //     ),
                            //     backgroundColor: AppColorsManager.doneColor,
                            //     behavior: SnackBarBehavior.floating,
                            //     shape: RoundedRectangleBorder(
                            //       borderRadius: BorderRadius.circular(10.r),
                            //     ),
                            //   ),
                            // );
                            context.showSnackBar(
                              message: 'تمت العودة إلى ملفك الطبي الشخصي',
                              context: scaffoldContext,
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColorsManager.mainDarkBlue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 14.h),
                          elevation: 0,
                        ),
                        child: Text(
                          isDoctor ? 'إغلاق الملف' : 'إنهاء الرعاية',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14.sp,
                          ),
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

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<CareContext?>(
      valueListenable: CareContextManager.activeContextNotifier,
      builder: (context, activeContext, _) {
        if (activeContext == null) {
          return child;
        }
        final isDoctor =
            activeContext.source == CareAccessSource.doctorBooking;

        return Column(
          children: [
            SafeArea(
              bottom: false,
              child: Material(
                color: AppColorsManager.secondaryColor,
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: AppColorsManager.mainDarkBlue
                            .withValues(alpha: 0.2),
                        width: 1,
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        isDoctor ? Icons.visibility_outlined : Icons.person,
                        color: AppColorsManager.mainDarkBlue,
                        size: 20.sp,
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              isDoctor
                                  ? 'أنت تتصفح الملف الطبي للمريض ${activeContext.patientName} — صلاحية عرض فقط'
                                  : 'أنت الآن تتصفح ملف طبي لشخص آخر ',
                              style: TextStyle(
                                color: AppColorsManager.mainDarkBlue,
                                fontWeight: FontWeight.bold,
                                fontSize: 12.sp,
                              ),
                              maxLines: isDoctor ? 2 : 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            if (isDoctor && activeContext.expiresAt != null)
                              Text(
                                'متاح حتى ${_timeLabel(activeContext.expiresAt!)}',
                                style: TextStyle(
                                  color: AppColorsManager.mainDarkBlue
                                      .withValues(alpha: 0.7),
                                  fontSize: 11.sp,
                                ),
                              ),
                          ],
                        ),
                      ),
                      SizedBox(width: 8.w),
                      TextButton(
                        onPressed: () => _showExitConfirmation(activeContext),
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                              horizontal: 8.w, vertical: 4.h),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text(
                          isDoctor ? 'إغلاق الملف' : 'خروج من الرعاية',
                          style: AppTextStyles.font12blackWeight400.copyWith(
                            color: AppColorsManager.mainDarkBlue,
                            fontSize: 13.sp,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                            decorationColor: AppColorsManager.mainDarkBlue,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: MediaQuery.removePadding(
                context: context,
                removeTop: true,
                child: child,
              ),
            ),
          ],
        );
      },
    );
  }
}
