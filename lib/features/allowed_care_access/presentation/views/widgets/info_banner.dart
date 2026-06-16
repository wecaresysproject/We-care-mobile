import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';

/// A reusable information banner used across the Allowed Care Access flow.
///
/// Displays a leading info icon followed by the provided [text]. The banner
/// has a subtle background colour, rounded corners and padding that matches the
/// app's design system. It is RTL‑aware because the surrounding screen sets
/// `Directionality(textDirection: TextDirection.rtl)`.
class InfoBanner extends StatelessWidget {
  /// The message to show inside the banner.
  final String text;

  /// Optional background colour – defaults to a light blue‑tint that aligns
  /// with the medical theme of the app.
  final Color backgroundColor;

  /// Optional icon colour – defaults to the primary dark blue from the colour
  /// manager.
  final Color iconColor;

  const InfoBanner({
    super.key,
    required this.text,
    this.backgroundColor = const Color(0xFFE3F2FD), // Light blue background
    this.iconColor = AppColorsManager.mainDarkBlue,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12.r),
        // Subtle shadow for depth, matching other cards.
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 4.r,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(Icons.info_outline, color: iconColor, size: 20.sp),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.font14blackWeight400.copyWith(
                color: Colors.black87,
                fontSize: 14.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
