import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';

/// Multi-line free-text field styled like the app's `CustomTextField`
/// (which is fixed to one line).
class PrescriptionMultilineTextField extends StatelessWidget {
  const PrescriptionMultilineTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.onChanged,
    this.minLines = 3,
    this.maxLines = 6,
  });

  final TextEditingController controller;
  final String hintText;
  final ValueChanged<String>? onChanged;
  final int minLines;
  final int maxLines;

  OutlineInputBorder _border(Color color) => OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide(color: color, width: 1.3),
      );

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      minLines: minLines,
      maxLines: maxLines,
      keyboardType: TextInputType.multiline,
      textInputAction: TextInputAction.newline,
      cursorColor: AppColorsManager.mainDarkBlue,
      onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
      style: AppTextStyles.font16DarkGreyWeight400.copyWith(
        color: AppColorsManager.textColor,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: AppTextStyles.font16DarkGreyWeight400,
        filled: true,
        fillColor: AppColorsManager.textfieldInsideColor.withAlpha(100),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 14,
        ),
        enabledBorder:
            _border(AppColorsManager.placeHolderColor.withAlpha(150)),
        focusedBorder: _border(AppColorsManager.mainDarkBlue),
      ),
    );
  }
}
