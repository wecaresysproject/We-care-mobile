import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/app_custom_button.dart';
import 'package:we_care/core/global/SharedWidgets/design_logo_widget.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/routing/routes.dart';
import 'package:we_care/features/sign_up/Presentation/view_models/cubit/sign_up_cubit.dart';
import 'package:we_care/features/sign_up/Presentation/views/widgets/sign_up_form_fields_widget.dart';
import 'package:we_care/generated/l10n.dart';

class SignUpView extends StatelessWidget {
  const SignUpView({super.key});

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
              verticalSpacing(16),
              Text(
                S.of(context).createAccount,
                style: AppTextStyles.font22DarkRegular,
              ),
              SignUpFormFields(),
              // Submit Button
              AppCustomButton(
                title: S.of(context).createAccount,
                onPressed: () {
                  log("xxx: test button");
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
              verticalSpacing(33),
            ],
          ),
        ),
      ),
    );
  }
}
