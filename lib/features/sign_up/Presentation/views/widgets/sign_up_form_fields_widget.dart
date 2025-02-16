import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/global/Helpers/app_regex.dart';
import '../../../../../core/global/Helpers/extensions.dart';
import '../../../../../core/global/Helpers/functions.dart';
import '../../../../../core/global/SharedWidgets/custom_textfield.dart';
import '../../../../../core/global/theming/app_text_styles.dart';
import '../../../../../core/global/theming/color_manager.dart';
import '../../../../../generated/l10n.dart';
import '../../../logic/sign_up_cubit.dart';
import 'password_validations_widget.dart';

class SignUpFormFields extends StatefulWidget {
  const SignUpFormFields({
    super.key,
  });

  @override
  State<SignUpFormFields> createState() => _SignUpFormFieldsState();
}

class _SignUpFormFieldsState extends State<SignUpFormFields> {
  bool hasbetween8and15 = false;
  bool hasSpecialCharacters = false;
  bool hasNumber = false;

  late TextEditingController passwordController;

  @override
  void initState() {
    super.initState();
    passwordController = context.read<SignUpCubit>().passwordController;
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

  @override
  Widget build(BuildContext context) {
    return Form(
      key: context.read<SignUpCubit>().formKey,
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: 16.h,
          horizontal: 20.w,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // First Name and Last Name
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        S.of(context).firstName,
                        style: AppTextStyles.font18blackWight500,
                      ),
                      verticalSpacing(8),
                      CustomTextField(
                        validator: (value) {
                          if (AppRegex.isOnlyWhiteSpaces(value!)) {
                            return S.of(context).white_spaces_validation;
                          }
                          if (value.isEmpty) {
                            return S.of(context).pleaseEnterYourName;
                          }
                        },
                        controller:
                            context.read<SignUpCubit>().firstNameController,
                        isPassword: false,
                        showSuffixIcon: false,
                        keyboardType: TextInputType.name,
                        hintText: S.of(context).enterFirstName,
                      )
                    ],
                  ),
                ),
                horizontalSpacing(10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        S.of(context).familyName,
                        style: AppTextStyles.font18blackWight500,
                      ),
                      verticalSpacing(8),
                      CustomTextField(
                        controller:
                            context.read<SignUpCubit>().lastNameController,
                        validator: (value) {
                          if (AppRegex.isOnlyWhiteSpaces(value!)) {
                            return S.of(context).white_spaces_validation;
                          }
                          if (value.isEmptyOrNull) {
                            return S.of(context).pleaseEnterYourName;
                          }
                        },
                        isPassword: false,
                        showSuffixIcon: false,
                        keyboardType: TextInputType.name,
                        hintText: S.of(context).enterLastName,
                      )
                    ],
                  ),
                ),
              ],
            ),
            verticalSpacing(16),
            // Country Code and Phone Number
            Text(
              S.of(context).mobileNumber,
              style: AppTextStyles.font18blackWight500,
            ),
            verticalSpacing(8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    height: 48.h,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: AppColorsManager.placeHolderColor.withAlpha(150),
                        width: 1.3,
                      ),
                      color:
                          AppColorsManager.textfieldInsideColor.withAlpha(100),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: CountryCodePicker(
                      flagWidth: 20.w,
                      onChanged: (value) {},
                      margin: EdgeInsets.only(
                        left: 0.w,
                      ),
                      initialSelection: 'EG',
                      favorite: ['+20', 'EG'],
                      showCountryOnly: true,
                      showOnlyCountryWhenClosed: true,
                      hideMainText: true,
                      // alignLeft: true,
                    ),
                  ),
                ),
                horizontalSpacing(10),
                Expanded(
                  flex: 3,
                  child: CustomTextField(
                    controller: context.read<SignUpCubit>().phoneController,
                    validator: (phoneNumber) {
                      if (phoneNumber.isEmptyOrNull) {
                        return S.of(context).pleaseEnterYourPhoneNum;
                      }
                      if (!AppRegex.isPhoneNumberValid(phoneNumber!)) {
                        return S.of(context).pleaseEnterYourCorrentPhoneNum;
                      }
                      // return null; // ✅ No error, validation passes
                    },
                    hintText: S.of(context).enterMobileNumber,
                    isPassword: false,
                    showSuffixIcon: false,
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            verticalSpacing(16),
            // Password Fields
            Text(
              S.of(context).password,
              style: AppTextStyles.font18blackWight500,
            ),
            verticalSpacing(8),
            CustomTextField(
              controller: context.read<SignUpCubit>().passwordController,
              validator: (password) {
                if (password.isEmptyOrNull) {
                  return S
                      .of(context)
                      .PleaseEnterYourPassword; // ✅ Correct error message
                }
                if (!AppRegex.hasSpecialCharacter(password!) ||
                    !AppRegex.lengthBetween8And15(password) ||
                    !AppRegex.hasNumber(password)) {
                  return S
                      .of(context)
                      .passwordMustContain; // ✅ Short & clear message
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
            verticalSpacing(8),
            CustomTextField(
              controller:
                  context.read<SignUpCubit>().passwordConfirmationController,
              validator: (value) {
                if (value.isEmptyOrNull) {
                  return S
                      .of(context)
                      .PleaseEnterYourPassword; // ✅ Correct error message
                }
                if (value !=
                    context.read<SignUpCubit>().passwordController.text) {
                  return S
                      .of(context)
                      .passwordNotMatch; // ✅ Ensure password match
                }
              },
              hintText: S.of(context).enterPassword,
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
            verticalSpacing(5),

            PasswordValidations(
              isbetween8and15Character: hasbetween8and15,
              hasNumber: hasNumber,
              hasSpecialCharacters: hasSpecialCharacters,
            ),
          ],
        ),
      ),
    );
  }
}
