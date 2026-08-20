import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:we_care/core/global/Helpers/font_weight_helper.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/app_strings.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/online_doctor/presentation/views/widgets/online_doctor_theme.dart';

/// عنوان حقل من حقول بيانات البطاقة — الأيقونة فى أول السطر والعنوان جنبها.
class CheckoutFieldLabel extends StatelessWidget {
  const CheckoutFieldLabel({
    super.key,
    required this.title,
    required this.iconAsset,
    this.iconSize = 22,
  });

  final String title;

  /// مسار الأيقونة داخل `assets/svgs`.
  final String iconAsset;

  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: iconSize.w,
          height: iconSize.h,
          child: SvgPicture.asset(iconAsset, fit: BoxFit.contain),
        ),
        horizontalSpacing(8),
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeightHelper.medium,
              fontFamily: AppStrings.cairoFontFamily,
              color: AppColorsManager.textColor,
              height: 25 / 18,
            ),
          ),
        ),
      ],
    );
  }
}

/// حقل كتابة بعرض الشاشة بنفس ستايل التصميم — خلفية متدرجة فاتحة وحدود رفيعة.
class CheckoutGradientTextField extends StatelessWidget {
  const CheckoutGradientTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.keyboardType,
    this.inputFormatters,
  });

  final TextEditingController controller;
  final String hintText;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48.h,
      decoration: BoxDecoration(
        gradient: OnlineDoctorTheme.sectionHeaderGradient,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          width: 0.8,
          color: AppColorsManager.textfieldOutsideBorderColor,
        ),
      ),
      alignment: Alignment.center,
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        style: _fieldTextStyle,
        decoration: InputDecoration(
          isCollapsed: true,
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16.w),
          hintText: hintText,
          hintStyle: _fieldTextStyle,
        ),
      ),
    );
  }

  static final _fieldTextStyle = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeightHelper.regular,
    fontFamily: AppStrings.cairoFontFamily,
    color: AppColorsManager.placeHolderColor,
    letterSpacing: 0.16,
  );
}

/// خانة صغيرة بأرقام فى المنتصف — لشهر وسنة الانتهاء ورمز الأمان.
class CheckoutPinBoxField extends StatelessWidget {
  const CheckoutPinBoxField({
    super.key,
    required this.controller,
    required this.width,
    required this.maxLength,
    this.focusNode,
    this.onChanged,
  });

  final TextEditingController controller;
  final double width;
  final int maxLength;
  final FocusNode? focusNode;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width.w,
      height: 54.h,
      decoration: BoxDecoration(
        gradient: OnlineDoctorTheme.sectionHeaderGradient,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          width: 0.6,
          color: AppColorsManager.textfieldOutsideBorderColor,
        ),
      ),
      alignment: Alignment.center,
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        onChanged: onChanged,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(maxLength),
        ],
        style: TextStyle(
          fontSize: 20.sp,
          fontWeight: FontWeightHelper.semiBold,
          fontFamily: AppStrings.cairoFontFamily,
          color: AppColorsManager.placeHolderColor,
          height: 27 / 20,
        ),
        decoration: InputDecoration(
          isCollapsed: true,
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 12.h),
        ),
      ),
    );
  }
}

/// بيسيب مسافة كل 4 أرقام فى رقم البطاقة — زى شكله المطبوع على البطاقة.
class CardNumberInputFormatter extends TextInputFormatter {
  static const _maxDigits = 16;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text.replaceAll(RegExp(r'\D'), '');
    if (digits.length > _maxDigits) return oldValue;

    final buffer = StringBuffer();
    for (int i = 0; i < digits.length; i++) {
      if (i > 0 && i % 4 == 0) buffer.write(' ');
      buffer.write(digits[i]);
    }
    final formatted = buffer.toString();
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
