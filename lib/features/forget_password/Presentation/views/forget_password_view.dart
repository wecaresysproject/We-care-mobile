import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/di/dependency_injection.dart';
import '../../../../core/global/Helpers/app_enums.dart';
import '../../../../core/global/Helpers/app_toasts.dart';
import '../../../../core/global/Helpers/extensions.dart';
import '../../../../core/global/Helpers/functions.dart';
import '../../../../core/global/SharedWidgets/app_custom_button.dart';
import '../../../../core/global/SharedWidgets/design_logo_widget.dart';
import '../../../../core/global/app_strings.dart';
import '../../../../core/global/theming/app_text_styles.dart';
import '../../../../core/global/theming/color_manager.dart';
import '../../../../core/routing/routes.dart';
import '../../../../generated/l10n.dart';
import '../../../reset_password/Presentation/views/widgets/forget_password_form_fields_widget.dart';
import '../view_models/cubit/forget_password_cubit.dart';
import '../view_models/cubit/forget_password_state.dart';

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
    return BlocProvider(
      create: (context) => getIt<ForgetPasswordCubit>(),
      child: Scaffold(
        appBar: AppBar(),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          physics: const BouncingScrollPhysics(),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                verticalSpacing(8),
                DesignLogoWidget(),
                verticalSpacing(4),
                Text(
                  S.of(context).forgotPassword,
                  style: AppTextStyles.font22WhiteWeight600.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColorsManager.mainDarkBlue,
                  ),
                ),
                verticalSpacing(8),
                Text(
                  isArabic()
                      ? weHaveSendCodeToUrPhoneAr
                      : weHaveSendCodeToUrPhoneEn,
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.font16DarkGreyWeight400.copyWith(
                    color: Color(0xff555555),
                  ),
                ),
                verticalSpacing(44),
                ForgetPasswordFormFields(),
                verticalSpacing(context.screenHeight * 0.35),
                buildSubmitButtonBlocConsumer(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildSubmitButtonBlocConsumer() {
    return BlocConsumer<ForgetPasswordCubit, ForgetPasswordState>(
      listenWhen: (prev, curr) =>
          curr.forgetPasswordStatus == RequestStatus.failure ||
          curr.forgetPasswordStatus == RequestStatus.success,
      listener: (context, state) async {
        if (state.forgetPasswordStatus == RequestStatus.success) {
          await showSuccess(state.message);
          if (!context.mounted) return;
          await context.pushNamed(
            Routes.otpView,
            arguments: {
              AppStrings.isForgetPasswordFlowArgumentKey: true,
              AppStrings.phoneNumberArgumentKey:
                  '+2${context.read<ForgetPasswordCubit>().phoneController.text}'
            },
          );
        } else if (state.forgetPasswordStatus == RequestStatus.failure) {
          await showError(state.message);
        }
      },
      builder: (context, state) {
        return AppCustomButton(
          isLoading: state.forgetPasswordStatus == RequestStatus.loading,
          title: context.translate.Continue,
          isEnabled: true,
          onPressed: () async {
            if (context
                .read<ForgetPasswordCubit>()
                .formKey
                .currentState!
                .validate()) {
              await context
                  .read<ForgetPasswordCubit>()
                  .emitForgetPasswordState();
            }
          },
        );
      },
    );
  }
}
