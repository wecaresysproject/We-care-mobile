import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/app_regex.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/custom_textfield.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/features/create_new_password/Presentation/view_models/cubit/create_new_password_cubit.dart';
import 'package:we_care/features/sign_up/Presentation/views/widgets/password_validations_widget.dart';
import 'package:we_care/generated/l10n.dart';

//!TODO: handle using import from sign up feature for password validation
class CreateNewPasswordFormFields extends StatefulWidget {
  const CreateNewPasswordFormFields({super.key});

  @override
  State<CreateNewPasswordFormFields> createState() =>
      _CreateNewPasswordFormFieldsState();
}

class _CreateNewPasswordFormFieldsState
    extends State<CreateNewPasswordFormFields> {
  bool hasbetween8and15 = false;
  bool hasSpecialCharacters = false;
  bool hasNumber = false;

  late TextEditingController passwordController;

  @override
  void initState() {
    super.initState();
    passwordController =
        context.read<CreateNewPasswordCubit>().passwordController;
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
      key: context.read<CreateNewPasswordCubit>().formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // New Password and Confirm Password fields
          Text(
            S.of(context).password,
            style: AppTextStyles.font18blackWight500,
          ),
          verticalSpacing(12),
          CustomTextField(
            controller:
                context.read<CreateNewPasswordCubit>().passwordController,
            validator: (password) {
              if (password.isEmptyOrNull) {
                return S
                    .of(context)
                    .PleaseEnterYourPassword; // ✅ Correct error message
              }
              if (!AppRegex.hasSpecialCharacter(password!) ||
                  !AppRegex.lengthBetween8And15(password) ||
                  !AppRegex.hasNumber(password)) {
                return isArabic()
                    ? passordMustContainArabic
                    : passWordMustContainEnglish;
              }
              return null; // ✅ No error
            },
            hintText: S.of(context).enterPassword,
            showSuffixIcon: true,
            isPassword: true,
            keyboardType: TextInputType.visiblePassword,
          ),
          verticalSpacing(16),
          Text(
            S.of(context).confirmPassword,
            style: AppTextStyles.font18blackWight500,
          ),
          verticalSpacing(12),
          CustomTextField(
            controller: context
                .read<CreateNewPasswordCubit>()
                .passwordConfirmationController,
            validator: (value) {
              if (value.isEmptyOrNull) {
                return S
                    .of(context)
                    .PleaseEnterYourPassword; // ✅ Correct error message
              }
              if (value !=
                  context
                      .read<CreateNewPasswordCubit>()
                      .passwordController
                      .text) {
                return S
                    .of(context)
                    .passwordNotMatch; // ✅ Ensure password match
              }
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
