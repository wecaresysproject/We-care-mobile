import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';

/// The leading icon-badge + title header shared by every numbered section
/// of the Booking Settings form, with a small step-number circle trailing
/// the title (e.g. "1" for "Daily Bookings").
class BookingSettingsSectionHeaderWidget extends StatelessWidget {
  const BookingSettingsSectionHeaderWidget({
    super.key,
    required this.icon,
    required this.title,
    required this.stepNumber,
    required this.badgeBackgroundColor,
    required this.badgeIconColor,
  });

  final IconData icon;
  final String title;
  final int stepNumber;
  final Color badgeBackgroundColor;
  final Color badgeIconColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 22.w,
          height: 22.w,
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            color: AppColorsManager.mainDarkBlue,
            shape: BoxShape.circle,
          ),
          child: Text(
            '$stepNumber',
            style: AppTextStyles.font12WhiteWeight700,
          ),
        ),
        horizontalSpacing(8),
        Expanded(
          child: Text(
            title,
            style: AppTextStyles.font18blackWight500,
          ),
        ),
        horizontalSpacing(8),
        Container(
          width: 32.w,
          height: 32.w,
          decoration: BoxDecoration(
            color: badgeBackgroundColor,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 18.r, color: badgeIconColor),
        ),
      ],
    );
  }
}
