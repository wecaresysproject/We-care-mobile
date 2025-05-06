
import 'package:flutter/material.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';

class LoadingStateView extends StatelessWidget {
  const LoadingStateView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColorsManager.backGroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: AppColorsManager.mainDarkBlue,
            ),
            verticalSpacing(16),
            Text(
              "جاري تحميل البيانات...",
              style: AppTextStyles.font16DarkGreyWeight400,
            ),
          ],
        ),
      ),
    );
  }
}
