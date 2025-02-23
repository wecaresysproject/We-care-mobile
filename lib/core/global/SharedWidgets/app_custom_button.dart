import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

import '../theming/app_text_styles.dart';
import '../theming/color_manager.dart';

class AppCustomButton extends StatelessWidget {
  const AppCustomButton({
    super.key,
    required this.title,
    this.onPressed,
    this.isEnabled = false,
    this.isLoading = false,
  });
  final String title;
  final void Function()? onPressed;
  final bool isEnabled;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor:
            isEnabled ? AppColorsManager.mainDarkBlue : Color(0xff2F6C9F),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        minimumSize: const Size(double.infinity, 50),
      ),
      child: isLoading
          ? Lottie.asset(
              'assets/svgs/loading_animation.json',
              height: 50.h,
              width: 50.w,
              fit: BoxFit.contain,
              alignment: Alignment.center,
              repeat: true,
            )
          : Text(
              title,
              style: AppTextStyles.font22MainBlueWeight700.copyWith(
                color: Colors.white,
              ),
            ),
    );
  }
}
