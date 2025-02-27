import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/details_view_info_tile.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';

class DetailsViewImageWithTitleTile extends StatelessWidget {
  final String? image;
  final String title;
  const DetailsViewImageWithTitleTile(
      {super.key, required this.image, required this.title});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topRight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.font16DarkGreyWeight400.copyWith(
              color: AppColorsManager.mainDarkBlue,
              fontSize: 18.sp,
            ),
          ),
          verticalSpacing(8),
          image != ""
              ? Image.network(image!, height: 278.h, width: 343.w)
              : CustomContainer(
                  value: 'لم يتم رفع صورة',
                  isExpanded: true,
                ),
        ],
      ),
    );
  }
}
