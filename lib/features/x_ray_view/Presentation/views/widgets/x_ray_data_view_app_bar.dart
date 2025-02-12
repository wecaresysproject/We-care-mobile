import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/custom_app_back_arrow.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';

import '../../../../../core/global/theming/color_manager.dart';

class XRayDataViewAppBar extends StatelessWidget {
  const XRayDataViewAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 16.h, bottom: 24.h),
      child: Row(
        children: [
          CustomBackArrow(),
          horizontalSpacing(50),
          CustomSearchBar(),
        ],
      ),
    );
  }
}

class CustomSearchBar extends StatelessWidget {
  const CustomSearchBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SizedBox(
        height: 40.h,
        width: 250.w,
        child: TextField(
          textAlign: isArabic() ? TextAlign.right : TextAlign.left,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 12.h),
            hintText: 'بحث',
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
      ),
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
