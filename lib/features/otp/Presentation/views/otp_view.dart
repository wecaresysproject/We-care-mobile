import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/dependency_injection.dart';
import '../../../../core/global/Helpers/app_enums.dart';
import '../../../../core/global/Helpers/app_toasts.dart';
import '../../../../core/global/Helpers/custom_rich_text.dart';
import '../../../../core/global/Helpers/extensions.dart';
import '../../../../core/global/Helpers/functions.dart';
import '../../../../core/global/SharedWidgets/design_logo_widget.dart';
import '../../../../core/global/theming/app_text_styles.dart';
import '../../logic/otp_cubit.dart';
import '../../logic/otp_state.dart';
import 'widgets/pin_code_fields_widget.dart';

class OtpView extends StatelessWidget {
  const OtpView(
      {super.key,
      required this.isForgetPasswordFlow,
      required this.phoneNumber});
  final bool isForgetPasswordFlow;
  final String phoneNumber;

  @override
  Widget build(BuildContext context) {
    final OtpCubit otpCubit = getIt.get<OtpCubit>();
    return BlocProvider<OtpCubit>(
      create: (context) => otpCubit,
      child: BlocListener<OtpCubit, OtpState>(
        listenWhen: (previous, current) =>
            current.otpStatus == RequestStatus.failure ||
            current.otpStatus == RequestStatus.success,
        listener: (context, state) {
          if (state.otpStatus == RequestStatus.success) {
            showSuccess(state.message);
          }
          if (state.otpStatus == RequestStatus.failure) {
            showError(state.message);
          }
        },
        child: Scaffold(
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
                    style: AppTextStyles.font22MainBlueWeight700,
                  ),
                  verticalSpacing(32),
                  Text(
                    context.translate.verifyYourNumberHint,
                    style: AppTextStyles.font16DarkGreyWeight400,
                  ),
                  verticalSpacing(24),
                  // ✅ Pin Code Fields
                  PinCodeFieldsWidget(
                    isForgetPasswordFlow: isForgetPasswordFlow,
                    phoneNumber: phoneNumber,
                  ),
                  verticalSpacing(20),
                  CustomUnderlinedRichTextWithCounterWidget(
                    normalText: "",
                    highlightedText: context.translate.resend,
                    onTap: () async {
                      await otpCubit.resendOtp(phoneNumber);
                    },
                  ),
                ],
              ).paddingSymmetricHorizontal(16),
            ),
          ),
        ),
      ),
    );
  }
}
