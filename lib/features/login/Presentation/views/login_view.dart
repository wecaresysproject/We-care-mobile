import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_care/core/di/dependency_injection.dart';
import 'package:we_care/core/global/Helpers/custom_rich_text.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/app_custom_button.dart';
import 'package:we_care/core/global/SharedWidgets/design_logo_widget.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/routing/routes.dart';
import 'package:we_care/features/login/Presentation/view_models/cubit/cubit/login_cubit.dart';
import 'package:we_care/features/login/Presentation/views/widgets/login_form_fields_widget.dart';
import 'package:we_care/generated/l10n.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<LoginCubit>(
      create: (context) => getIt<LoginCubit>(),
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
                  S.of(context).login,
                  style: AppTextStyles.font22MainBlueWeight700,
                ),
                //! Login Form fields here
                LoginFormFields(),
                verticalSpacing(88),
                // Submit Button
                AppCustomButton(
                  title: S.of(context).login,
                  isEnabled: true,
                  onPressed: () {
                    if (context
                        .read<LoginCubit>()
                        .formKey
                        .currentState!
                        .validate()) {
                      context.read<LoginCubit>().emitLoginStates();

                      context.pushNamed(Routes.otpView);
                    }
                  },
                ).paddingSymmetricHorizontal(
                  16,
                ),
                verticalSpacing(56),

                /// dont have an account
                CustomUnderlinedRichTextWidget(
                  normalText: S.of(context).dontHaveAccount,
                  highlightedText: S.of(context).createAccount,
                  onTap: () {
                    context.pop();
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
}
