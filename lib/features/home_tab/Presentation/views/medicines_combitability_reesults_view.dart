import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/custom_app_bar_with_centered_title_widget.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';

class MedicinesCombitabilityReesultsView extends StatelessWidget {
  const MedicinesCombitabilityReesultsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(toolbarHeight: 0),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: const AppBarWithCenteredTitle(
              title: "نتيجة التوافق",
              showActionButtons: false,
            ),
          ),
          verticalSpacing(20),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
              itemCount: _dummyResults.length,
              itemBuilder: (context, index) {
                return _buildMedicineCard(_dummyResults[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMedicineCard(_MedicineResult result) {
    return Card(
      margin: EdgeInsets.only(bottom: 16.h),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  result.name,
                  style: AppTextStyles.font18blackWight500,
                ),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: result.isCompatible
                        ? Colors.green.withOpacity(0.1)
                        : Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Text(
                    result.isCompatible ? "متوافق" : "غير متوافق",
                    style: AppTextStyles.font14BlackMedium.copyWith(
                      color: result.isCompatible ? Colors.green : Colors.red,
                    ),
                  ),
                ),
              ],
            ),
            verticalSpacing(12),
            Text(
              "الأسباب:",
              style: AppTextStyles.font14BlackMedium.copyWith(
                color: AppColorsManager.mainDarkBlue,
              ),
            ),
            verticalSpacing(8),
            ...result.reasons.map((reason) => Padding(
                  padding: EdgeInsets.only(bottom: 4.h),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 6.h),
                        child: CircleAvatar(
                          radius: 3.r,
                          backgroundColor: AppColorsManager.placeHolderColor,
                        ),
                      ),
                      horizontalSpacing(8),
                      Expanded(
                        child: Text(
                          reason,
                          style: AppTextStyles.font14blackWeight400.copyWith(
                            color: AppColorsManager.textColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}

class _MedicineResult {
  final String name;
  final bool isCompatible;
  final List<String> reasons;

  _MedicineResult({
    required this.name,
    required this.isCompatible,
    required this.reasons,
  });
}

final List<_MedicineResult> _dummyResults = [
  _MedicineResult(
    name: "Paracetamol",
    isCompatible: true,
    reasons: [
      "لا يوجد تداخل معروف مع الأدوية الحالية",
      "آمن للاستخدام مع حالتك الصحية الحالية",
    ],
  ),
  _MedicineResult(
    name: "Ibuprofen",
    isCompatible: false,
    reasons: [
      "قد يزيد من خطر النزيف عند استخدامه مع الأسبرين",
      "يجب استشارة الطبيب قبل الاستخدام مع أدوية الضغط",
    ],
  ),
  _MedicineResult(
    name: "Aspirin",
    isCompatible: true,
    reasons: [
      "يتوافق مع الجدول الزمني للعلاجات الحالية",
    ],
  ),
];
