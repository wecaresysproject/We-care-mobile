import 'package:cached_network_image/cached_network_image.dart';
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
          clipBehavior: Clip.hardEdge,
          child: (requesterDetails.personalPhotoUrl != null &&
                  requesterDetails.personalPhotoUrl!.trim().isNotEmpty &&
                  requesterDetails.personalPhotoUrl!.trim().startsWith('http'))
              ? CachedNetworkImage(
                  imageUrl: requesterDetails.personalPhotoUrl!.trim(),
                  width: 80.w,
                  height: 80.w,
                  fit: BoxFit.cover,
                  placeholder: (context, url) =>
                      const CircularProgressIndicator(color: Colors.white),
                  errorWidget: (context, url, error) => _buildInitials(),
                )
              : _buildInitials(),
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

  Widget _buildInitials() {
    return Center(
      child: Text(
        requesterDetails.fullName.isNotEmpty
            ? requesterDetails.fullName[0].toUpperCase()
            : '؟',
        style: AppTextStyles.font22MainBlueWeight700.copyWith(
          color: Colors.white,
          fontSize: 40.sp,
        ),
      ),
    );
  }
}
