import 'package:flutter/material.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/Helpers/font_weight_helper.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/design_logo_widget.dart';
import 'package:we_care/core/global/SharedWidgets/underlined_text.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/otp/Presentation/views/widgets/pin_code_fields_widget.dart';

class OtpView extends StatelessWidget {
  const OtpView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(), //*just to add padding from top instead of safearea
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              verticalSpacing(8),
              DesignLogoWidget(),
              verticalSpacing(16),
              Text(
                context.translate.verifyYourNumber,
                style: AppTextStyles.font22DarkRegular,
              ),
              verticalSpacing(5),
              Text(
                context.translate.verifyYourNumberHint,
                style: AppTextStyles.font16DarkGreyRegular,
              ),
              verticalSpacing(40),
              // ✅ Pin Code Fields
              PinCodeFieldsWidget(),
              verticalSpacing(20),
              UnderlinedText(
                text: context.translate.resend,
                textStyle: AppTextStyles.font18blackRegular.copyWith(
                  color: AppColorsManager.mainDarkBlue,
                  fontWeight: FontWeightHelper.semiBold,
                ),
                underlineColor: AppColorsManager.mainDarkBlue,
              ),
            ],
          ).paddingSymmetricHorizontal(16),
        ),
      ),
    );
  }
}
