import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DesignLogoWidget extends StatelessWidget {
  const DesignLogoWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 126.w,
      height: 93.h,
      child: DecoratedBox(
        decoration: ShapeDecoration(
          image: const DecorationImage(
            image: AssetImage("assets/images/design_logo.png"),
            fit: BoxFit.cover,
          ),
          shape: OutlineInputBorder(
            borderRadius: BorderRadius.circular(32.r),
            borderSide: BorderSide(
              width: 1.001,
              color: Colors.grey.shade400,
            ),
          ),
        ),
      ),
    );
  }
}
