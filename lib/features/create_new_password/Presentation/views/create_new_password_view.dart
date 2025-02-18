import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/di/dependency_injection.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/app_custom_button.dart';
import 'package:we_care/core/global/SharedWidgets/design_logo_widget.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/routing/routes.dart';
import 'package:we_care/features/create_new_password/Presentation/view_models/cubit/create_new_password_cubit.dart';
import 'package:we_care/features/create_new_password/Presentation/views/widgets/create_new_password_form_fields_widget.dart';
import 'package:we_care/generated/l10n.dart';

import '../../../../core/global/Helpers/app_enums.dart';
import '../../../../core/global/Helpers/app_toasts.dart';

class CreateNewPasswordView extends StatefulWidget {
  final String phoneNumber;
  const CreateNewPasswordView({super.key, required this.phoneNumber});

  @override
  State<CreateNewPasswordView> createState() => _CreateNewPasswordViewState();
}

class _CreateNewPasswordViewState extends State<CreateNewPasswordView> {
  late CreateNewPasswordCubit createNewPasswordCubit;
  @override
  void initState() {
    createNewPasswordCubit = getIt.get<CreateNewPasswordCubit>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CreateNewPasswordCubit>(
      create: (context) => createNewPasswordCubit,
      child: Scaffold(
        appBar: AppBar(),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: 16.w,
            vertical: 20,
          ),
          physics: const BouncingScrollPhysics(),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                verticalSpacing(8),
                DesignLogoWidget(),
                verticalSpacing(16),
                Text(
                  S.of(context).create_new_password,
                  style: AppTextStyles.font22MainBlueWeight700,
                ),

                CreateNewPasswordFormFields(),

                // Submit Button
                BlocConsumer<CreateNewPasswordCubit, CreateNewPasswordState>(
                  listener: (context, state) async {
                    if (state.createNewPasswordStatus ==
                        RequestStatus.success) {
                      await showSuccess(state.message!);
                      if (!context.mounted) return;
                      await context.pushNamed(
                        Routes.loginView,
                      );
                    } else if (state.createNewPasswordStatus ==
                        RequestStatus.failure) {
                      await showError(state.message!);
                    }
                  },
                  builder: (context, state) => AppCustomButton(
                    title: S.of(context).createAccount,
                    isEnabled: true,
                    isLoading:
                        state.createNewPasswordStatus == RequestStatus.loading,
                    onPressed: () async {
                      createNewPasswordCubit.emitCreateNewPasswordStates(
                        widget.phoneNumber,
                      );
                    },
                  ),
                ).paddingFrom(
                  top: context.screenHeight * 0.19,
                ),
                verticalSpacing(24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
