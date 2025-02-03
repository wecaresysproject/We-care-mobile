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
import 'package:we_care/features/forget_password/Presentation/view_models/cubit/forget_password_cubit.dart';
import 'package:we_care/generated/l10n.dart';

class ForgetPasswordFormFields extends StatelessWidget {
  const ForgetPasswordFormFields({super.key});

  @override
  Widget build(BuildContext context) {
    return Form(
      key: context.read<ForgetPasswordCubit>().formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
                    color: AppColorsManager.textfieldInsideColor.withAlpha(100),
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
                  ),
                ),
              ),
              horizontalSpacing(10),
              Expanded(
                flex: 3,
                child: CustomTextField(
                  controller:
                      context.read<ForgetPasswordCubit>().phoneController,
                  validator: (phoneNumber) {
                    if (phoneNumber!.isEmptyOrNull) {
                      return S.of(context).pleaseEnterYourPhoneNum;
                    }
                    if (!AppRegex.isPhoneNumberValid(phoneNumber)) {
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
        ],
      ),
    );
  }
}
