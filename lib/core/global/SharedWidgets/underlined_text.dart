import 'package:flutter/material.dart';

class UnderlinedText extends StatelessWidget {
  final String text;
  final TextStyle textStyle;
  final Color underlineColor;
  final double underlineThickness;

  const UnderlinedText({
    super.key,
    required this.text,
    required this.textStyle,
    this.underlineColor = Colors.blue,
    this.underlineThickness = 2.0,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: textStyle.copyWith(
        decoration: TextDecoration.underline,
        height: 2,
        decorationColor: underlineColor,
        decorationThickness: underlineThickness,
      ),
    );
  }
}
