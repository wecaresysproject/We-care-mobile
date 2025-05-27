import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/genetic_diseases/data/models/new_genetic_disease_model.dart';

class GeneticDiseaseTemplateContainer extends StatelessWidget {
  const GeneticDiseaseTemplateContainer({
    super.key,
    required this.onDelete,
    required this.geneticDisease,
  });

  final VoidCallback onDelete;
  final NewGeneticDiseaseModel geneticDisease;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(color: AppColorsManager.mainDarkBlue, width: 1.7),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  " 1 المرض الوراثي",
                  style: AppTextStyles.font18blackWight500.copyWith(
                    color: AppColorsManager.mainDarkBlue,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ).paddingBottom(
                  16,
                ),
              ),
              IconButton(
                onPressed: onDelete,
                padding: EdgeInsets.zero,
                alignment: Alignment.topCenter,
                icon: Icon(
                  Icons.delete,
                  size: 28.sp,
                  color: AppColorsManager.warningColor,
                ),
              )
            ],
          ),
          GeneticDiseaseInfoTile(
            title: "فئة المرض ",
            value: geneticDisease.diseaseCategory ?? "",
            isExpanded: true,
          ),
          verticalSpacing(16),
          GeneticDiseaseInfoTile(
            title: "الأعراض المرضية - الشكوى",
            value: geneticDisease.geneticDisease ?? "",
            isExpanded: true,
          ),
          verticalSpacing(16),
          GeneticDiseaseInfoTile(
            title: "المرحلة العمرية للظهور",
            value: geneticDisease.appearanceAgeStage ?? "",
            isExpanded: true,
          ),
          verticalSpacing(16),
          GeneticDiseaseInfoTile(
            title: "حالة المرض",
            value: geneticDisease.patientStatus ?? "",
            isExpanded: true,
          ),
        ],
      ),
    );
  }
}

class GeneticDiseaseInfoTile extends StatelessWidget {
  final String title;
  final String value;
  final bool isExpanded;
  final bool isMultiContainer;
  final bool isPartiallyExpanded;

  const GeneticDiseaseInfoTile({
    super.key,
    required this.title,
    required this.value,
    this.isMultiContainer = false,
    this.isExpanded = false,
    this.isPartiallyExpanded = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyles.font16DarkGreyWeight400.copyWith(
              color: AppColorsManager.mainDarkBlue, fontSize: 16.5.sp),
        ),
        verticalSpacing(8),
        SizedBox(
          width: isExpanded
              ? MediaQuery.of(context).size.width - 32.w
              : isPartiallyExpanded
                  ? (MediaQuery.of(context).size.width * 0.65) - 27.w
                  : (MediaQuery.of(context).size.width * 0.5) - 27.w,
          child: CustomContainer(
            value: value,
            isExpanded: isExpanded,
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
  });

  final String value;
  final bool isExpanded;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: isExpanded
          ? MediaQuery.of(context).size.width - 32.w
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
                color: AppColorsManager.textColor, fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }
}
