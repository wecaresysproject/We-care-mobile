import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/functions.dart';

class CustomBackArrow extends StatelessWidget {
  const CustomBackArrow({super.key, this.onTap});

  final void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    // Check if the current locale is English

    return GestureDetector(
      onTap: () {
        if (onTap != null) {
          onTap!(); // <-- تنفيذه فعليًا
        }

        Navigator.of(context).pop(true);
      },
      child: Image.asset(
        !isArabic()
            ? "assets/images/back_arrow.png"
            : "assets/images/back_arrow_arabic.png",
        width: 40.w,
        height: 40.h,
      ),
    );
  }
}
