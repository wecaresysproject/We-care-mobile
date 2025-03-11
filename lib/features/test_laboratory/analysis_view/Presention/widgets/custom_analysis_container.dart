import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';

class CustomAnalysisContainer extends StatelessWidget {
  final String iconPath; // e.g., 'assets/icons/test_icon.png'
  final String label; // e.g., 'NA'
  final String title; // e.g., 'صوديوم'
  final String description; // e.g., 'يقيس نسبة الصوديوم في الدم ...'

  const CustomAnalysisContainer({
    super.key,
    required this.iconPath,
    required this.label,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title, Icon, and Label Row ABOVE the container
        Row(
          children: [
            Image.asset(
              iconPath,
              width: 24.w,
              height: 24.h,
            ),
            horizontalSpacing(8),
            Text(
              title,
              style: AppTextStyles.font20blackWeight600.copyWith(
                color: AppColorsManager.mainDarkBlue,
              ),
            ),
            horizontalSpacing(24),
            Text(
              label,
              style: AppTextStyles.font20blackWeight600.copyWith(
                color: AppColorsManager.mainDarkBlue,
              ),
            ),
          ],
        ),

        verticalSpacing(16),

        // The Container with border & background
        Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          decoration: BoxDecoration(
            // If you want a gradient background
            gradient: const LinearGradient(
              colors: [Color(0xFFECF5FF), Color(0xFFFBFDFF)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppColorsManager.mainDarkBlue,
              width: 1,
            ),
          ),
          child: Text(
            description,
            style: AppTextStyles.font12blackWeight400,
          ),
        ),
      ],
    );
  }
}
