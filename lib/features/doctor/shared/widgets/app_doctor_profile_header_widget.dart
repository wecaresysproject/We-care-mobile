import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';

/// Back button + doctor avatar/name/specialty header, shared across screens
/// that need the "sub-page" header (back arrow on the leading edge, doctor
/// summary on the trailing edge). Tapping the back arrow pops the current
/// route.
class AppDoctorProfileHeaderWidget extends StatelessWidget {
  const AppDoctorProfileHeaderWidget({
    super.key,
    required this.doctorName,
    required this.specialty,
    required this.doctorPhotoUrl,
    this.isOnline = false,
  });

  final String doctorName;
  final String specialty;
  final String doctorPhotoUrl;
  final bool isOnline;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44.h,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16.r),
                    child: SizedBox(
                      width: 56.w,
                      height: 44.h,
                      child: Image.asset(doctorPhotoUrl, fit: BoxFit.cover),
                    ),
                  ),
                  // if (isOnline)
                  //   Positioned(
                  //     right: 2,
                  //     bottom: 2,
                  //     child: Container(
                  //       width: 10.w,
                  //       height: 10.w,
                  //       decoration: BoxDecoration(
                  //         shape: BoxShape.circle,
                  //         color: AppColorsManager.doneColor,
                  //         border: Border.all(
                  //           color: AppColorsManager.scaffoldBackGroundColor,
                  //           width: 1.5,
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                ],
              ),
              SizedBox(width: 8.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(doctorName, style: AppTextStyles.font14blackWeight600),
                  SizedBox(height: 4.h),
                  Text(specialty, style: AppTextStyles.font12blackWeight400),
                ],
              ),
            ],
          ),
          Material(
            color: AppColorsManager.scaffoldBackGroundColor,
            shape: const CircleBorder(),
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: () => Navigator.of(context).pop(),
              child: Padding(
                padding: EdgeInsets.all(10.w),
                child: Icon(
                  Icons.arrow_forward,
                  color: AppColorsManager.mainDarkBlue,
                  size: 22.r,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
