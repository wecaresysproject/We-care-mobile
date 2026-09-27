import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/features/doctor/basic_data/data/basic_data_menu_items.dart';
import 'package:we_care/features/doctor/basic_data/presentation/views/widgets/basic_data_menu_grid_widget.dart';
import 'package:we_care/features/doctor/basic_data/presentation/views/widgets/basic_data_promo_banner_widget.dart';
import 'package:we_care/features/doctor/shared/widgets/app_doctor_profile_header_widget.dart';

/// Fully static screen — content mirrors the Figma design directly, no
/// backend call involved.
class BasicDataContentWidget extends StatelessWidget {
  const BasicDataContentWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppDoctorProfileHeaderWidget(
            doctorName: 'د/ أحمد محمود',
            specialty: 'استشاري جهاز مناعي',
            doctorPhotoUrl: 'assets/images/doctor_photo.png',
            isOnline: true,
          ),
          SizedBox(height: 24.h),
          const BasicDataMenuGridWidget(menuItems: basicDataMenuItems),
          SizedBox(height: 20.h),
          const BasicDataPromoBannerWidget(),
        ],
      ),
    );
  }
}
