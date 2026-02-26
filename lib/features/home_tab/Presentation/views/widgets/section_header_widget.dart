import 'package:flutter/material.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';

class SectionHeaderWidget extends StatelessWidget {
  final String title;
  const SectionHeaderWidget({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Text(
        title,
        style: AppTextStyles.font12blackWeight400.copyWith(
          decoration: TextDecoration.underline,
          decorationThickness: 2,
        ),
      ),
    );
  }
}
