import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/appbar_with_centered_title_with_guidance.dart';
import 'package:we_care/features/online_doctor/presentation/views/widgets/local_timezone_note.dart';
import 'package:we_care/features/online_doctor/presentation/views/widgets/upcoming_bookings_list.dart';

/// شاشة "الكشف" — نفس كروت المواعيد القادمة اللى فى "حجوزاتى"
/// (`UpcomingBookingsList`)، ومنها المستخدم بيفتح غرفة الكشف بتاعة كل حجز.
class MedicalExaminationView extends StatelessWidget {
  const MedicalExaminationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 0),
              child: const CustomAppBarWithCenteredTitleWithGuidance(
                title: "الكشف",
              ),
            ),
            verticalSpacing(14),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: const LocalTimezoneNote(),
            ),
            verticalSpacing(14),
            const Expanded(child: UpcomingBookingsList()),
          ],
        ),
      ),
    );
  }
}
