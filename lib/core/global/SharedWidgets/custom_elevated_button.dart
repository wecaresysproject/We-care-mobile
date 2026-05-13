import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';

class CustomElevatedButton extends StatelessWidget {
  const CustomElevatedButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isInactive = false,
  });
  final String text;
  final void Function()? onPressed;
  final bool isInactive;

  @override
  Widget build(BuildContext context) {
    Widget button = ElevatedButton(
      onPressed: isInactive ? null : onPressed,
      style: ElevatedButton.styleFrom(
        alignment: Alignment.center,
        elevation: 3,
        fixedSize: Size(
          105.w,
          20.h,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            16.r,
          ),
        ),
      ),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          text,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: AppTextStyles.font16DarkGreyWeight400.copyWith(
            fontWeight: FontWeight.w600,
            color: const Color(0xffFEFEFE),
          ),
        ),
      ),
    );

    if (isInactive) {
      button = IgnorePointer(
        child: Container(
          foregroundDecoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.r),
          ),
          color: Colors.grey.withValues(alpha: 0.1),
          child: button,
        ),
      );
    }

    return button;
  }
}
