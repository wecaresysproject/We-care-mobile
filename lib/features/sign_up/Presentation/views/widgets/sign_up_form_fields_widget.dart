import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/app_regex.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/custom_textfield.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/sign_up/Presentation/view_models/cubit/sign_up_cubit.dart';
import 'package:we_care/generated/l10n.dart';

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
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
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
                        style: AppTextStyles.font18blackRegular,
                      ),
                      verticalSpacing(12),
                      CustomTextField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return S
                                .of(context)
                                .pleaseEnterYourName; //TODo: handle it in l10 file
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
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        S.of(context).familyName,
                        style: AppTextStyles.font18blackRegular,
                      ),
                      verticalSpacing(12),
                      CustomTextField(
                        controller:
                            context.read<SignUpCubit>().lastNameController,
                        validator: (value) {
                          if (value.isEmptyOrNull) {
                            return S
                                .of(context)
                                .pleaseEnterYourName; //TODo: handle it in l10 file
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
              style: AppTextStyles.font18blackRegular,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: ColorsManager.placeHolderColor.withAlpha(150),
                        width: 1.3,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: CountryCodePicker(
                      flagWidth: 20.w,
                      onChanged: (value) {},
                      initialSelection: 'IT',
                      favorite: ['+39', 'FR'],
                      showCountryOnly: false,
                      showOnlyCountryWhenClosed: true,
                      alignLeft: true,
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
              style: AppTextStyles.font18blackRegular,
            ),
            verticalSpacing(12),
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
              style: AppTextStyles.font18blackRegular,
            ),
            verticalSpacing(12),
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
              style: AppTextStyles.font12blackRegular.copyWith(
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
      ),
    );
  }
}

class PasswordValidations extends StatelessWidget {
  final bool isbetween8and15Character;
  final bool hasSpecialCharacters;
  final bool hasNumber;
  const PasswordValidations({
    super.key,
    required this.isbetween8and15Character,
    required this.hasSpecialCharacters,
    required this.hasNumber,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        buildValidationRow(
            S.of(context).passwordHint1, isbetween8and15Character),
        verticalSpacing(5),
        buildValidationRow(S.of(context).passwordHint2, hasSpecialCharacters),
        verticalSpacing(5),
        buildValidationRow(S.of(context).passwordHint3, hasNumber),
        verticalSpacing(5),
      ],
    );
  }

  Widget buildValidationRow(String text, bool hasValidated) {
    return Row(
      children: [
        CircleAvatar(
          backgroundColor: Color(0xff909090).withAlpha(100),
          radius: 12,
          child: CircleAvatar(
            radius: 6,
            backgroundColor: hasValidated
                ? ColorsManager.doneColor
                : ColorsManager.warningColor,
          ),
        ),
        horizontalSpacing(6),
        Text(
          text,
          style: AppTextStyles.font12blackRegular.copyWith(
            decorationColor: Colors.green,
            decorationThickness: 2,
          ),
        )
      ],
    );
  }
}
