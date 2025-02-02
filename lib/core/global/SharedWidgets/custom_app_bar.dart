import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/Helpers/font_weight_helper.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/custom_app_back_arrow.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';

class CustomAppBarWidget extends StatelessWidget {
  const CustomAppBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildUserAvatar(),
        horizontalSpacing(8),
        Text(
          context.translate.dummyUserName,
          style: AppTextStyles.font16DarkGreyWeight400.copyWith(
            color: AppColorsManager.textColor,
            fontWeight: FontWeightHelper.medium,
          ),
        ),
        Spacer(),
        CustomAppBackArrow(),
      ],
    );
  }
}

/// 🔹 Creates a user avatar that matches the back arrow button
Widget _buildUserAvatar() {
  return SizedBox(
    width: 40.w,
    height: 40.h,
    child: ClipRRect(
      borderRadius: BorderRadius.circular(17.r),
      child: Image.asset(
        "assets/images/user_dummy_photo.png",
        fit: BoxFit.cover,
      ),
    ),
  );
}
