import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/Helpers/progress_line_tracking_widget.dart';
import 'package:we_care/core/global/SharedWidgets/app_custom_button.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/core/routing/routes.dart';
import 'package:we_care/features/forget_password/Presentation/view_models/cubit/forget_password_cubit.dart';
import 'package:we_care/features/reset_password/Presentation/views/widgets/forget_password_form_fields_widget.dart';
import 'package:we_care/generated/l10n.dart';

class ForgetPasswordView extends StatefulWidget {
  const ForgetPasswordView({super.key});

  @override
  State<ForgetPasswordView> createState() => _ForgetPasswordViewState();
}

class _ForgetPasswordViewState extends State<ForgetPasswordView> {
  final String weHaveSendCodeToUrPhoneAr =
      "أدخل رقم هاتفك وسنرسل لك رمز\n لإعادة تعيين كلمة المرور";
  final String weHaveSendCodeToUrPhoneEn =
      "Enter your phone number and we will send you a code\n to reset your password";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(top: 10.h, left: 16.w, right: 16.w),
        physics: const BouncingScrollPhysics(),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              verticalSpacing(20),
              Text(
                S.of(context).forgotPassword,
                style: AppTextStyles.font22WhiteWeight600.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColorsManager.mainDarkBlue,
                ),
              ),
              verticalSpacing(16),
              Text(
                isArabic()
                    ? weHaveSendCodeToUrPhoneAr
                    : weHaveSendCodeToUrPhoneEn,
                maxLines: 2,
                textAlign: TextAlign.center,
                style: AppTextStyles.font16DarkGreyWeight400.copyWith(
                  color: AppColorsManager.textColor,
                ),
              ),
              verticalSpacing(44),

              ForgetPasswordFormFields(),

              verticalSpacing(context.screenHeight * 0.35),
              ProgressLineTracking(
                currentStep: "1",
              ),
              verticalSpacing(6),

              // Submit Button
              AppCustomButton(
                title: S.of(context).Continue,
                isEnabled: true,
                onPressed: () async {
                  if (context
                      .read<ForgetPasswordCubit>()
                      .formKey
                      .currentState!
                      .validate()) {
                    await context
                        .read<ForgetPasswordCubit>()
                        .emitResetPasswordState();

                    if (!context.mounted) return;

                    await context.pushNamed(Routes.otpView);
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
