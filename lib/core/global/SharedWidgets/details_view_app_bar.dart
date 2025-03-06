import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/custom_app_back_arrow.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';

class DetailsViewAppBar extends StatelessWidget {
  const DetailsViewAppBar(
      {super.key, required this.title, this.editFunction, this.deleteFunction});
  final String title;
  final Function()? editFunction;
  final Function()? deleteFunction;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Align(
          alignment: isArabic() ? Alignment.topRight : Alignment.topLeft,
          child: CustomBackArrow(),
        ),
        Expanded(
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: AppTextStyles.font20blackWeight600.copyWith(fontSize: 21.sp),
          ),
        ),
        Row(
          children: [
            InkWell(
              onTap: editFunction,
              child: Container(
                decoration: BoxDecoration(
                  color: AppColorsManager.mainDarkBlue,
                  borderRadius: BorderRadius.circular(16.r),
                ),
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 8.h),
                child: Row(children: [
                  Image.asset(
                    'assets/images/edit.png',
                    width: 15.w,
                    height: 15.h,
                  ),
                  Text('تعديل', style: AppTextStyles.font14whiteWeight600),
                ]),
              ),
            ),
            horizontalSpacing(8.w),
            InkWell(
              onTap: deleteFunction,
              child: Container(
                decoration: BoxDecoration(
                  color: AppColorsManager.warningColor,
                  borderRadius: BorderRadius.circular(16.r),
                ),
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 8.h),
                child: Row(children: [
                  Image.asset(
                    'assets/images/delete.png',
                    width: 15.w,
                    height: 15.h,
                  ),
                  Text('حذف', style: AppTextStyles.font14whiteWeight600),
                ]),
              ),
            )
          ],
        )
      ],
    );
  }
}
