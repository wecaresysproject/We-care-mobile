import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';

class DetailsViewInfoTile extends StatelessWidget {
  final String title;
  final String value;
  final String? icon;
  final bool isExpanded;
  final bool isSmallContainers;
  final bool isMultiContainer;
  final bool isPartiallyExpanded;

  const DetailsViewInfoTile(
      {super.key,
      required this.title,
      required this.value,
       this.icon,
      this.isMultiContainer = false,
      this.isSmallContainers = false,
      this.isExpanded = false,
      this.isPartiallyExpanded = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
          icon != null?  Image.asset(icon!, height: 14.h, width: 14.w):SizedBox.shrink(),
            horizontalSpacing(2),
            Text(
              title,
              style: AppTextStyles.font16DarkGreyWeight400.copyWith(
                  color: AppColorsManager.mainDarkBlue, fontSize: isSmallContainers? 14.sp: 16.5.sp),
            ),
          ],
        ),
        verticalSpacing(8),
        SizedBox(
          width: isExpanded
              ? MediaQuery.of(context).size.width - 32.w
              : isPartiallyExpanded?(MediaQuery.of(context).size.width * 0.65) - 27.w: isSmallContainers? (MediaQuery.of(context).size.width * 0.35) - 27.w: (MediaQuery.of(context).size.width * 0.5) - 27.w,
          child: CustomContainer(
            value: value,
            isExpanded: isExpanded,
            isSmallContainers: isSmallContainers,
          ),
        ),
      ],
    );
  }
}

class CustomContainer extends StatelessWidget {
  const CustomContainer({
    super.key,
    required this.value,
    this.isExpanded = false,
    this.isSmallContainers = false,
  });

  final String value;
  final bool isExpanded;
  final bool isSmallContainers;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: isExpanded
          ?isSmallContainers? (MediaQuery.of(context).size.width * 0.35) - 27.w: MediaQuery.of(context).size.width - 32.w
          : (MediaQuery.of(context).size.width * 0.46) - 24.w,
      child: Container(
        padding: EdgeInsets.fromLTRB(4.w, 8.h, 14.w, 8.h),
        margin: EdgeInsets.zero,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: AppColorsManager.mainDarkBlue, width: 0.3),
          gradient: const LinearGradient(
            colors: [Color(0xFFECF5FF), Color(0xFFFBFDFD)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Align(
          alignment: Alignment.centerRight,
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: AppTextStyles.font16DarkGreyWeight400.copyWith(
              fontSize: 15.sp,
                color: AppColorsManager.textColor, fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }
}
