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
import '../../../../core/global/theming/app_text_styles.dart';
import '../../../../core/routing/routes.dart';
import '../../../../generated/l10n.dart';
import '../../logic/cubit/login_cubit.dart';
import 'widgets/login_form_fields_widget.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<LoginCubit>(
      create: (_) => getIt<LoginCubit>(),
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
                BlocConsumer<LoginCubit, LoginState>(
                  listenWhen: (prev, curr) =>
                      curr.loginStatus == RequestStatus.failure ||
                      curr.loginStatus == RequestStatus.success,
                  listener: (context, state) async {
                    if (state.loginStatus == RequestStatus.success) {
                      await showSuccess(state.message);
                      if (!context.mounted) return;
                      await context.pushReplacementNamed(
                        Routes.bottomNavBar,
                      );
                    } else if (state.loginStatus == RequestStatus.failure) {
                      await showError(state.message);
                    }
                  },
                  builder: (context, state) {
                    return AppCustomButton(
                      isLoading: state.loginStatus == RequestStatus.loading,
                      title: S.of(context).login,
                      isEnabled: true,
                      onPressed: () async {
                        if (context
                            .read<LoginCubit>()
                            .formKey
                            .currentState!
                            .validate()) {
                          await context.read<LoginCubit>().emitLoginStates();
                        }
                      },
                    );
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
                    context.pushNamed(Routes.signUpView);
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
