import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/custom_app_back_arrow.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';

class ViewAppBar extends StatelessWidget {
  final Function(String)? onSearchChanged;
  final Function(String)? onSearchSubmitted;
  final VoidCallback? onSearchCleared;
  final TextEditingController? controller;

  const ViewAppBar({
    super.key,
    this.controller,
    this.onSearchChanged,
    this.onSearchSubmitted,
    this.onSearchCleared,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 16.h, bottom: 24.h),
      child: Row(
        children: [
          CustomBackArrow(),
          horizontalSpacing(50),
          CustomSearchBar(
            controller: controller ?? TextEditingController(),
            onChanged: onSearchChanged,
            onSubmitted: onSearchSubmitted,
            onCleared: onSearchCleared,
          ),
        ],
      ),
    );
  }
}

class CustomSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;
  final VoidCallback? onCleared;

  const CustomSearchBar({
    super.key,
    required this.controller,
    this.onChanged,
    this.onSubmitted,
    this.onCleared,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SizedBox(
        height: 40.h,
        child: TextField(
          controller: controller,
          textAlign: isArabic() ? TextAlign.right : TextAlign.left,
          onChanged: (value) {
            onChanged?.call(value);
            if (value.isEmpty) onCleared?.call();
          },
          onSubmitted: onSubmitted,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 12.h),
            hintText: 'بحث',
            hintStyle: AppTextStyles.font16DarkGreyWeight400.copyWith(
              color: AppColorsManager.textColor,
            ),
            suffixIcon: GestureDetector(
              onTap: () {
                controller.clear();
                onCleared?.call();
              },
              child: buildCustomSearchIcon(),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.r),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.r),
            ),
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
