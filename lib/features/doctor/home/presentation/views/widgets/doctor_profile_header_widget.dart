import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/doctor/home/presentation/views/widgets/doctor_menu_button_widget.dart';

class DoctorProfileHeaderWidget extends StatelessWidget {
  const DoctorProfileHeaderWidget({
    super.key,
    required this.doctorName,
    required this.specialty,
    required this.doctorPhotoUrl,
    required this.clinicLogoUrl,
  });

  final String doctorName;
  final String specialty;
  final String doctorPhotoUrl;
  final String clinicLogoUrl;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44.h,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 72.w,
            height: 44.h,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              border: Border.all(
                  color: AppColorsManager.placeHolderColor, width: 0.5),
              borderRadius: BorderRadius.circular(10.r),
            ),
            // Figma fills this box edge-to-edge with the logo scaled up
            // (cover), not fitted-with-padding — matches BoxFit.cover here.
            child: Image.asset(clinicLogoUrl, fit: BoxFit.cover),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(doctorName, style: AppTextStyles.font12blackWeight500),
                  SizedBox(height: 6.h),
                  Text(specialty, style: AppTextStyles.font12blackWeight500),
                ],
              ),
              SizedBox(width: 5.w),
              ClipRRect(
                borderRadius: BorderRadius.circular(16.r),
                child: SizedBox(
                  width: 56.w,
                  height: 44.h,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.asset(doctorPhotoUrl, fit: BoxFit.cover),
                      Container(color: AppColorsManager.doctorPhotoOverlay),
                    ],
                  ),
                ),
              ),
              const DoctorMenuButtonWidget(),
            ],
          ),
        ],
      ),
    );
  }
}
