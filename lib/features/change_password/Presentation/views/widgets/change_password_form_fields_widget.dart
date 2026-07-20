import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/app_regex.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/custom_textfield.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/features/change_password/Presentation/view_models/cubit/change_password_cubit.dart';
import 'package:we_care/features/sign_up/Presentation/views/widgets/password_validations_widget.dart';
import 'package:we_care/generated/l10n.dart';

class ChangePasswordFormFields extends StatefulWidget {
  const ChangePasswordFormFields({super.key});

  @override
  State<ChangePasswordFormFields> createState() =>
      _ChangePasswordFormFieldsState();
}

class _ChangePasswordFormFieldsState extends State<ChangePasswordFormFields> {
  bool hasbetween8and15 = false;
  bool hasSpecialCharacters = false;
  bool hasNumber = false;

  late TextEditingController passwordController;

  @override
  void initState() {
    super.initState();
    passwordController = context.read<ChangePasswordCubit>().passwordController;
    setupPasswordControllerListener();
  }

  void setupPasswordControllerListener() {
    passwordController.addListener(() {
      setState(() {
        hasbetween8and15 =
            AppRegex.lengthBetween8And15(passwordController.text);
        hasSpecialCharacters =
            AppRegex.hasSpecialCharacter(passwordController.text);
        hasNumber = AppRegex.hasNumber(passwordController.text);
      });
    });
  }

  final passWordMustContainEnglish =
      "The password must contain at least one uppercase letter, one number, and one special character.";
  final passordMustContainArabic =
      "كلمة المرور يجب أن تحتوي على حرف كبير، رقم، ورمز خاص على الأقل.";

  @override
  Widget build(BuildContext context) {
    return Form(
      key: context.read<ChangePasswordCubit>().formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Current Password field
          Text(
            S.of(context).currentPassword,
            style: AppTextStyles.font18blackWight500,
          ),
          verticalSpacing(12),
          CustomTextField(
            controller:
                context.read<ChangePasswordCubit>().currentPasswordController,
            validator: (password) {
              if (password.isEmptyOrNull) {
                return S.of(context).PleaseEnterYourPassword;
              }
              return null;
            },
            hintText: S.of(context).enterCurrentPassword,
            showSuffixIcon: true,
            isPassword: true,
            keyboardType: TextInputType.visiblePassword,
          ),
          verticalSpacing(16),

          // New Password and Confirm Password fields
          Text(
            S.of(context).new_password,
            style: AppTextStyles.font18blackWight500,
          ),
          verticalSpacing(12),
          CustomTextField(
            controller: context.read<ChangePasswordCubit>().passwordController,
            validator: (password) {
              if (password.isEmptyOrNull) {
                return S.of(context).PleaseEnterYourPassword;
              }
              if (!AppRegex.hasSpecialCharacter(password!) ||
                  !AppRegex.lengthBetween8And15(password) ||
                  !AppRegex.hasNumber(password)) {
                return isArabic()
                    ? passordMustContainArabic
                    : passWordMustContainEnglish;
              }
              return null;
            },
            hintText: S.of(context).enterPassword,
            showSuffixIcon: true,
            isPassword: true,
            keyboardType: TextInputType.visiblePassword,
          ),
          verticalSpacing(16),
          Text(
            S.of(context).confirm_new_password,
            style: AppTextStyles.font18blackWight500,
          ),
          verticalSpacing(12),
          CustomTextField(
            controller: context
                .read<ChangePasswordCubit>()
                .passwordConfirmationController,
            validator: (value) {
              if (value.isEmptyOrNull) {
                return S.of(context).PleaseEnterYourPassword;
              }
              if (value !=
                  context.read<ChangePasswordCubit>().passwordController.text) {
                return S.of(context).passwordNotMatch;
              }
              return null;
            },
            hintText: S.of(context).confirm_new_password,
            showSuffixIcon: true,
            isPassword: true,
            keyboardType: TextInputType.visiblePassword,
          ),
          verticalSpacing(8),
          Text(
            S.of(context).passwordHint,
            style: AppTextStyles.font12blackWeight400.copyWith(
              fontSize: 14.sp,
            ),
          ),
          verticalSpacing(4),

          PasswordValidations(
            isbetween8and15Character: hasbetween8and15,
            hasNumber: hasNumber,
            hasSpecialCharacters: hasSpecialCharacters,
          ),
        ],
      ),
    );
  }
}
