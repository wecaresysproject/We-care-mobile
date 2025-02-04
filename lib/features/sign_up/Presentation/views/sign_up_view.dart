import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_care/core/global/Helpers/custom_rich_text.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/app_custom_button.dart';
import 'package:we_care/core/global/SharedWidgets/design_logo_widget.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/routing/routes.dart';
import 'package:we_care/features/sign_up/Presentation/views/widgets/sign_up_form_fields_widget.dart';
import 'package:we_care/features/sign_up/Presentation/views/widgets/terms_and_conditions_text_widget.dart';
import 'package:we_care/features/sign_up/logic/sign_up_cubit.dart';
import 'package:we_care/generated/l10n.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  bool _isAccepted = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                S.of(context).createAccount,
                style: AppTextStyles.font22MainBlueRegular,
              ),
              SignUpFormFields(),
              // Use TermsAndConditionsWidget properly
              TermsAndConditionsTextWidget(
                isAccepted: _isAccepted,
                onAccepted: (value) {
                  setState(
                    () {
                      _isAccepted = value;
                    },
                  );
                },
              ),
              verticalSpacing(32),
              // Submit Button
              AppCustomButton(
                title: S.of(context).createAccount,
                isEnabled: _isAccepted,
                onPressed: () {
                  log("xxx: test button");
                  if (!_isAccepted) {
                    return;
                  }
                  if (context
                      .read<SignUpCubit>()
                      .formKey
                      .currentState!
                      .validate()) {
                    context.read<SignUpCubit>().emitSignupStates();

                    context.pushNamed(Routes.otpView);
                  }
                },
              ).paddingSymmetricHorizontal(
                16,
              ),
              verticalSpacing(24),
              // Already have an account
              CustomRichTextWidget(
                normalText: "${S.of(context).alreadyHaveAccount} ",
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
    );
  }
}
