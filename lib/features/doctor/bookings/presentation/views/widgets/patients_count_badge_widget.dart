import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/generated/l10n.dart';

class PatientsCountBadgeWidget extends StatelessWidget {
  const PatientsCountBadgeWidget({
    super.key,
    required this.count,
    required this.backgroundColor,
    required this.textColor,
  });

  final int count;
  final Color backgroundColor;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.person, size: 16.r, color: textColor),
          SizedBox(width: 4.w),
          Text(
            S.of(context).patientsCountLabel(count),
            style: AppTextStyles.font12Weight600.copyWith(color: textColor),
          ),
        ],
      ),
    );
  }
}
