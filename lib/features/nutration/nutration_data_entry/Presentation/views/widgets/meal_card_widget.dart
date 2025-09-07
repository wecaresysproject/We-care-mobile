import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';

class MealCard extends StatelessWidget {
  final String day;
  final bool isEmpty;
  final bool haveAdocument;

  const MealCard({
    super.key,
    required this.day,
    required this.isEmpty,
    this.haveAdocument = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      padding: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Color(0xffF1F3F6),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          width: 1,
          color: AppColorsManager.placeHolderColor,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            day,
            style: AppTextStyles.font16DarkGreyWeight400.copyWith(
              color: AppColorsManager.mainDarkBlue,
              // fontWeight: FontWeight.w700,
            ),
          ),
          verticalSpacing(8),
          Text(
            '--/--/----',
            style: AppTextStyles.font16DarkGreyWeight400.copyWith(
              color: AppColorsManager.mainDarkBlue,
            ),
          ),
          verticalSpacing(6),
          haveAdocument
              ? Container(
                  width: 69.w,

                  // margin: EdgeInsets.only(bottom: 6.h),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColorsManager.mainDarkBlue,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.file_present,
                        color: Colors.white,
                        size: 20,
                      ),
                      horizontalSpacing(4),
                      Text(
                        'التقرير',
                        style: AppTextStyles.font12blackWeight400.copyWith(
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                )
              : SizedBox.shrink(),
        ],
      ),
    );
  }
}
