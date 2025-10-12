import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';

class CustomInfoSection extends StatelessWidget {
  final IconData headerIcon;
  final String headerTitle;
  final String content;

  const CustomInfoSection({
    super.key,
    required this.headerIcon,
    required this.headerTitle,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          icon: headerIcon,
          title: headerTitle,
        ),
        verticalSpacing(10),
        ContentSection(content: content),
      ],
    );
  }
}

class SectionHeader extends StatelessWidget {
  final IconData icon;
  final String title;

  const SectionHeader({
    super.key,
    required this.icon,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          end: Alignment.centerLeft,
          begin: Alignment.centerRight,
          colors: [
            Color(0xFFFBFDFF),
            Color(0xFFECF5FF),
          ],
        ),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: AppColorsManager.mainDarkBlue,
            size: 24,
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Stack(
              alignment: Alignment.bottomRight,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.only(bottom: 6), // space for underline
                  child: Text(
                    title,
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      height: 20 / 16,
                      letterSpacing: 0.16,
                      color: AppColorsManager.mainDarkBlue,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: _calculateTextWidth(title, context),
                    height: 1,
                    color: AppColorsManager.mainDarkBlue,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  double _calculateTextWidth(String text, BuildContext context) {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          fontFamily: 'Cairo',
          fontSize: 16,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.16,
        ),
      ),
      maxLines: 1,
      textDirection: TextDirection.rtl,
    )..layout(minWidth: 0, maxWidth: double.infinity);

    return textPainter.size.width;
  }
}

// Reusable content section component
class ContentSection extends StatelessWidget {
  final String content;
  final EdgeInsetsGeometry? padding;

  const ContentSection({
    super.key,
    required this.content,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      content,
      style: AppTextStyles.font14blackWeight400,
      textAlign: TextAlign.justify,
    );
  }
}
