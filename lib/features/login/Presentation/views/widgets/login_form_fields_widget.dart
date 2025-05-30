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
import '../../../../../core/routing/routes.dart';
import '../../../../../generated/l10n.dart';
import '../../../logic/cubit/login_cubit.dart';

class LoginFormFields extends StatelessWidget {
  const LoginFormFields({super.key});
  final passWordMustContainEnglish =
      "The password must contain at least one uppercase letter, one number, and one special character.";
  final passordMustContainArabic =
      "كلمة المرور يجب أن تحتوي على حرف كبير، رقم، ورمز خاص على الأقل.";
  @override
  Widget build(BuildContext context) {
    return Form(
      key: context.read<LoginCubit>().formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            verticalSpacing(16),
            // Country Code and Phone Number
            Text(
              S.of(context).mobileNumber,
              style: AppTextStyles.font18blackWight500,
            ),
            verticalSpacing(16),
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
                      onChanged: (countryCode) {
                        context
                            .read<LoginCubit>()
                            .onDialCodeChanged(countryCode);
                      },
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
                BlocBuilder<LoginCubit, LoginState>(
                  buildWhen: (previous, current) =>
                      previous.dialCode != current.dialCode,
                  builder: (context, state) {
                    return Expanded(
                      flex: 3,
                      child: CustomTextField(
                        controller: context.read<LoginCubit>().phoneController,
                        validator: (phoneNumber) {
                          if (phoneNumber.isEmptyOrNull) {
                            return S.of(context).pleaseEnterYourPhoneNum;
                          }
                          if (!AppRegex.isPhoneNumberValid(phoneNumber!)) {
                            return S.of(context).pleaseEnterYourCorrentPhoneNum;
                          }
                          // return null; // ✅ No error, validation passes
                        },
                        hintText: state.dialCode,
                        isPassword: false,
                        showSuffixIcon: false,
                        keyboardType: TextInputType.number,
                      ),
                    );
                  },
                ),
              ],
            ),

            verticalSpacing(32),
            // Password Fields
            Text(
              S.of(context).password,
              style: AppTextStyles.font18blackWight500,
            ),
            verticalSpacing(16),
            CustomTextField(
              controller: context.read<LoginCubit>().passwordController,
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
            GestureDetector(
              onTap: () async {
                await context.pushNamed(Routes.forgetPasswordView);
              },
              child: Align(
                alignment:
                    isArabic() ? Alignment.bottomLeft : Alignment.bottomRight,
                child: Text(
                  S.of(context).forgotPassword,
                  style: AppTextStyles.font18blackWight500.copyWith(
                    color: AppColorsManager.mainDarkBlue,
                  ),
                ),
              ),
            ),

            verticalSpacing(8),
          ],
        ),
      ),
    );
  }
}
