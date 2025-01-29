import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';

class CustomTextField extends StatefulWidget {
  final String hintText;
  final bool isPassword;
  final bool showSuffixIcon;
  final TextInputType keyboardType;
  final TextEditingController? controller;
  final Function(String?) validator;
  const CustomTextField({
    super.key,
    required this.hintText,
    this.isPassword = false,
    this.showSuffixIcon = false,
    this.keyboardType = TextInputType.text,
    this.controller,
    required this.validator,
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
      keyboardType: widget.keyboardType,
      obscureText: widget.isPassword && _obscureText,
      enableInteractiveSelection: true, // ✅ Allow text selection
      decoration: InputDecoration(
        hintText: widget.hintText,
        // contentPadding:
        //     EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        isDense: true,
        constraints: BoxConstraints(
          minHeight: 48.h,
          maxHeight: 48.h + 20.h,
        ),
        // errorText: errorText,
        //! ✅ Focused border (when user taps on it)
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: ColorsManager.placeHolderColor,
            width: 1.3,
          ),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        //! ✅ Error border (when validation fails) - same as enabledBorder but red
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: ColorsManager.warningColor, // Red color
            width: 1.3, // Same thickness
          ),
        ),
        //! ✅ Focused Error border (when user clicks on invalid field)
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: ColorsManager.warningColor, // Red color
            width: 1.3, // Same thickness
          ),
        ),
        //! ✅ Default border (Enabled)
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: ColorsManager.placeHolderColor.withAlpha(150),
            width: 1.3, // Same thickness
          ),
        ),

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: ColorsManager.warningColor, // Red color
            // width: 1.5, // Same thickness
            width: 1.3, // Same thickness
          ),
        ),
        fillColor: ColorsManager.textfieldInsideColor.withAlpha(100),
        filled: true,
        prefixIcon: widget.isPassword
            ? Icon(
                Icons.lock,
                color: ColorsManager.placeHolderColor,
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
                ),
              )
            : null,
      ),
      style: AppTextStyles.font16DarkGreyRegular,
    );
  }
}
