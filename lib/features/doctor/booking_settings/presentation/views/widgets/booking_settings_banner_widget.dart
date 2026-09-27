import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/generated/l10n.dart';

/// The page-header banner at the top of the Booking Settings screen: a
/// title + subtitle on the leading side, the calendar illustration on the
/// trailing side.
class BookingSettingsBannerWidget extends StatelessWidget {
  const BookingSettingsBannerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final localization = S.of(context);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColorsManager.basicDataScaffoldBackground,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  localization.bookingSettingsAction,
                  style: AppTextStyles.font20blackWeight700
                      .copyWith(color: AppColorsManager.mainDarkBlue),
                ),
                verticalSpacing(6),
                Text(
                  localization.bookingSettingsFormBannerSubtitle,
                  style: AppTextStyles.font13GreyWeight400,
                ),
              ],
            ),
          ),
          horizontalSpacing(12),
          Container(
            width: 56.w,
            height: 56.w,
            decoration: BoxDecoration(
              color: AppColorsManager.basicDataGreenBadgeBackground,
              borderRadius: BorderRadius.circular(16.r),
            ),
            padding: EdgeInsets.all(12.w),
            child: SvgPicture.asset(
              'assets/svgs/doctor_illustration_calendar_clock.svg',
            ),
          ),
        ],
      ),
    );
  }
}
