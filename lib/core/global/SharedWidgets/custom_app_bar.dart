import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/Helpers/font_weight_helper.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/custom_app_back_arrow.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';

class CustomAppBarWidget extends StatelessWidget {
  const CustomAppBarWidget({super.key, this.haveBackArrow = false});

  final bool haveBackArrow;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        UserAvatarWidget(
          width: 40,
          height: 40,
          borderRadius: 17,
        ),
        horizontalSpacing(8),
        Text(
          context.translate.dummyUserName,
          style: AppTextStyles.font16DarkGreyWeight400.copyWith(
            color: AppColorsManager.textColor,
            fontWeight: FontWeightHelper.medium,
          ),
        ),
        Spacer(),
        haveBackArrow ? CustomBackArrow() : SizedBox.shrink(),
      ],
    );
  }
}

class UserAvatarWidget extends StatelessWidget {
  const UserAvatarWidget({
    super.key,
    required this.width,
    required this.height,
    required this.borderRadius,
  });
  final double width;
  final double height;
  final double borderRadius;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width.w,
      height: height.h,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius.r),
        child: Image.asset(
          "assets/images/user_dummy_photo.png",
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
