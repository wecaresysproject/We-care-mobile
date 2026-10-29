import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/custom_textfield.dart';
import 'package:we_care/core/global/theming/color_manager.dart';

/// Country-code selector + phone number input, used for both the
/// professional mobile and the app-contact mobile fields.
class BasicDataPhoneWithCountryCodeField extends StatefulWidget {
  const BasicDataPhoneWithCountryCodeField({
    super.key,
    required this.controller,
    required this.onCountryCodeChanged,
    this.initialCountryCode,
  });

  final TextEditingController controller;
  final ValueChanged<String> onCountryCodeChanged;

  /// Dial code to pre-select, e.g. `+20` loaded from the server. Read once
  /// when the field is created; defaults to Egypt.
  final String? initialCountryCode;

  @override
  State<BasicDataPhoneWithCountryCodeField> createState() =>
      _BasicDataPhoneWithCountryCodeFieldState();
}

class _BasicDataPhoneWithCountryCodeFieldState
    extends State<BasicDataPhoneWithCountryCodeField> {
  // Kept fixed after creation: passing the current dial code on every rebuild
  // would make the picker jump to the first country sharing that code (e.g.
  // picking Canada `+1` would switch back to the US).
  late final String _initialSelection =
      (widget.initialCountryCode?.isNotEmpty ?? false)
          ? widget.initialCountryCode!
          : 'EG';

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
                  widget.onCountryCodeChanged(value.dialCode ?? '+20'),
              margin: EdgeInsets.only(left: 0.w),
              initialSelection: _initialSelection,
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
            controller: widget.controller,
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
