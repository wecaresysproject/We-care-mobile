import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/doctor/bookings/presentation/views/widgets/patient_avatar_widget.dart';
import 'package:we_care/generated/l10n.dart';

class BookingsHeaderWidget extends StatelessWidget {
  const BookingsHeaderWidget({
    super.key,
    required this.doctorName,
    required this.specialty,
    required this.doctorPhotoUrl,
  });

  final String doctorName;
  final String specialty;
  final String? doctorPhotoUrl;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Material(
              color: AppColorsManager.scaffoldBackGroundColor,
              shape: const CircleBorder(),
              elevation: 2,
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: () => Navigator.of(context).pop(),
                child: Padding(
                  padding: EdgeInsets.all(10.w),
                  child: Icon(
                    Icons.arrow_back,
                    color: AppColorsManager.mainDarkBlue,
                    size: 22.r,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    S.of(context).bookingsTitle,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.font20blackWeight700,
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    S.of(context).bookingsSubtitle,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.font13GreyWeight400,
                  ),
                ],
              ),
            ),
            // Balances the back button's width so the title truly centers.
            SizedBox(width: 44.w),
          ],
        ),
        SizedBox(height: 16.h),
        Align(
          alignment: Alignment.centerRight,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: AppColorsManager.scaffoldBackGroundColor,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: AppColorsManager.shimmerBase),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(doctorName, style: AppTextStyles.font12blackWeight500),
                    SizedBox(height: 2.h),
                    Text(specialty, style: AppTextStyles.font13GreyWeight400),
                  ],
                ),
                SizedBox(width: 8.w),
                PatientAvatarWidget(photoUrl: doctorPhotoUrl, size: 40),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
