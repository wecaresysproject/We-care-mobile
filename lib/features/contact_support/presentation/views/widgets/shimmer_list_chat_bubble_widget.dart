import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/theming/color_manager.dart';

class ShimmerChatBubbleWidget extends StatelessWidget {
  const ShimmerChatBubbleWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
      itemCount: 10,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final isMe = index % 2 == 0;
        return Align(
          alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            margin: EdgeInsets.only(bottom: 16.h),
            width: (index % 3 == 0 ? 220.w : 160.w),
            height: 50.h,
            decoration: BoxDecoration(
              color: isMe
                  ? AppColorsManager.mainDarkBlue.withAlpha(50)
                  : Colors.grey.withAlpha(50),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16.r),
                topRight: Radius.circular(16.r),
                bottomLeft: Radius.circular(isMe ? 16.r : 4.r),
                bottomRight: Radius.circular(isMe ? 4.r : 16.r),
              ),
            ),
          ),
        );
      },
    );
  }
}
