import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/doctor/bookings/presentation/views/widgets/patients_count_badge_widget.dart';

/// Section title + patients-count badge, rendered above (not inside) the
/// section's card.
class BookingsSectionHeaderWidget extends StatelessWidget {
  const BookingsSectionHeaderWidget({
    super.key,
    required this.title,
    required this.titleIcon,
    required this.patientsCount,
    required this.countBackgroundColor,
    required this.countTextColor,
  });

  final String title;
  final IconData titleIcon;
  final int patientsCount;
  final Color countBackgroundColor;
  final Color countTextColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        PatientsCountBadgeWidget(
          count: patientsCount,
          backgroundColor: countBackgroundColor,
          textColor: countTextColor,
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(title, style: AppTextStyles.font16MainBlueWeight600),
            SizedBox(width: 6.w),
            Icon(titleIcon, size: 20.r, color: AppColorsManager.mainDarkBlue),
          ],
        ),
      ],
    );
  }
}
