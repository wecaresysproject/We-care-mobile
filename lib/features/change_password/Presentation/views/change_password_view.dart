import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/di/dependency_injection.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/app_toasts.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/app_custom_button.dart';
import 'package:we_care/core/global/SharedWidgets/design_logo_widget.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/features/change_password/Presentation/view_models/cubit/change_password_cubit.dart';
import 'package:we_care/features/change_password/Presentation/views/widgets/change_password_form_fields_widget.dart';
import 'package:we_care/generated/l10n.dart';

class ChangePasswordView extends StatefulWidget {
  const ChangePasswordView({super.key});

  @override
  State<ChangePasswordView> createState() => _ChangePasswordViewState();
}

class _ChangePasswordViewState extends State<ChangePasswordView> {
  late ChangePasswordCubit changePasswordCubit;

  @override
  void initState() {
    changePasswordCubit = getIt.get<ChangePasswordCubit>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ChangePasswordCubit>(
      create: (context) => changePasswordCubit,
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
                  S.of(context).changePassword,
                  style: AppTextStyles.font22MainBlueWeight700,
                ),
                verticalSpacing(16),

                ChangePasswordFormFields(),

                // Submit Button
                BlocConsumer<ChangePasswordCubit, ChangePasswordState>(
                  listener: (context, state) async {
                    if (state.changePasswordStatus == RequestStatus.success) {
                      await showSuccess(
                        S.of(context).passwordChangedSuccessfully,
                      );
                      if (!context.mounted) return;
                      Navigator.of(context).pop();
                    } else if (state.changePasswordStatus ==
                        RequestStatus.failure) {
                      await showError(state.message ?? '');
                    }
                  },
                  builder: (context, state) => AppCustomButton(
                    title: S.of(context).save,
                    isEnabled: true,
                    isLoading:
                        state.changePasswordStatus == RequestStatus.loading,
                    onPressed: () {
                      if (changePasswordCubit.formKey.currentState!
                          .validate()) {
                        changePasswordCubit.changePassword();
                      }
                    },
                  ),
                ).paddingFrom(
                  top: context.screenHeight * 0.12,
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
