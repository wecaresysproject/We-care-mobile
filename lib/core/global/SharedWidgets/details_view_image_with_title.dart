import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';

class DetailsViewImageWithTitleTile extends StatelessWidget {
  final String image;
  final String title;
  const DetailsViewImageWithTitleTile(
      {super.key, required this.image, required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyles.font16DarkGreyWeight400.copyWith(
            color: AppColorsManager.mainDarkBlue,
          ),
        ),
        verticalSpacing(8),
        Image.asset(image, height: 278.h, width: 343.w),
      ],
    );
  }
}
