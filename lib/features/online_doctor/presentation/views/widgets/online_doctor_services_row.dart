import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/core/routing/routes.dart';
import 'package:we_care/features/online_doctor/presentation/views/widgets/online_doctor_service_card.dart';

class OnlineDoctorServicesRow extends StatelessWidget {
  const OnlineDoctorServicesRow({super.key});

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: OnlineDoctorServiceCard(
              title: "البحث عن طبيب",
              description: "ابحث عن طبيب حسب التخصص، الاسم أو المكان",
              icon: _ServiceIcon(icon: Icons.person_search_rounded),
              onTap: () async {
                await context.pushNamed(Routes.doctorSearchView);
              },
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: OnlineDoctorServiceCard(
              title: "حجوزاتي",
              description: "عرض مواعيدك القادمة والسابقة وإدارتها",
              icon: _ServiceIcon(icon: Icons.calendar_month_rounded),
              onTap: () async {
                await context.pushNamed(Routes.myBookingsView);
              },
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: OnlineDoctorServiceCard(
              title: "الكشف",
              description: "ابدأ كشف مباشر مع الطبيب في الوقت المحدد",
              icon: _ServiceIcon(icon: Icons.video_camera_front_rounded),
              onTap: () async {
                await context.pushNamed(Routes.medicalExaminationView);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ServiceIcon extends StatelessWidget {
  const _ServiceIcon({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Icon(
      icon,
      size: 30.sp,
      color: AppColorsManager.mainDarkBlue,
    );
  }
}
