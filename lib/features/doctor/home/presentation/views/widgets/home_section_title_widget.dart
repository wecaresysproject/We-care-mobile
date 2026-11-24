import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';

/// A home section title ("حجوزات اليوم" / "الكشوفات الشهرية"): centered
/// text with a calendar icon and a short divider line on each side.
class HomeSectionTitleWidget extends StatelessWidget {
  const HomeSectionTitleWidget({
    super.key,
    required this.title,
    this.iconAssetPath = 'assets/svgs/doctor_icon_allowed_bookings.svg',
    this.fontSize = 16,
    this.iconSize = 20,
  });

  final String title;
  final String iconAssetPath;
  final double fontSize;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const _SideLine(),
        horizontalSpacing(10),
        Text(
          title,
          maxLines: 1,
          style: AppTextStyles.font22homeHeadingWeight700.copyWith(
            fontSize: fontSize.sp,
          ),
        ),
        horizontalSpacing(8),
        SvgPicture.asset(
          iconAssetPath,
          width: iconSize.w,
          height: iconSize.w,
          colorFilter: ColorFilter.mode(
            AppColorsManager.homePrimaryBlue,
            BlendMode.srcIn,
          ),
        ),
        horizontalSpacing(10),
        const _SideLine(),
      ],
    );
  }
}

class _SideLine extends StatelessWidget {
  const _SideLine();

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Container(
        height: 1,
        constraints: BoxConstraints(maxWidth: 46.w),
        color: AppColorsManager.homeDividerColor,
      ),
    );
  }
}
