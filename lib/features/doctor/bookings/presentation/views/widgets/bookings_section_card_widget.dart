import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/theming/color_manager.dart';

class BookingsSectionCardWidget extends StatelessWidget {
  const BookingsSectionCardWidget({
    super.key,
    required this.rows,
    required this.banner,
  });

  final List<Widget> rows;
  final Widget banner;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppColorsManager.scaffoldBackGroundColor,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            offset: const Offset(0, 2),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var i = 0; i < rows.length; i++) ...[
            if (i != 0) ...[
              SizedBox(height: 10.h),
              Divider(height: 1, color: AppColorsManager.shimmerBase),
              SizedBox(height: 10.h),
            ],
            rows[i],
          ],
          SizedBox(height: 12.h),
          banner,
        ],
      ),
    );
  }
}
