import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/user_selection_container_shared_widget.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';

/// The "صلاحية استشارة المتابعة" row from the consultation-section mock: a
/// calendar badge + title/hint on the trailing side, a compact
/// dropdown-style value selector on the leading side.
class FollowUpValiditySelectorWidget extends StatelessWidget {
  const FollowUpValiditySelectorWidget({
    super.key,
    required this.title,
    required this.hint,
    required this.valueLabel,
    required this.options,
    required this.onOptionSelected,
    required this.bottomSheetTitle,
  });

  final String title;
  final String hint;
  final String valueLabel;
  final List<String> options;
  final ValueChanged<String> onOptionSelected;
  final String bottomSheetTitle;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 110.w,
          child: UserSelectionContainer(
            containerHintText: valueLabel,
            initialValue: valueLabel,
            options: options,
            onOptionSelected: onOptionSelected,
            bottomSheetTitle: bottomSheetTitle,
            searchHintText: bottomSheetTitle,
          ),
        ),
        horizontalSpacing(12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTextStyles.font14blackWeight600),
              verticalSpacing(4),
              Text(hint, style: AppTextStyles.font13GreyWeight400),
            ],
          ),
        ),
        horizontalSpacing(8),
        Container(
          width: 32.w,
          height: 32.w,
          decoration: const BoxDecoration(
            color: AppColorsManager.basicDataPurpleBadgeBackground,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.calendar_today_outlined,
            size: 16.r,
            color: AppColorsManager.basicDataPurpleBadgeIcon,
          ),
        ),
      ],
    );
  }
}
