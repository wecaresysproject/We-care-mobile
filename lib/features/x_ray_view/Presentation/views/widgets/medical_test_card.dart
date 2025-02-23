import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';

class MedicalItemCard extends StatelessWidget {
  final dynamic item;
  final void Function()? onTap;

  const MedicalItemCard({
    super.key,
    required this.item,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Flexible(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.48,
            height: MediaQuery.of(context).size.height * 0.35,
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
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(vertical: 8.h, horizontal: 6.w),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(
                          color: AppColorsManager.mainDarkBlue, width: 0.6),
                    ),
                    child: Text(
                      item.title,
                      style: AppTextStyles.font14BlueWeight700,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                verticalSpacing(4),
                _infoRow("التخصص:",
                        item is PrescriptionData ? item.specialty : "-")
                    .visible(item is PrescriptionData),
                _infoRow("التاريخ:", item.date),
                _infoRow("منطقة الأشعة:",
                        item is MedicalTestData ? item.region : "-")
                    .visible(item is MedicalTestData),
                _infoRow("دواعي الفحص:",
                        item is MedicalTestData ? item.reason : "-")
                    .visible(item is MedicalTestData),
                _infoRow("ملاحظات:", item is MedicalTestData ? item.notes : "-")
                    .visible(item is MedicalTestData),
                _infoRow("المرض:",
                        item is PrescriptionData ? item.condition : "-")
                    .visible(item is PrescriptionData),
                verticalSpacing(6),
                Flexible(
                  child: TextButton(
                    onPressed: onTap,
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero, // Removes default padding
                      backgroundColor: Colors.white,
                      side: BorderSide(
                          color: AppColorsManager.mainDarkBlue, width: 1.6),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                    ),
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
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _infoRow(String label, String value) {
    return RichText(
      overflow: TextOverflow.ellipsis,
      maxLines: 1,
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

class MedicalTestData {
  final String title;
  final String date;
  final String region;
  final String reason;
  final String notes;

  MedicalTestData({
    required this.title,
    required this.date,
    required this.region,
    required this.reason,
    required this.notes,
  });
}

class PrescriptionData {
  final String title;
  final String specialty;
  final String date;
  final String condition;

  PrescriptionData({
    required this.title,
    required this.specialty,
    required this.date,
    required this.condition,
  });
}
