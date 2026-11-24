import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/doctor/bookings/data/models/appointment_type.dart';
import 'package:we_care/features/doctor/bookings/presentation/views/widgets/booking_info_banner_widget.dart';
import 'package:we_care/features/doctor/bookings/presentation/views/widgets/bookings_section_card_widget.dart';
import 'package:we_care/features/doctor/bookings/presentation/views/widgets/bookings_section_header_widget.dart';
import 'package:we_care/features/doctor/bookings/presentation/views/widgets/bookings_subpage_scaffold.dart';
import 'package:we_care/features/doctor/bookings/presentation/views/widgets/today_appointment_row_widget.dart';
import 'package:we_care/generated/l10n.dart';

/// Today's appointments of a single [type], opened from the home's
/// "حجوزات اليوم" counters: "الكشوفات" (examinations, from "الحجوزات") and
/// "المتابعات" (free follow-up consultations, from "المتابعات").
class DoctorTodayAppointmentsView extends StatelessWidget {
  const DoctorTodayAppointmentsView({
    super.key,
    required this.title,
    required this.type,
  });

  const DoctorTodayAppointmentsView.examinations({super.key})
      : title = 'الكشوفات',
        type = AppointmentType.examination;

  const DoctorTodayAppointmentsView.followUps({super.key})
      : title = 'المتابعات',
        type = AppointmentType.consultation;

  final String title;
  final AppointmentType type;

  @override
  Widget build(BuildContext context) {
    return BookingsSubpageScaffold(
      title: title,
      sectionBuilder: (context, bookings, now, _) {
        final appointments = bookings.todayAppointments
            .where((appointment) => appointment.type == type)
            .toList();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BookingsSectionHeaderWidget(
              title: S.of(context).todayAppointmentsTitle,
              titleIcon: Icons.event_available,
              patientsCount: appointments.length,
              countBackgroundColor: AppColorsManager.todayCountBadgeBackground,
              countTextColor: AppColorsManager.todayCountBadgeText,
            ),
            SizedBox(height: 12.h),
            BookingsSectionCardWidget(
              rows: [
                for (final appointment in appointments)
                  TodayAppointmentRowWidget(appointment: appointment, now: now),
              ],
              banner: BookingInfoBannerWidget(
                text: S.of(context).todayInfoBannerText,
                backgroundColor: AppColorsManager.todayInfoBannerBackground,
              ),
            ),
          ],
        );
      },
    );
  }
}
