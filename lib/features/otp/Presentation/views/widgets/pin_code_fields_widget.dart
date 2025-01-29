import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';

class PinCodeFieldsWidget extends StatelessWidget {
  const PinCodeFieldsWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Directionality(
      //* always start wrighting from lest
      textDirection: TextDirection.ltr,
      child: PinCodeTextField(
        length: 4,
        appContext: context,
        keyboardType: TextInputType.number,
        textStyle: AppTextStyles.font22DarkRegular,
        cursorColor: AppColorsManager.mainDarkBlue,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        autoFocus: true,
        cursorHeight: 29.h,
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
        onCompleted: (value) {
          print("OTP Entered: $value");
          //!Check here that the code is correct and go to home page or not
        },
      ),
    );
  }
}
