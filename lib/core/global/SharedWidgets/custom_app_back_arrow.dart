import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/functions.dart';

class CustomAppBackArrow extends StatelessWidget {
  const CustomAppBackArrow({super.key});

  @override
  Widget build(BuildContext context) {
    // Check if the current locale is English

    return GestureDetector(
      onTap: () {
        Navigator.of(context).pop();
      },
      child: Transform.rotate(
        angle: !isArabic()
            ? 180 * 3.1415926535 / 180
            : 0, // Rotate 180° if English
        child: Image.asset(
          "assets/images/back_arrow.png",
          width: 40.w,
          height: 40.h,
        ),
      ),
    );
  }
}
