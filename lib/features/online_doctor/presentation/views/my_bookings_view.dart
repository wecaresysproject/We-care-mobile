import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/custom_app_back_arrow.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/routing/routes.dart';
import 'package:we_care/features/online_doctor/presentation/views/widgets/local_timezone_note.dart';
import 'package:we_care/features/online_doctor/presentation/views/widgets/my_bookings_header_buttons.dart';
import 'package:we_care/features/online_doctor/presentation/views/widgets/online_doctor_theme.dart';
import 'package:we_care/features/online_doctor/presentation/views/widgets/upcoming_bookings_list.dart';

/// شاشة "حجوزاتى" — كروت المواعيد القادمة المشتركة (`UpcomingBookingsList`)،
/// وزرار "السجل السابق" بيفتح شاشة السجل المستقلة.
class MyBookingsView extends StatelessWidget {
  const MyBookingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 0),
              child: const _MyBookingsAppBar(),
            ),
            verticalSpacing(14),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: MyBookingsHeaderButtons(
                onHistoryPressed: () async {
                  await context.pushNamed(Routes.bookingsHistoryView);
                },
              ),
            ),
            verticalSpacing(12),
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

/// سهم رجوع، "حجوزاتى" فى المنتصف، وأيقونة تقويم فى النهاية.
class _MyBookingsAppBar extends StatelessWidget {
  const _MyBookingsAppBar();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const CustomBackArrow(),
        Expanded(
          child: Text(
            "حجوزاتي",
            textAlign: TextAlign.center,
            style: AppTextStyles.font20blackWeight600.copyWith(
              fontSize: 19.sp,
              color: Colors.black,
            ),
          ),
        ),
        // أيقونة التقويم زى التصميم — شكلية لحد ما فلترة المواعيد بالتاريخ تتحدد.
        Container(
          width: 40.w,
          height: 40.h,
          padding: EdgeInsets.all(9.r),
          decoration: BoxDecoration(
            color: OnlineDoctorTheme.iconTint,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Image.asset(
            "assets/images/calender_icon.png",
            fit: BoxFit.contain,
          ),
        ),
      ],
    );
  }
}
