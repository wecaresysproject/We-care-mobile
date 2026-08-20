import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:we_care/core/global/Helpers/font_weight_helper.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/app_strings.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/online_doctor/presentation/views/widgets/online_doctor_theme.dart';

/// عنوان قسم فى شاشة "حجز موعد" — شريط بخلفية متدرجة فاتحة،
/// الأيقونة فى أول السطر والعنوان جنبها.
class BookingSectionHeader extends StatelessWidget {
  const BookingSectionHeader({
    super.key,
    required this.title,
    required this.iconAsset,
    this.titleWeight = FontWeightHelper.semiBold,
    this.topPadding = 8,
  });

  final String title;

  /// مسار الأيقونة داخل `assets/svgs`.
  final String iconAsset;

  final FontWeight titleWeight;

  /// أول عنوان فى الشاشة padding أعلاه 6 والباقى 8 — زى التصميم.
  final double topPadding;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsetsDirectional.only(
        start: 8.w,
        end: 14.w,
        top: topPadding.h,
        bottom: 6.h,
      ),
      decoration: BoxDecoration(
        gradient: OnlineDoctorTheme.sectionHeaderGradient,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 18.w,
            height: 18.h,
            child: SvgPicture.asset(iconAsset, fit: BoxFit.contain),
          ),
          horizontalSpacing(6),
          Text(
            title,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: titleWeight,
              fontFamily: AppStrings.cairoFontFamily,
              color: AppColorsManager.mainDarkBlue,
              height: 27 / 18,
            ),
          ),
        ],
      ),
    );
  }
}
