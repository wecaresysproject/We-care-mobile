import 'package:flutter/material.dart';
import 'package:we_care/core/global/theming/color_manager.dart';

class ShadowText extends StatelessWidget {
  final String text;

  const ShadowText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 32, // Adjust size as needed
        fontWeight: FontWeight.bold,
        color: AppColorsManager.mainDarkBlue, // Blue text color
        shadows: [
          Shadow(
            blurRadius: 5.0, // Softness of the shadow
            color: Colors.black26, // Shadow color (grayish)
            offset: Offset(6, 5), // Position of shadow (X, Y)
          ),
        ],
      ),
    );
  }
}
