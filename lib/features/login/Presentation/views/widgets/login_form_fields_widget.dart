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
import 'package:we_care/features/login/Presentation/view_models/cubit/cubit/login_cubit.dart';
import 'package:we_care/generated/l10n.dart';

class LoginFormFields extends StatelessWidget {
  const LoginFormFields({super.key});

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
                    hintText: S.of(context).enterMobileNumber,
                    isPassword: false,
                    showSuffixIcon: false,
                    keyboardType: TextInputType.number,
                  ),
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
            Align(
              alignment:
                  isArabic() ? Alignment.bottomLeft : Alignment.bottomRight,
              child: Text(
                S.of(context).forgotPassword,
                style: AppTextStyles.font18blackWight500.copyWith(
                  color: AppColorsManager.mainDarkBlue,
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
