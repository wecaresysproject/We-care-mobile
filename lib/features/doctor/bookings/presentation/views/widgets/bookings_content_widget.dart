import 'dart:async';

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

class BookingsContentWidget extends StatefulWidget {
  const BookingsContentWidget({
    super.key,
    required this.bookings,
    required this.processingBookingId,
  });

  final BookingsModel bookings;

  /// Waiting patient whose accept / reject request is running — its row
  /// shows a loader, and the other rows' actions are disabled meanwhile.
  final String processingBookingId;

  @override
  State<BookingsContentWidget> createState() => _BookingsContentWidgetState();
}

class _BookingsContentWidgetState extends State<BookingsContentWidget> {
  /// Rebuilds the rows so the minute counters ("متبقي / متأخر / منذ N دقيقة")
  /// stay live.
  late final Timer _minuteTicker;

  @override
  void initState() {
    super.initState();
    _minuteTicker = Timer.periodic(
      const Duration(seconds: 30),
      (_) => setState(() {}),
    );
  }

  @override
  void dispose() {
    _minuteTicker.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bookings = widget.bookings;
    final now = DateTime.now();
    final isProcessing = widget.processingBookingId.isNotEmpty;

    return RefreshIndicator(
      color: AppColorsManager.mainDarkBlue,
      onRefresh: () => context.read<BookingsCubit>().getBookings(silent: true),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
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
                  TodayAppointmentRowWidget(appointment: appointment, now: now),
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
              countBackgroundColor:
                  AppColorsManager.waitingCountBadgeBackground,
              countTextColor: AppColorsManager.waitingCountBadgeText,
            ),
            SizedBox(height: 12.h),
            BookingsSectionCardWidget(
              rows: [
                for (final patient in bookings.waitingPatients)
                  WaitingPatientRowWidget(
                    patient: patient,
                    now: now,
                    isProcessing: patient.id == widget.processingBookingId,
                    onAccept: isProcessing
                        ? null
                        : () => context
                            .read<BookingsCubit>()
                            .acceptWaitingPatient(patient),
                    onReject: isProcessing
                        ? null
                        : () => context
                            .read<BookingsCubit>()
                            .rejectWaitingPatient(patient),
                  ),
              ],
              banner: BookingInfoBannerWidget(
                text: S.of(context).waitingInfoBannerText,
                backgroundColor: AppColorsManager.waitingInfoBannerBackground,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
