import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BasicDataCategoryWidget extends StatelessWidget {
  const BasicDataCategoryWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 72.h,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32.r),
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomLeft,
          colors: [
            Color(0xFFCDE1F8),
            Color(0xFFCDE1F8),
            Color(0xFFE7E9EB),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(100),
            offset: const Offset(2.5, 4),
            blurRadius: 4,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Center(
        child: Image.asset(
          "assets/images/pin_edit_icon.png",
          fit: BoxFit.contain,
          width: 57.w,
          height: 40.h,
        ),
      ),
    );
  }
}
