import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/custom_textfield.dart';
import 'package:we_care/core/global/theming/color_manager.dart';

/// Country-code selector + phone number input, used for both the
/// professional mobile and the app-contact mobile fields.
class BasicDataPhoneWithCountryCodeField extends StatelessWidget {
  const BasicDataPhoneWithCountryCodeField({
    super.key,
    required this.controller,
    required this.onCountryCodeChanged,
  });

  final TextEditingController controller;
  final ValueChanged<String> onCountryCodeChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
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
              onChanged: (value) =>
                  onCountryCodeChanged(value.dialCode ?? '+20'),
              margin: EdgeInsets.only(left: 0.w),
              initialSelection: 'EG',
              favorite: const ['+20', 'EG'],
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
            controller: controller,
            validator: (phoneNumber) {
              if (phoneNumber.isEmptyOrNull) {
                return context.translate.pleaseEnterYourPhoneNum;
              }
              return null;
            },
            hintText: context.translate.enterMobileNumber,
            keyboardType: TextInputType.number,
          ),
        ),
      ],
    );
  }
}
