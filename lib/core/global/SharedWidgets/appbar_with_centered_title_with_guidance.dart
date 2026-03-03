import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/custom_app_back_arrow.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';

class CustomAppBarWithCenteredTitleWithGuidance extends StatelessWidget
    implements PreferredSizeWidget {
  const CustomAppBarWithCenteredTitleWithGuidance({
    super.key,
    required this.title,
    this.onbackArrowPress,
    this.trailingActions, // 👈 الجديد
  });

  final String title;
  final void Function()? onbackArrowPress;

  /// 👇 NEW
  final List<Widget>? trailingActions;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CustomBackArrow(
          onTap: onbackArrowPress,
        ),
        horizontalSpacing(8),
        Expanded(
            child: Text(
          title,
          textAlign: TextAlign.center,
          style: AppTextStyles.font20blackWeight600.copyWith(
            fontSize: 19.sp,
            color: Colors.black,
            fontFamily: "Cairo",
          ),
        )),

        /// Trailing Icons عامة
        if (trailingActions != null) ...trailingActions!,
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(40);
}
