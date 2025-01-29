import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/app_custom_button.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/routing/routes.dart';
import 'package:we_care/features/sign_up/Presentation/view_models/cubit/sign_up_cubit.dart';
import 'package:we_care/features/sign_up/Presentation/views/widgets/sign_up_form_fields_widget.dart';
import 'package:we_care/generated/l10n.dart';

class SignUpView extends StatelessWidget {
  const SignUpView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      // BlocProvider<SignUpCubit>( //TODO: recheck this
      // create: (_) => getIt.get<SignUpCubit>(),
      top: false,
      child: Scaffold(
        appBar: AppBar(),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // const SizedBox(height: 8),
                verticalSpacing(8),
                SizedBox(
                  width: 116,
                  height: 113,
                  child: DecoratedBox(
                    decoration: ShapeDecoration(
                      image: const DecorationImage(
                        image: AssetImage("assets/images/sign_up_logo.png"),
                        fit: BoxFit.cover,
                      ),
                      shape: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(40),
                        borderSide: BorderSide(
                          width: 1.001,
                          color: Colors.grey.shade400,
                        ),
                      ),
                    ),
                  ),
                ),
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

                      context.pushNamed(Routes.pinFieldsView);
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
      ),
    );
  }
}

class PinFieldsView extends StatelessWidget {
  const PinFieldsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Pin fields view',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
