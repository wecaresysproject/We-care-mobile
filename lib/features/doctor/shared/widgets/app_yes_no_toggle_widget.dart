import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/generated/l10n.dart';

/// A two-segment "Yes/No" pill toggle. [value] is `true` for yes, `false`
/// for no; [onChanged] fires with the newly selected value.
class AppYesNoToggleWidget extends StatelessWidget {
  const AppYesNoToggleWidget({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppColorsManager.textfieldInsideColor.withAlpha(100),
        borderRadius: BorderRadius.circular(30.r),
        border: Border.all(
          color: AppColorsManager.placeHolderColor.withAlpha(60),
          width: 1.3,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _ToggleSegment(
            label: S.of(context).no,
            isSelected: !value,
            onTap: () => onChanged(false),
          ),
          _ToggleSegment(
            label: S.of(context).yes,
            isSelected: value,
            onTap: () => onChanged(true),
          ),
        ],
      ),
    );
  }
}

class _ToggleSegment extends StatelessWidget {
  const _ToggleSegment({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(26.r),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
          decoration: BoxDecoration(
            color:
                isSelected ? AppColorsManager.mainDarkBlue : Colors.transparent,
            borderRadius: BorderRadius.circular(26.r),
          ),
          child: Text(
            label,
            style: AppTextStyles.font14blackWeight600.copyWith(
              color:
                  isSelected ? Colors.white : AppColorsManager.placeHolderColor,
            ),
          ),
        ),
      ),
    );
  }
}
