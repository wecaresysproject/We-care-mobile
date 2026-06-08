import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';

class CareInfoBanner extends StatelessWidget {
  const CareInfoBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF9C4).withOpacity(0.5), // Light yellow
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFFFFCC80)), // Soft orange
      ),
      child: Row(
        children: [
          Icon(
            Icons.lightbulb_outline,
            color: const Color(0xFFFF9800),
            size: 24.sp,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              'سيصله إشعار. لن يُضاف إلا بعد موافقته.',
              style: AppTextStyles.font14blackWeight400.copyWith(
                color:
                    const Color(0xFFE65100), // Darker orange for readable text
                fontSize: 13.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
