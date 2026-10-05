import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/app_toasts.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/SharedWidgets/app_custom_button.dart';
import 'package:we_care/features/doctor/booking_settings/logic/cubit/booking_settings_cubit.dart';
import 'package:we_care/features/doctor/booking_settings/presentation/views/widgets/booking_interval_section_widget.dart';
import 'package:we_care/features/doctor/booking_settings/presentation/views/widgets/booking_settings_notes_widget.dart';
import 'package:we_care/features/doctor/booking_settings/presentation/views/widgets/daily_bookings_limit_section_widget.dart';
import 'package:we_care/features/doctor/booking_settings/presentation/views/widgets/weekly_booking_days_section_widget.dart';
import 'package:we_care/features/doctor/booking_settings/presentation/views/widgets/weekly_booking_times_section_widget.dart';
import 'package:we_care/generated/l10n.dart';

/// Composes the five numbered Booking Settings sections and the save
/// action into one scrollable column.
class BookingSettingsFormFields extends StatelessWidget {
  const BookingSettingsFormFields({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DailyBookingsLimitSectionWidget(),
        SizedBox(height: 18),
        BookingIntervalSectionWidget(),
        SizedBox(height: 18),
        WeeklyBookingDaysSectionWidget(),
        SizedBox(height: 18),
        WeeklyBookingTimesSectionWidget(),
        SizedBox(height: 18),
        BookingSettingsNotesWidget(),
        SizedBox(height: 28),
        _SubmitButton(),
        SizedBox(height: 20),
      ],
    );
  }
}

class _SubmitButton extends StatelessWidget {
  const _SubmitButton();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BookingSettingsCubit, BookingSettingsState>(
      listenWhen: (prev, curr) =>
          curr.submissionStatus == RequestStatus.success ||
          curr.submissionStatus == RequestStatus.failure,
      buildWhen: (prev, curr) =>
          prev.submissionStatus != curr.submissionStatus ||
          prev.canSubmit != curr.canSubmit,
      listener: (context, state) async {
        if (state.submissionStatus == RequestStatus.success) {
          await showSuccess(state.message!);
          if (!context.mounted) return;
          context.pop(result: true);
        } else if (state.submissionStatus == RequestStatus.failure) {
          await showError(state.message!);
        }
      },
      builder: (context, state) {
        final cubit = context.read<BookingSettingsCubit>();
        return AppCustomButton(
          title: S.of(context).bookingSettingsFormSaveSettings,
          icon: Icons.save_outlined,
          isEnabled: state.canSubmit &&
              state.submissionStatus != RequestStatus.loading,
          isLoading: state.submissionStatus == RequestStatus.loading,
          onPressed: cubit.submitBookingSettings,
        );
      },
    );
  }
}
