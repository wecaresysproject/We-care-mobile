import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/features/contact_support/presentation/views/contact_support_modal.dart';
import 'package:we_care/features/online_doctor/presentation/views/widgets/online_doctor_features_strip.dart';
import 'package:we_care/features/online_doctor/presentation/views/widgets/online_doctor_header.dart';
import 'package:we_care/features/online_doctor/presentation/views/widgets/online_doctor_hero_banner.dart';
import 'package:we_care/features/online_doctor/presentation/views/widgets/online_doctor_promo_banner.dart';
import 'package:we_care/features/online_doctor/presentation/views/widgets/online_doctor_services_row.dart';

class OnlineDoctorView extends StatelessWidget {
  const OnlineDoctorView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 24.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              OnlineDoctorHeader(
                onChatTap: () => ContactSupportModal.show(context),
              ),
              verticalSpacing(20),
              const OnlineDoctorHeroBanner(),
              verticalSpacing(12),
              const OnlineDoctorServicesRow(),
              verticalSpacing(12),
              const OnlineDoctorFeaturesStrip(),
              verticalSpacing(12),
              const OnlineDoctorPromoBanner(),
            ],
          ),
        ),
      ),
    );
  }
}
