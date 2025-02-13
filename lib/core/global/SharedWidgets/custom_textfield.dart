import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';

class CustomTextField extends StatefulWidget {
  final String hintText;
  final bool isPassword;
  final bool showSuffixIcon;
  final TextInputType keyboardType;
  final TextEditingController? controller;
  final Function(String?) validator;
  final List<TextInputFormatter>? inputFormatters;
  final FocusNode? focusNode;
  final void Function(String)? onChanged;
  const CustomTextField({
    super.key,
    required this.hintText,
    this.isPassword = false,
    this.showSuffixIcon = false,
    this.keyboardType = TextInputType.text,
    this.controller,
    this.inputFormatters,
    this.focusNode,
    required this.validator,
    this.onChanged,
  });

  @override
  CustomTextFieldState createState() => CustomTextFieldState();
}

class CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = true;
  String? errorText;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: widget.controller,

      validator: (value) {
        errorText = widget.validator(value);

        return widget.validator(value);
      },
      onChanged: widget.onChanged,
      cursorColor: AppColorsManager.mainDarkBlue,
      cursorErrorColor: AppColorsManager.warningColor,

      keyboardType: widget.keyboardType,
      obscureText: widget.isPassword && _obscureText,
      enableInteractiveSelection: true, // ✅ Allow text selection
      inputFormatters: widget.inputFormatters,
      focusNode: widget.focusNode,
      decoration: InputDecoration(
        hintText: widget.hintText,

        hintStyle: AppTextStyles.font16DarkGreyWeight400,

        // isDense: true,
        constraints: BoxConstraints(
          minHeight: 48.h,
          maxHeight: 48.h + 20.h,
        ),
        // errorText: errorText,
        //! ✅ Focused border (when user taps on it)
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(
            color: AppColorsManager.mainDarkBlue,
            width: 1.3,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 14,
        ),
        //! ✅ Error border (when validation fails) - same as enabledBorder but red
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(
            color: AppColorsManager.warningColor, // Red color
            width: 1.3, // Same thickness
          ),
        ),
        //! ✅ Focused Error border (when user clicks on invalid field)
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(
            color: AppColorsManager.warningColor, // Red color
            width: 1.3, // Same thickness
          ),
        ),
        //! ✅ Default border (Enabled)
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(
            color: AppColorsManager.placeHolderColor.withAlpha(150),
            width: 1.3, // Same thickness
          ),
        ),

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(
            color: AppColorsManager.warningColor, // Red color
            width: 1.3, // Same thickness
          ),
        ),
        fillColor: AppColorsManager.textfieldInsideColor.withAlpha(100),
        filled: true,
        prefixIcon: widget.isPassword
            ? Icon(
                Icons.lock,
                color: AppColorsManager.placeHolderColor,
              ).paddingFrom(
                right: isArabic() ? 14 : 0,
              )
            : null,
        suffixIcon: widget.isPassword
            ? GestureDetector(
                onTap: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
                child: Icon(
                  _obscureText ? Icons.visibility_off : Icons.visibility,
                  color: _obscureText
                      ? Colors.grey
                      : AppColorsManager.mainDarkBlue,
                ),
              )
            : null,
      ),
      style: AppTextStyles.font16DarkGreyWeight400.copyWith(
        color: AppColorsManager.textColor,
      ),
    );
  }
}

class WordLimitInputFormatter extends TextInputFormatter {
  final int maxWords;

  WordLimitInputFormatter({required this.maxWords});

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    int wordCount = _countWords(newValue.text);

    if (wordCount > maxWords) {
      return oldValue; // Reject new input if it exceeds the word limit
    }

    return newValue; // Accept new input if within limit
  }

  int _countWords(String text) {
    List<String> words = text.trim().split(RegExp(r'\s+'));
    return words.isEmpty || words.first == "" ? 0 : words.length;
  }
}
