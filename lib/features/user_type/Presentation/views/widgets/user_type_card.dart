import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/theming/color_manager.dart';

/// Account type option on the user-type screen: arrow badge at the start,
/// title + description in the middle and an illustration bleeding into the
/// card's bottom edge at the end.
class UserTypeCard extends StatelessWidget {
  const UserTypeCard({
    super.key,
    required this.title,
    required this.description,
    required this.illustrationPath,
    required this.gradientColors,
    required this.borderColor,
    required this.arrowBackgroundColor,
    required this.onTap,
    this.titleColor = AppColorsManager.userTypeHeadingColor,
  });

  final String title;
  final String description;
  final String illustrationPath;
  final List<Color> gradientColors;
  final Color borderColor;
  final Color arrowBackgroundColor;
  final Color titleColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(20.r);

    return Container(
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        border: Border.all(color: borderColor),
        gradient: LinearGradient(
          begin: AlignmentDirectional.centerStart,
          end: AlignmentDirectional.centerEnd,
          colors: gradientColors,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xff1B4C8C).withValues(alpha: 0.06),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: borderRadius,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Stack(
            children: [
              //* Illustration fills the card's end side and bleeds into its
              //* bottom edge; the text column alone decides the card height.
              PositionedDirectional(
                top: 0,
                bottom: 0,
                end: 0,
                width: 118.w,
                child: SvgPicture.asset(
                  illustrationPath,
                  fit: BoxFit.cover,
                  alignment: Alignment.bottomCenter,
                ),
              ),
              ConstrainedBox(
                constraints: BoxConstraints(minHeight: 108.h),
                child: Row(
                  children: [
                    horizontalSpacing(14),
                    _ArrowBadge(
                      backgroundColor: arrowBackgroundColor,
                      color: titleColor,
                    ),
                    horizontalSpacing(12),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 14.h),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w800,
                                color: titleColor,
                                height: 1.3,
                              ),
                            ),
                            verticalSpacing(4),
                            Text(
                              description,
                              style: TextStyle(
                                fontSize: 11.5.sp,
                                fontWeight: FontWeight.w500,
                                color:
                                    AppColorsManager.userTypeDescriptionColor,
                                height: 1.55,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    horizontalSpacing(118),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ArrowBadge extends StatelessWidget {
  const _ArrowBadge({required this.backgroundColor, required this.color});

  final Color backgroundColor;
  final Color color;

  @override
  Widget build(BuildContext context) {
    //* The badge sits on the card's start edge, so the chevron points
    //* outward: ">" in RTL, "<" in LTR.
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    return Container(
      width: 32.r,
      height: 32.r,
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
      ),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Icon(
          isRtl ? Icons.chevron_right_rounded : Icons.chevron_left_rounded,
          color: color,
          size: 24.r,
        ),
      ),
    );
  }
}
