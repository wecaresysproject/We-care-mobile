import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/features/doctor/booking_settings/data/models/booking_settings_request_body_model.dart';
import 'package:we_care/features/doctor/booking_settings/data/models/booking_value_source.dart';
import 'package:we_care/features/doctor/booking_settings/data/models/time_range_model.dart';
import 'package:we_care/features/doctor/booking_settings/data/models/weekday.dart';
import 'package:we_care/features/doctor/booking_settings/data/models/weekday_schedule_model.dart';
import 'package:we_care/features/doctor/booking_settings/data/repos/booking_settings_repo.dart';

part 'booking_settings_state.dart';

class BookingSettingsCubit extends Cubit<BookingSettingsState>
    with SafeEmitMixin<BookingSettingsState> {
  BookingSettingsCubit(this._bookingSettingsRepo)
      : super(BookingSettingsState.initial());

  final BookingSettingsRepo _bookingSettingsRepo;

  static const maxDailyBookingsOptions = [5, 10, 15, 20, 25, 30, 40, 50];
  static const intervalMinutesOptions = [10, 15, 20, 30, 45, 60];

  void updateMaxDailyBookings(int value) =>
      safeEmit(state.copyWith(maxDailyBookings: value));

  void updateIntervalMinutes(int value) =>
      safeEmit(state.copyWith(intervalMinutes: value));

  /// Makes [source] the hand-picked value and locks the other one. The newly
  /// manual value starts from what was just calculated, so nothing jumps.
  void selectValueSource(BookingValueSource source) {
    if (source == state.valueSource) return;
    safeEmit(
      state.copyWith(
        valueSource: source,
        maxDailyBookings: source == BookingValueSource.dailyBookings
            ? state.calculatedMaxDailyBookings
            : null,
        intervalMinutes: source == BookingValueSource.interval
            ? state.calculatedIntervalMinutes
            : null,
      ),
    );
  }

  void toggleDayEnabled(Weekday day) {
    safeEmit(
      state.copyWith(
        weeklySchedule: [
          for (final schedule in state.weeklySchedule)
            if (schedule.day == day)
              schedule.copyWith(isEnabled: !schedule.isEnabled)
            else
              schedule,
        ],
      ),
    );
  }

  void addTimeRange(Weekday day, TimeRangeModel timeRange) {
    safeEmit(
      state.copyWith(
        weeklySchedule: [
          for (final schedule in state.weeklySchedule)
            if (schedule.day == day)
              schedule.copyWith(
                timeRanges: [...schedule.timeRanges, timeRange],
              )
            else
              schedule,
        ],
      ),
    );
  }

  void removeTimeRange(Weekday day, int index) {
    safeEmit(
      state.copyWith(
        weeklySchedule: [
          for (final schedule in state.weeklySchedule)
            if (schedule.day == day)
              schedule.copyWith(
                timeRanges: [...schedule.timeRanges]..removeAt(index),
              )
            else
              schedule,
        ],
      ),
    );
  }

  Future<void> submitBookingSettings() async {
    if (!state.canSubmit) return;
    safeEmit(state.copyWith(submissionStatus: RequestStatus.loading));

    final model = BookingSettingsRequestBodyModel(
      maxDailyBookings: state.effectiveMaxDailyBookings!,
      intervalMinutes: state.effectiveIntervalMinutes!,
      weeklySchedule: state.weeklySchedule,
    );

    final response = await _bookingSettingsRepo.submitBookingSettings(model);
    response.when(
      success: (message) => safeEmit(
        state.copyWith(
          message: message,
          submissionStatus: RequestStatus.success,
        ),
      ),
      failure: (error) => safeEmit(
        state.copyWith(
          message: error.errors.first,
          submissionStatus: RequestStatus.failure,
        ),
      ),
    );
  }
}
