import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/Helpers/font_weight_helper.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/custom_app_back_arrow.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';

class CustomAppBarWidget extends StatelessWidget {
  const CustomAppBarWidget(
      {super.key, this.haveBackArrow = false, this.onNavigateToBack});

  final bool haveBackArrow;
  final void Function()? onNavigateToBack;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        haveBackArrow
            ? CustomBackArrow(
                onTap: onNavigateToBack,
              )
            : SizedBox.shrink(),
        Spacer(),
        Text(
          context.translate.dummyUserName,
          style: AppTextStyles.font16DarkGreyWeight400.copyWith(
            color: AppColorsManager.textColor,
            fontWeight: FontWeightHelper.medium,
          ),
        ),
        horizontalSpacing(8),
        UserAvatarWidget(
          width: 40,
          height: 40,
          borderRadius: 17,
        ),
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
     this.userImageUrl,
  });
  final double width;
  final double height;
  final double borderRadius;
  final String? userImageUrl;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width.w,
      height: height.h,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius.r),
        child: CachedNetworkImage(
            placeholder: (context, url) => const CircularProgressIndicator(),
            errorWidget: (context, url, error) =>
                Image.asset('assets/images/user_avatar.png', fit: BoxFit.cover),
          imageUrl: userImageUrl ?? "", fit: BoxFit.cover),
      ),
    );
  }
}
