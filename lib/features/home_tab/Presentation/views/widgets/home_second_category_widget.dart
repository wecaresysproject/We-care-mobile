import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';

class HomeSecondCategoryItem extends StatelessWidget {
  const HomeSecondCategoryItem({
    super.key,
    required this.categoryName,
    required this.imagePath,
    required this.onTap,
  });
  final String categoryName;
  final String imagePath;
  final void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 76.w,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: onTap,
            child: Container(
              width: 76.w,
              height: 56.h,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFFCDE1F8), Color(0xFFE7E9EB)],
                ),
                borderRadius: BorderRadius.circular(60),
              ),
              padding: EdgeInsets.only(
                top: 14,
                right: 18,
                bottom: 14,
                left: 18,
              ),
              child: Center(
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.contain,
                  height: 32.h,
                  width: 38.w,
                ),
              ),
            ),
          ),
          Text(
            categoryName,
            textAlign: TextAlign.center,
            style: AppTextStyles.font22WhiteWeight600.copyWith(
              fontSize: 14.sp,
              color: AppColorsManager.textColor,
            ),
          )
        ],
      ),
    );
  }
}
