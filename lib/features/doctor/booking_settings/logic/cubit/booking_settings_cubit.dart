import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/features/doctor/booking_settings/data/models/booking_settings_request_body_model.dart';
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
    safeEmit(state.copyWith(submissionStatus: RequestStatus.loading));

    final model = BookingSettingsRequestBodyModel(
      maxDailyBookings: state.maxDailyBookings,
      intervalMinutes: state.intervalMinutes,
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
