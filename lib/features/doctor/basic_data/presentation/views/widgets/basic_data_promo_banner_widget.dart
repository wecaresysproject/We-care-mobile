import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/generated/l10n.dart';

class BasicDataPromoBannerWidget extends StatelessWidget {
  const BasicDataPromoBannerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.fromLTRB(4.w, 12.h, 8.w, 12.h),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColorsManager.basicDataBannerGradientStart,
              AppColorsManager.basicDataBannerGradientEnd,
            ],
          ),
          borderRadius: BorderRadius.circular(16.r),
          border:
              Border.all(color: AppColorsManager.basicDataBannerBorderColor),
        ),
        child: Stack(
          children: [
            Positioned(
              left: 0,
              right: 0,
              bottom: 6.h,
              height: 16.h,
              child: SvgPicture.asset(
                'assets/svgs/doctor_illustration_wave_underline.svg',
                fit: BoxFit.fitWidth,
              ),
            ),
            Row(
              textDirection: TextDirection.ltr,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  'assets/svgs/doctor_illustration_calendar_clock.svg',
                  width: 96.w,
                  height: 82.h,
                ),
                Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      S.of(context).manageMedicalWorkEasilyTitle,
                      textAlign: TextAlign.right,
                      style: AppTextStyles.font16MainBlueWeight600.copyWith(
                        color: AppColorsManager.basicDataBannerTitleColor,
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      S.of(context).everythingInOnePlaceSubtitle,
                      textAlign: TextAlign.right,
                      style: AppTextStyles.font12blackWeight400.copyWith(
                        color: AppColorsManager.basicDataBannerSubtitleColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
