import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/Helpers/font_weight_helper.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/core/routing/routes.dart';

class PinCodeFieldsWidget extends StatelessWidget {
  const PinCodeFieldsWidget({
    super.key,
    required this.isForgetPasswordFlow,
  });
  final bool isForgetPasswordFlow;
  @override
  Widget build(BuildContext context) {
    return Directionality(
      //* always start wrighting from left
      textDirection: TextDirection.ltr,
      child: PinCodeTextField(
        length: 4,
        appContext: context,
        // controller: TextEditingController(),
        keyboardType: TextInputType.number,
        textStyle: AppTextStyles.font18blackWight500.copyWith(
          fontSize: 20.sp,
          fontFamily: "inter",
          fontWeight: FontWeightHelper.semiBold,
        ),
        cursorColor: AppColorsManager.mainDarkBlue,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        autoFocus: true,
        cursorHeight: 29.h,
        enablePinAutofill: true,
        cursorWidth: 1.5.w,
        animationType: AnimationType.fade,

        pinTheme: PinTheme(
          shape: PinCodeFieldShape.box,
          borderRadius: BorderRadius.circular(12),
          fieldHeight: 60.h,
          fieldWidth: 74.w,
          activeFillColor: Colors.white,
          activeColor: AppColorsManager.mainDarkBlue,
          selectedColor: AppColorsManager.mainDarkBlue,
          inactiveBorderWidth: 1.5.w,
          errorBorderColor: AppColorsManager.warningColor,
          inactiveColor: AppColorsManager.textfieldOutsideBorderColor,
        ),
        animationDuration: const Duration(milliseconds: 300),
        enableActiveFill: false,
        onChanged: (value) {},
        onCompleted: (value) async {
          /// navigate to right screen
          if (!context.mounted) return;
          isForgetPasswordFlow
              ? await context.pushNamed(Routes.createNewPasswordView)
              : await context.pushNamedAndRemoveUntil(
                  Routes.bottomNavBar,
                  predicate: (route) => false, // remove all previous screens
                ); //! TODO: and validated also before push to bottom nav bar
        },
      ),
    );
  }
}
