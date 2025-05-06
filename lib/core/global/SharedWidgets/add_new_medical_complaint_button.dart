import 'package:flutter/material.dart';
import 'package:we_care/core/global/theming/color_manager.dart';

class AddNewMedicalComplaintButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const AddNewMedicalComplaintButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          vertical: 4, horizontal: 16), // Padding from Figma
      decoration: BoxDecoration(
        color: AppColorsManager.mainDarkBlue, // Main color from Figma
        borderRadius: BorderRadius.circular(12), // Radius from Figma
      ),
      child: TextButton.icon(
        onPressed: onPressed,
        icon: const Icon(Icons.add, color: Colors.white, size: 20), // "+" Icon
        label: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          textDirection: TextDirection.rtl, // Arabic text support
        ),
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero, // Ensures proper spacing inside Container
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
      ),
    );
  }
}
