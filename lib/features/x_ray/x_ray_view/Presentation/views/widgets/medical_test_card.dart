import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';

class MedicalItemCard extends StatelessWidget {
  final String title;
  final String itemId;
  final List<Map<String, String>> infoRows;

  final void Function(String id)? onTap;

  const MedicalItemCard({
    super.key,
    required this.onTap,
    required this.title,
    required this.infoRows,
    required this.itemId,
  });

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.fill,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.5,
        height: MediaQuery.of(context).size.height * 0.283,
        padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 10.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: Color(0xFF555555), width: 0.5),
          gradient: LinearGradient(
            colors: [Color(0xFFECF5FF), Color(0xFFFBFDFF)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 6.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(
                      color: AppColorsManager.mainDarkBlue,
                      width: 0.6,
                    ),
                  ),
                  child: Text(
                    title,
                    maxLines: 1,
                    style: AppTextStyles.font14BlueWeight700.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 16.sp,
                      shadows: [
                        Shadow(
                          offset: Offset(1.5, 1.5),
                          blurRadius: 3,
                          color: Color(0x29000000),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            verticalSpacing(4),
            ...infoRows
                .map((row) => _infoRow(row["title"]!, row["value"]!))
                .toList(),
            const Spacer(
              flex: 2,
            ),
            InkWell(
              onTap: () => onTap!(itemId),
              borderRadius: BorderRadius.circular(16.r),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  border: Border.all(
                    color: AppColorsManager.mainDarkBlue,
                    width: 1.6,
                  ),
                  borderRadius: BorderRadius.circular(16.r),
                ),
                padding: EdgeInsets.symmetric(vertical: 4.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "عرض المحتوى",
                      style: AppTextStyles.font14BlueWeight700,
                    ),
                    horizontalSpacing(12),
                    Image.asset(
                      "assets/images/side_arrow_filled.png",
                      width: 10.w,
                      height: 10.h,
                      color: AppColorsManager.mainDarkBlue,
                    ),
                  ],
                ),
              ),
            ),
            Spacer(
              flex: 1,
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return RichText(
      overflow: TextOverflow.ellipsis,
      maxLines: label == "ملاحظات:" ? 2 : 1,
      text: TextSpan(
        children: [
          TextSpan(
              text: "$label ",
              style:
                  AppTextStyles.font10blueWeight400.copyWith(fontSize: 13.sp)),
          TextSpan(
            text: value,
            style: AppTextStyles.font14blackWeight400,
          ),
        ],
      ),
    );
  }
}

class PrescriptionData {
  final String id;
  final String title;
  final String specialty;
  final String date;
  final String condition;

  PrescriptionData({
    required this.id,
    required this.title,
    required this.specialty,
    required this.date,
    required this.condition,
  });
}
