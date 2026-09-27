import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';

/// One "price" box from the examination-price mock: a label above a
/// bordered container holding a fixed currency badge (flag/globe glyph +
/// currency code) and an amount input.
class CurrencyAmountFieldWidget extends StatelessWidget {
  const CurrencyAmountFieldWidget({
    super.key,
    required this.label,
    required this.currencyGlyph,
    required this.currencyCode,
    required this.controller,
    this.validator,
  });

  final String label;
  final Widget currencyGlyph;
  final String currencyCode;
  final TextEditingController controller;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          textAlign: TextAlign.center,
          style: AppTextStyles.font14blackWeight600,
        ),
        verticalSpacing(8),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          decoration: BoxDecoration(
            color: AppColorsManager.textfieldInsideColor.withAlpha(100),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: AppColorsManager.placeHolderColor.withAlpha(150),
              width: 1.3,
            ),
          ),
          child: Row(
            children: [
              currencyGlyph,
              horizontalSpacing(6),
              Text(
                currencyCode,
                style: AppTextStyles.font14blackWeight600,
              ),
              Icon(
                Icons.keyboard_arrow_down,
                size: 18.r,
                color: AppColorsManager.placeHolderColor,
              ),
              Expanded(
                child: TextFormField(
                  controller: controller,
                  onTapOutside: (_) =>
                      FocusManager.instance.primaryFocus?.unfocus(),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: validator,
                  textAlign: TextAlign.end,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                        RegExp(r'^\d*\.?\d{0,2}')),
                  ],
                  cursorColor: AppColorsManager.mainDarkBlue,
                  style: AppTextStyles.font20blackWeight700,
                  decoration: InputDecoration(
                    isDense: true,
                    hintText: '0',
                    hintStyle: AppTextStyles.font20blackWeight700.copyWith(
                      color: AppColorsManager.placeHolderColor,
                    ),
                    contentPadding: EdgeInsets.symmetric(vertical: 14.h),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    focusedErrorBorder: InputBorder.none,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
