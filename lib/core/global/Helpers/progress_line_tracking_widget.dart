import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:linear_progress_bar/linear_progress_bar.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';

class ProgressLineTracking extends StatelessWidget {
  const ProgressLineTracking({
    super.key,
    required this.currentStep,
    this.maxStep = 3,
  });
  final String currentStep;
  final int maxStep;

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 4,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "$currentStep/3",
          style: AppTextStyles.font22MainBlueRegular,
        ),
        LinearProgressBar(
          maxSteps: 3,
          progressType:
              LinearProgressBar.progressTypeLinear, // Use Linear progress
          currentStep: 1,
          progressColor: AppColorsManager.mainDarkBlue,
          backgroundColor: Color(0xffE5EDF3),
          borderRadius: BorderRadius.circular(50.r), //  NEW
        ),
      ],
    );
  }
}
