import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomAppBackArrow extends StatelessWidget {
  const CustomAppBackArrow({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pop();
      },
      child: Container(
        width: 38.w, // Set fixed width
        height: 38.h, // Set fixed height
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.r),
          color: Color(0xffDAE9FA),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(70), // Shadow color
              blurRadius: 2, // Blur effect
              spreadRadius: 1, // Spread to make it softer
              offset: const Offset(2, 2.25), // Positioning of shadow
            ),
          ],
        ),
        child: Center(
          child: Image.asset(
            "assets/images/back_arrow.png",
            cacheHeight: 19,
            cacheWidth: 17,
            alignment: Alignment.center,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
