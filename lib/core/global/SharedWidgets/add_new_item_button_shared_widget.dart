import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddNewItemButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const AddNewItemButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45.h,
      padding: const EdgeInsets.symmetric(
        vertical: 4,
        horizontal: 16,
      ), // Padding from Figma
      decoration: BoxDecoration(
        color: const Color(0xFF014C8A), // Main color from Figma
        borderRadius: BorderRadius.circular(12), // Radius from Figma
      ),
      child: TextButton.icon(
        onPressed: onPressed,
        icon: const Icon(Icons.add, color: Colors.white, size: 20), // "+" Icon
        label: Text(
          text,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.sp,
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
