import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';

class AllowedCareAccessHeader extends StatelessWidget {
  const AllowedCareAccessHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          padding: EdgeInsets.zero,
          icon: Icon(
            Icons.arrow_back_ios,
            color: AppColorsManager.mainDarkBlue,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'قائمة المسموح بالرعاية',
              style: AppTextStyles.font22MainBlueWeight700.copyWith(
                color: AppColorsManager.mainDarkBlue,
                fontSize: 16.sp,
              ),
            ),
            Text(
              'الوصول المأذون لملفاتهم الطبية',
              style: AppTextStyles.font14blackWeight400.copyWith(
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
