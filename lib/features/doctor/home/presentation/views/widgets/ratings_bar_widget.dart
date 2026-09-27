import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/generated/l10n.dart';

class RatingsBarWidget extends StatelessWidget {
  const RatingsBarWidget({super.key, required this.ratingsCount});

  final int ratingsCount;

  @override
  Widget build(BuildContext context) {
    final star = SvgPicture.asset(
      'assets/svgs/doctor_icon_star.svg',
      width: 20.w,
      height: 22.h,
    );

    return Align(
      alignment: AlignmentDirectional.centerEnd,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 4.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.r),
          gradient: LinearGradient(
            colors: [
              AppColorsManager.ratingsBarGradientStart,
              AppColorsManager.ratingsBarGradientEnd,
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.25),
              offset: const Offset(0, 2),
              blurRadius: 1.5,
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(mainAxisSize: MainAxisSize.min, children: [star, star, star]),
            SizedBox(width: 20.w),
            Text('$ratingsCount', style: AppTextStyles.font18MainBlueWeight500),
            SizedBox(width: 20.w),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  S.of(context).ratersLabel,
                  style: AppTextStyles.font18MainBlueWeight500,
                ),
                SizedBox(width: 6.w),
                star,
              ],
            ),
          ],
        ),
      ),
    );
  }
}
