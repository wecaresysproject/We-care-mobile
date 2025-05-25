import 'package:flutter/material.dart';
import 'package:we_care/core/global/Helpers/font_weight_helper.dart';
import 'package:we_care/core/global/SharedWidgets/custom_app_back_arrow.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';

class DentalAppBarComponent extends StatelessWidget {
  const DentalAppBarComponent({
    super.key,
    this.toothNumber,
  });

  final String? toothNumber;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Centered text
        Text(
          "البيانات الخاصة بالسن رقم $toothNumber",
          style: AppTextStyles.font16DarkGreyWeight400.copyWith(
            color: AppColorsManager.textColor,
            fontWeight: FontWeightHelper.medium,
          ),
          textAlign: TextAlign.center,
        ),
        // Back button aligned left
        Align(
          alignment: Alignment.centerRight,
          child: CustomBackArrow(),
        ),
      ],
    );
  }
}
