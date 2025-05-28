import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/functions.dart';

import 'package:we_care/core/global/SharedWidgets/details_view_app_bar.dart';
import 'package:we_care/core/global/SharedWidgets/details_view_info_tile.dart';

class FamilyMemberGeneticDiseaseDetailsView extends StatelessWidget {
  const FamilyMemberGeneticDiseaseDetailsView(
      {super.key,  this.documentId});
  final String? documentId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0.h,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DetailsViewAppBar(
              title: 'الخال: مصطفى',
            ),

            SizedBox(height: 16.h),
            DetailsViewInfoTile(
              title: "المرض الوراثى",
              value: "هذا النص مثال",
              icon: 'assets/images/tumor_icon.png',
              isExpanded: true,
            ),
            SizedBox(height: 16.h),
            DetailsViewInfoTile(
              title: "حالة المرض",
              value: "هذا النص مثال",
              icon: 'assets/images/tumor_icon.png',
              isExpanded: true,
            ),
            verticalSpacing(16),
            // Disease Classification and Inheritance Type
            Row(
              children: [
                DetailsViewInfoTile(
                  title: "التصنيف الطبي المرضي",
                  value: "هذا النص مثال",
                  icon: 'assets/images/tumor_icon.png',
                ),
                Spacer(),
                DetailsViewInfoTile(
                  title: "نوع الوراثة",
                  value: "هذا النص مثال",
                  icon: 'assets/images/symptoms_icon.png',
                ),
              ],
            ),
            SizedBox(height: 16.h),

            // Detailed description
            DetailsViewInfoTile(
              title: "الوصف التفصيلي",
              value:
                  "هذا النص مثال لنص اريد استبداله في نفس المساحة ...........................",
              icon: 'assets/images/symptoms_icon.png',
              isExpanded: true,
            ),
            SizedBox(height: 16.h),

            // Responsible Gene and Inheritance Pattern
            Row(
              children: [
                Expanded(
                  child: DetailsViewInfoTile(
                    title: "الجين المسؤول",
                    value: "هذا النص مثال",
                    icon: 'assets/images/tumor_icon.png',
                  ),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: DetailsViewInfoTile(
                    title: "معدل الانتشار",
                    value: "هذا النص مثال",
                    icon: 'assets/images/doctor_icon.png',
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            // Age of Onset and Risk level
            Row(
              children: [
                DetailsViewInfoTile(
                  title: "العمر النموذجي للظهور",
                  value: "هذا النص مثال",
                  icon: 'assets/images/tumor_icon.png',
                ),
                Spacer(),
                DetailsViewInfoTile(
                  title: "الجنس المعني",
                  value: "هذا النص مثال",
                  icon: 'assets/images/symptoms_icon.png',
                ),
              ],
            ),
            SizedBox(height: 16.h),

            // Age of Onset and Risk level
            Row(
              children: [
                DetailsViewInfoTile(
                  title: "المرحلة العمرية ",
                  value: "هذا النص مثال",
                  icon: 'assets/images/time_icon.png',
                ),
                Spacer(),
                DetailsViewInfoTile(
                  title: "مستوى المخاطرة",
                  value: "هذا النص مثال",
                  icon: 'assets/images/symptoms_icon.png',
                ),
              ],
            ),
            SizedBox(height: 16.h),

            // Main Symptoms
            DetailsViewInfoTile(
              title: "الأعراض الرئيسية",
              value:
                  "هذا النص مثال",
              icon: 'assets/images/symptoms_icon.png',
              isExpanded: true,
            ),
            verticalSpacing(8), 
            CustomContainer(
              value:
                  "هذا النص مثال",
              isExpanded: true,
            ),
            verticalSpacing(8), 
                CustomContainer(
              value:
                  "هذا النص مثال",
              isExpanded: true,
            ),

            SizedBox(height: 16.h),

            // Diagnostic Tests
            DetailsViewInfoTile(
              title: "الفحوصات التشخيصية",
                 value:
                  "هذا النص مثال",
              icon: 'assets/images/doctor_name.png',
              isExpanded: true,
            ),
            verticalSpacing(8), 
            CustomContainer(
              value:
                  "هذا النص مثال",
              isExpanded: true,
            ),
            verticalSpacing(8), 
                CustomContainer(
              value:
                  "هذا النص مثال",
              isExpanded: true,
            ),
            SizedBox(height: 16.h),

            // Available Treatments
            DetailsViewInfoTile(
              title: "العلاجات المتاحة",
              value:
                  "هذا النص مثال",
              icon: 'assets/images/medicine_icon.png',
              isExpanded: true,
            ),
verticalSpacing(8),            CustomContainer(
              value:
                  "هذا النص مثال",
              isExpanded: true,
            ),
            verticalSpacing(8), 
                CustomContainer(
              value:
                  "هذا النص مثال",
              isExpanded: true,
            ),
          ],
        ),
      ),
    );
  }
}