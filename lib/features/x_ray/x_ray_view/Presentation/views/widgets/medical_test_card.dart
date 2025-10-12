import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';

class MedicalItemCard extends StatelessWidget {
  final String title;
  final String itemId;
  final List<Map<String, String>> infoRows;
  final bool isExpandingTitle;

  final void Function(String id)? onTap;

  const MedicalItemCard({
    super.key,
    required this.onTap,
    required this.title,
    required this.infoRows,
    required this.itemId,
    this.isExpandingTitle = false,
  });

  @override
  Widget build(BuildContext context) {
    // Calculate the height based on the number of info rows
    double baseHeight = 120.h; // Base height for the card
    double rowHeight = 24.h; // Height for each info row
    double additionalHeight = infoRows.length * rowHeight;

    // Adjust height if any row has 2 lines
    for (var row in infoRows) {
      if (row["title"] == "ملاحظات:" || row["title"] == "العرض الرئيسي:") {
        additionalHeight += rowHeight; // Add extra height for 2-line rows
      }
    }

    double totalHeight = baseHeight + additionalHeight;

    return GestureDetector(
      onTap: () => onTap!(itemId),
      child: FittedBox(
        fit: BoxFit.fill,
        child: Container(
          width: MediaQuery.of(context).size.width * 0.5,
          height: totalHeight,
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
                    padding: EdgeInsets.symmetric(
                        vertical: 8.h,
                        horizontal: isExpandingTitle ? 70.w : 6.w),
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
              ...infoRows.map((row) => _infoRow(row["title"]!, row["value"]!)),
              const Spacer(
                flex: 4,
              ),
              InkWell(
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
      ),
    );
  }

  // Widget _infoRow(String label, String value) {
  //   mapReportTypeToRelativeColor(value);
  //   return RichText(
  //     overflow: TextOverflow.ellipsis,
  // maxLines: label == "ملاحظات:" || label == "العرض الرئيسي:" ? 2 : 1,
  //     text: TextSpan(
  //       children: [
  //         TextSpan(
  //             text: "$label ",
  //             style:
  //                 AppTextStyles.font10blueWeight400.copyWith(fontSize: 13.sp)),
  //         TextSpan(
  //           text: value,
  //           style: AppTextStyles.font14blackWeight400,
  //         ),
  //       ],
  //     ),
  //   );
  // }
  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$label ",
            maxLines: label == "ملاحظات:" || label == "العرض الرئيسي:" ? 2 : 1,
            style: AppTextStyles.font10blueWeight400.copyWith(fontSize: 13.sp),
          ),
          mapReportTypeToRelativeColor(value),
          horizontalSpacing(4),
          Expanded(
            child: Text(
              value,
              maxLines:
                  (label == "ملاحظات:" || label == "العرض الرئيسي:") ? 2 : 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.font14blackWeight400,
            ),
          ),
        ],
      ),
    );
  }

  mapReportTypeToRelativeColor(value) {
    if (value == 'مراقبة') {
      return CircleAvatar(
        radius: 8,
        backgroundColor: AppColorsManager.warning,
      ).paddingSymmetricHorizontal(4);
    } else if (value == 'خطر مؤكد') {
      return CircleAvatar(
        radius: 8,
        backgroundColor: AppColorsManager.criticalRisk,
      ).paddingSymmetricHorizontal(4);
    } else if (value == 'خطر جزئي') {
      return CircleAvatar(
        radius: 8,
        backgroundColor: AppColorsManager.elevatedRisk,
      ).paddingSymmetricHorizontal(4);
    } else if (value == 'طبيعي') {
      return CircleAvatar(
        radius: 8,
        backgroundColor: AppColorsManager.safe,
      ).paddingSymmetricHorizontal(4);
    } else {
      return SizedBox.shrink();
    }
  }
}

