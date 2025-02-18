import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../../../core/global/Helpers/app_enums.dart';
import '../../../../../core/global/Helpers/app_toasts.dart';
import '../../../../../core/global/Helpers/extensions.dart';
import '../../../../../core/global/Helpers/font_weight_helper.dart';
import '../../../../../core/global/app_strings.dart';
import '../../../../../core/global/theming/app_text_styles.dart';
import '../../../../../core/global/theming/color_manager.dart';
import '../../../../../core/routing/routes.dart';
import '../../../logic/otp_cubit.dart';
import '../../../logic/otp_state.dart';

class PinCodeFieldsWidget extends StatelessWidget {
  const PinCodeFieldsWidget({
    super.key,
    required this.isForgetPasswordFlow,
    required this.phoneNumber,
  });
  final bool isForgetPasswordFlow;
  final String phoneNumber;
  @override
  Widget build(BuildContext context) {
    return BlocListener<OtpCubit, OtpState>(
      listenWhen: (previous, current) =>
          current.otpStatus == RequestStatus.failure ||
          current.otpStatus == RequestStatus.success,
      listener: (context, state) async {
        if (state.otpStatus == RequestStatus.failure) {
          await showError(state.message);
          return;
        }

        await showSuccess(state.message);
        if (!context.mounted) return;
        if (isForgetPasswordFlow) {
          await context.pushNamedAndRemoveUntil(
            Routes.createNewPasswordView,
            predicate: (Route<dynamic> route) => false,
            arguments: {
              AppStrings.phoneNumberArgumentKey: phoneNumber,
            },
          );
        } else {
          await context.pushNamedAndRemoveUntil(
            Routes.bottomNavBar,
            predicate: (Route<dynamic> route) =>
                false, // Remove all previous screens
          );
        }
      },
      child: Directionality(
        //* always start wrighting from left
        textDirection: TextDirection.ltr,
        child: PinCodeTextField(
          length: 4,
          appContext: context,
          controller: context.read<OtpCubit>().otpTextEditingController,
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
            await context.read<OtpCubit>().verifyOtp(phoneNumber);
          },
        ),
      ),
    );
  }
}
