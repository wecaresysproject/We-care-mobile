import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/routing/routes.dart';

class CustomImageWithTextButton extends StatelessWidget {
  final String text;
  final String imagePath;
  final TextStyle? textStyle;

  const CustomImageWithTextButton({
    super.key,
    required this.text,
    required this.imagePath,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        //TODO: call bloc from this point to save user type in order to use it later in the app when making any request
        context.pushNamed(Routes.signUpView);
      },
      child: Container(
        height: 52.h,
        width: double.infinity,
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(
          vertical: 8,
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xff24659A),
              Color(0xff014C8A),
            ], // Gradient color
            begin: Alignment.topLeft,
            end: Alignment.topRight,
          ),
          borderRadius: BorderRadius.circular(20.r), // Rounded edges
          boxShadow: [
            BoxShadow(
              color: Colors.black26, // Shadow color
              blurRadius: 8,
              offset: const Offset(2, 2), // Shadow position
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              imagePath,
              cacheWidth: 36,
              cacheHeight: 36,
            ),
            horizontalSpacing(20),
            Text(
              text,
              style: textStyle ?? AppTextStyles.font22WhiteSemiBold,
            ),
          ],
        ),
      ),
    );
  }
}
