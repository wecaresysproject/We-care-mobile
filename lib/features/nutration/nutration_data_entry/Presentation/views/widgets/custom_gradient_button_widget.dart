import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';

class GradientButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final VoidCallback onPressed;

  const GradientButton({
    super.key,
    required this.text,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
      ).copyWith(
        backgroundColor: WidgetStateProperty.all(Colors.transparent),
      ),
      child: Ink(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Color(0xFFDFB18E),
              Color(0xFFF96C00),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          height: 38.h, // from Figma
          constraints: const BoxConstraints(minWidth: 186),
          alignment: Alignment.center,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: Colors.white, size: 20),
              const SizedBox(width: 8),
              Text(
                text,
                style: AppTextStyles.font14whiteWeight600,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
