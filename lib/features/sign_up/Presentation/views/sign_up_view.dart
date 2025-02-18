import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/dependency_injection.dart';
import '../../../../core/global/Helpers/app_enums.dart';
import '../../../../core/global/Helpers/app_toasts.dart';
import '../../../../core/global/Helpers/custom_rich_text.dart';
import '../../../../core/global/Helpers/extensions.dart';
import '../../../../core/global/Helpers/functions.dart';
import '../../../../core/global/SharedWidgets/app_custom_button.dart';
import '../../../../core/global/SharedWidgets/design_logo_widget.dart';
import '../../../../core/global/app_strings.dart';
import '../../../../core/global/theming/app_text_styles.dart';
import '../../../../core/routing/routes.dart';
import '../../../../generated/l10n.dart';
import '../../logic/sign_up_cubit.dart';
import 'widgets/sign_up_form_fields_widget.dart';
import 'widgets/terms_and_conditions_text_widget.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  bool _isTermsAccepted = false;
  @override
  Widget build(BuildContext context) {
    return BlocProvider<SignUpCubit>(
      create: (BuildContext context) => getIt<SignUpCubit>(),
      child: Scaffold(
        appBar: AppBar(),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                verticalSpacing(8),
                DesignLogoWidget(),
                verticalSpacing(4),
                Text(
                  context.translate.createAccount,
                  style: AppTextStyles.font22MainBlueWeight700,
                ),
                SignUpFormFields(),
                // Use TermsAndConditionsWidget properly
                TermsAndConditionsTextWidget(
                  isAccepted: _isTermsAccepted,
                  onAccepted: (value) {
                    setState(
                      () {
                        _isTermsAccepted = value;
                      },
                    );
                  },
                ),
                verticalSpacing(32),
                // Submit Button
                submitSignUpBlocBuilder(),
                verticalSpacing(24),
                // Already have an account
                CustomUnderlinedRichTextWidget(
                  normalText: "${context.translate.alreadyHaveAccount} ",
                  highlightedText: S.of(context).login,
                  onTap: () async {
                    await context.pushNamed(Routes.loginView);
                  },
                ),
                verticalSpacing(33),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget submitSignUpBlocBuilder() {
    return BlocConsumer<SignUpCubit, SignUpState>(
      listener: (context, state) async {
        if (state.signupStatus == RequestStatus.success) {
          await showSuccess(state.successMessage);
          if (!context.mounted) return;
          await context.pushNamed(Routes.otpView, arguments: {
            AppStrings.phoneNumberArgumentKey:
                '+2${context.read<SignUpCubit>().phoneController.text}'
          });
        } else if (state.signupStatus == RequestStatus.failure) {
          await showError(state.errorMessage!);
        }
      },
      builder: (context, state) {
        return AppCustomButton(
          isLoading: state.signupStatus == RequestStatus.loading,
          title: context.translate.createAccount,
          isEnabled: _isTermsAccepted,
          onPressed: () async {
            if (!_isTermsAccepted) {
              return;
            }
            if (context.read<SignUpCubit>().formKey.currentState!.validate()) {
              await context.read<SignUpCubit>().emitSignupStates();
            }
          },
        ).paddingSymmetricHorizontal(20);
      },
    );
  }
}
