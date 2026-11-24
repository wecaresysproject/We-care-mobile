import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/doctor/bookings/logic/cubit/bookings_cubit.dart';
import 'package:we_care/features/doctor/bookings/presentation/views/widgets/booking_info_banner_widget.dart';
import 'package:we_care/features/doctor/bookings/presentation/views/widgets/bookings_section_card_widget.dart';
import 'package:we_care/features/doctor/bookings/presentation/views/widgets/bookings_section_header_widget.dart';
import 'package:we_care/features/doctor/bookings/presentation/views/widgets/bookings_subpage_scaffold.dart';
import 'package:we_care/features/doctor/bookings/presentation/views/widgets/waiting_patient_row_widget.dart';
import 'package:we_care/generated/l10n.dart';

/// "قائمة الانتظار" screen, opened from the home's "الانتظار" counter: only
/// the waiting patients, with accept / reject on each row.
class DoctorWaitingListView extends StatelessWidget {
  const DoctorWaitingListView({super.key});

  @override
  Widget build(BuildContext context) {
    return BookingsSubpageScaffold(
      title: S.of(context).waitingListTitle,
      sectionBuilder: (context, bookings, now, processingBookingId) {
        final isProcessing = processingBookingId.isNotEmpty;
        final cubit = context.read<BookingsCubit>();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                    isProcessing: patient.id == processingBookingId,
                    onAccept: isProcessing
                        ? null
                        : () => cubit.acceptWaitingPatient(patient),
                    onReject: isProcessing
                        ? null
                        : () => cubit.rejectWaitingPatient(patient),
                  ),
              ],
              banner: BookingInfoBannerWidget(
                text: S.of(context).waitingInfoBannerText,
                backgroundColor: AppColorsManager.waitingInfoBannerBackground,
              ),
            ),
          ],
        );
      },
    );
  }
}
