import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/doctor/bookings/data/models/bookings_model.dart';
import 'package:we_care/features/doctor/bookings/logic/cubit/bookings_cubit.dart';
import 'package:we_care/features/doctor/bookings/presentation/views/widgets/booking_info_banner_widget.dart';
import 'package:we_care/features/doctor/bookings/presentation/views/widgets/bookings_header_widget.dart';
import 'package:we_care/features/doctor/bookings/presentation/views/widgets/bookings_section_card_widget.dart';
import 'package:we_care/features/doctor/bookings/presentation/views/widgets/bookings_section_header_widget.dart';
import 'package:we_care/features/doctor/bookings/presentation/views/widgets/today_appointment_row_widget.dart';
import 'package:we_care/features/doctor/bookings/presentation/views/widgets/waiting_patient_row_widget.dart';
import 'package:we_care/generated/l10n.dart';

class BookingsContentWidget extends StatelessWidget {
  const BookingsContentWidget({super.key, required this.bookings});

  final BookingsModel bookings;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BookingsHeaderWidget(
            doctorName: bookings.doctorName,
            specialty: bookings.specialty,
            doctorPhotoUrl: bookings.doctorPhotoUrl,
          ),
          SizedBox(height: 20.h),
          BookingsSectionHeaderWidget(
            title: S.of(context).todayAppointmentsTitle,
            titleIcon: Icons.event_available,
            patientsCount: bookings.todayAppointments.length,
            countBackgroundColor: AppColorsManager.todayCountBadgeBackground,
            countTextColor: AppColorsManager.todayCountBadgeText,
          ),
          SizedBox(height: 12.h),
          BookingsSectionCardWidget(
            rows: [
              for (final appointment in bookings.todayAppointments)
                TodayAppointmentRowWidget(appointment: appointment),
            ],
            banner: BookingInfoBannerWidget(
              text: S.of(context).todayInfoBannerText,
              backgroundColor: AppColorsManager.todayInfoBannerBackground,
            ),
          ),
          SizedBox(height: 20.h),
          BookingsSectionHeaderWidget(
            title: S.of(context).waitingListTitle,
            titleIcon: Icons.hourglass_top,
            patientsCount: bookings.waitingPatients.length,
            countBackgroundColor: AppColorsManager.waitingCountBadgeBackground,
            countTextColor: AppColorsManager.waitingCountBadgeText,
          ),
          SizedBox(height: 12.h),
          BookingsSectionCardWidget(
            rows: [
              for (final patient in bookings.waitingPatients)
                WaitingPatientRowWidget(
                  patient: patient,
                  onAccept: () => context
                      .read<BookingsCubit>()
                      .acceptWaitingPatient(patient.id),
                  onReject: () => context
                      .read<BookingsCubit>()
                      .rejectWaitingPatient(patient.id),
                ),
            ],
            banner: BookingInfoBannerWidget(
              text: S.of(context).waitingInfoBannerText,
              backgroundColor: AppColorsManager.waitingInfoBannerBackground,
            ),
          ),
        ],
      ),
    );
  }
}
