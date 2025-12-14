import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';

class NotificationItem extends StatelessWidget {
  final String title;
  final String body;
  final String time;
  final bool isRead;

  const NotificationItem({
    super.key,
    required this.title,
    required this.body,
    required this.time,
    this.isRead = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: isRead ? Colors.white : AppColorsManager.babyBlueColor.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: AppColorsManager.placeHolderColor.withOpacity(0.1),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: AppColorsManager.mainDarkBlue.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.notifications_outlined,
              color: AppColorsManager.mainDarkBlue,
              size: 24.sp,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: AppTextStyles.font14BlueWeight700.copyWith(
                          color: AppColorsManager.textColor,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      time,
                      style: AppTextStyles.font12blackWeight400.copyWith(
                        color: AppColorsManager.placeHolderColor,
                        fontSize: 10.sp,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4.h),
                Text(
                  body,
                  style: AppTextStyles.font12blackWeight400.copyWith(
                    color: AppColorsManager.textColor.withOpacity(0.8),
                    height: 1.4,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
