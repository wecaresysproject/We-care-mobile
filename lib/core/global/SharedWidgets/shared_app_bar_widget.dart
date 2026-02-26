import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/custom_app_back_arrow.dart';
import 'package:we_care/core/global/theming/color_manager.dart';

class SharedAppBar extends StatelessWidget {
  final bool isItemSelectionMode;
  final VoidCallback? onShare;
  final VoidCallback? onDelete;

  /// أيقونات إضافية في آخر الـ Row (زي play / book)
  final List<Widget>? trailingActions;

  const SharedAppBar({
    super.key,
    this.isItemSelectionMode = false,
    this.onShare,
    this.onDelete,
    this.trailingActions,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 16.h, bottom: 12.h),
      child: Row(
        children: [
          const CustomBackArrow(),

          /// يخلي المساحة فاضية لحد الآخر
          const Spacer(),

          /// Selection Mode Icons
          if (isItemSelectionMode) ...[
            CircleIconButton(
              icon: Icons.share,
              color: AppColorsManager.mainDarkBlue,
              onTap: onShare,
            ),
            horizontalSpacing(10),
            CircleIconButton(
              icon: Icons.delete,
              color: AppColorsManager.warningColor,
              onTap: onDelete,
            ),
            horizontalSpacing(10),
          ],

          /// Trailing Icons عامة
          if (trailingActions != null) ...trailingActions!,
        ],
      ),
    );
  }
}

class CircleIconButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;
  final double? size;

  const CircleIconButton({
    super.key,
    required this.icon,
    required this.color,
    this.onTap,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    final double dimension = size ?? 37.w;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: dimension,
        height: dimension,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.4),
              blurRadius: 12,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Icon(
          icon,
          color: Colors.white,
          size: 22.sp,
        ),
      ),
    );
  }
}
