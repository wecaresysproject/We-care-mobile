import 'package:flutter/material.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';

class AppCustomButton extends StatelessWidget {
  const AppCustomButton({
    super.key,
    required this.title,
    this.onPressed,
    this.isEnabled = false,
  });
  final String title;
  final void Function()? onPressed;
  final bool isEnabled;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor:
            isEnabled ? AppColorsManager.mainDarkBlue : Colors.grey,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        minimumSize: const Size(double.infinity, 50),
      ),
      child: Text(
        title,
        style: AppTextStyles.font22MainBlueRegular.copyWith(
          color: Colors.white,
        ),
      ),
    );
  }
}
