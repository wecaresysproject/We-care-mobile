import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/allowed_care_access/data/models/care_access_request_details_response.dart';

class ReviewRequestProfileHeader extends StatelessWidget {
  final RequesterDetailsModel requesterDetails;

  const ReviewRequestProfileHeader({
    super.key,
    required this.requesterDetails,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Avatar
        Container(
          width: 80.w,
          height: 80.w,
          decoration: BoxDecoration(
            color: AppColorsManager.mainDarkBlue,
            borderRadius: BorderRadius.circular(20.r),
          ),
          alignment: Alignment.center,
          child: Text(
            requesterDetails.fullName.isNotEmpty
                ? requesterDetails.fullName[0].toUpperCase()
                : '؟',
            style: AppTextStyles.font22MainBlueWeight700.copyWith(
              color: Colors.white,
              fontSize: 40.sp,
            ),
          ),
        ),
        SizedBox(height: 16.h),
        // User Name
        Text(
          requesterDetails.fullName,
          style: AppTextStyles.font22MainBlueWeight700.copyWith(
            color: AppColorsManager.mainDarkBlue,
            fontSize: 20.sp,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 4.h),
        // Phone Number
        Text(
          requesterDetails.phoneNumber,
          style: AppTextStyles.font14blackWeight400.copyWith(
            color: Colors.grey.shade500,
            fontSize: 14.sp,
          ),
          textDirection: TextDirection.ltr,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
