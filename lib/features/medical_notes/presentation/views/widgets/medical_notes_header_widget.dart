import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';

class MedicalNotesHeaderWidget extends StatelessWidget {
  const MedicalNotesHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Text(
        'ملاحظاتك',
        style: AppTextStyles.font16DarkGreyWeight400.copyWith(
          fontSize: 20.sp,
          fontWeight: FontWeight.bold,
          color: AppColorsManager.mainDarkBlue,
        ),
      ),
    );
  }
}
