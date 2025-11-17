import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/di/dependency_injection.dart';
import 'package:we_care/core/global/Helpers/custom_rich_text.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/Helpers/font_weight_helper.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/custom_app_bar.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/essential_info/essential_info_view/logic/%20essential_info_view_cubit.dart';
import 'package:we_care/features/essential_info/essential_info_view/logic/essential_info_view_state.dart';

class HomeCustomAppBarWidget extends StatelessWidget {
  const HomeCustomAppBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BlocProvider<EssentialInfoViewCubit>(
          create: (context) =>
              getIt<EssentialInfoViewCubit>()..getUserEssentialInfo(),
          child: BlocBuilder<EssentialInfoViewCubit, EssentialInfoViewState>(
            builder: (context, state) {
              final displayName =
                  (state.userEssentialInfo?.fullName ?? 'user name')
                      .firstAndLastName;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  UserAvatarWidget(
                    height: 47,
                    width: 46,
                    borderRadius: 48,
                    userImageUrl: state.userEssentialInfo?.personalPhotoUrl,
                  ),
                  Text(
                    displayName,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.font16DarkGreyWeight400.copyWith(
                      color: AppColorsManager.textColor,
                      fontWeight: FontWeightHelper.medium,
                      fontSize: 11.sp,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        horizontalSpacing(8),
        Expanded(
          child: Column(
            crossAxisAlignment:
                isArabic() ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                textAlign: isArabic() ? TextAlign.right : TextAlign.left,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 12.h),
                  hintText: context.translate.search_text,
                  hintStyle: AppTextStyles.font16DarkGreyWeight400.copyWith(
                    color: AppColorsManager.textColor,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.r),
                    borderSide: BorderSide(
                      color: AppColorsManager.placeHolderColor.withAlpha(150),
                      width: 1.3,
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.r),
                    borderSide: BorderSide(
                      color: AppColorsManager.placeHolderColor.withAlpha(150),
                      width: 1.3, // Same thickness
                    ),
                  ),
                  suffixIcon: buildCustomSearchIcon(),
                ),
              ),
              CustomUnderlinedRichTextWidget(
                normalText: "",
                highlightedText: context.translate.search_text,
                textStyle: AppTextStyles.font18blackWight500.copyWith(
                  fontSize: 12.sp,
                ),
                onTap: () {},
              )
            ],
          ),
        ),
        horizontalSpacing(8),
        CircleAvatar(
          radius: 39.r,
          backgroundImage: AssetImage(
            "assets/images/we_care_logo.png",
          ),
        ),
      ],
    );
  }
}

Widget buildCustomSearchIcon() {
  return Container(
    padding: EdgeInsets.all(10),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.only(
        bottomLeft: isArabic() ? Radius.circular(16.r) : Radius.zero,
        topLeft: isArabic() ? Radius.circular(16.r) : Radius.zero,
        topRight: isArabic() ? Radius.zero : Radius.circular(16.r),
        bottomRight: isArabic() ? Radius.zero : Radius.circular(16.r),
      ),
      color: AppColorsManager.mainDarkBlue,
    ),
    child: Image.asset(
      "assets/images/search_icon.png",
      width: 12.w,
      height: 12.h,
      cacheHeight: 1000,
      cacheWidth: 1000,
    ),
  );
}
