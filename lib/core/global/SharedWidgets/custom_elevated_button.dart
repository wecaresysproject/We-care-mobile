import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';

class CustomElevatedButton extends StatelessWidget {
  const CustomElevatedButton({
    super.key,
    required this.text,
    required this.onPressed,
  });
  final String text;
  final void Function()? onPressed;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        alignment: Alignment.center,
        elevation: 3,
        fixedSize: Size(
          105.w,
          20.h,
        ),
        padding: EdgeInsets.symmetric(
          vertical: 9.h,
          horizontal: 11.w,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            16.r,
          ),
        ),
      ),
      child: Text(
        text,
        style: AppTextStyles.font16DarkGreyWeight400.copyWith(
          fontWeight: FontWeight.w600,
          color: Color(0xffFEFEFE),
        ),
      ),
    );
  }
}
