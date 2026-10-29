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
import 'package:we_care/features/doctor/shared/logic/profile_form_edit_helpers.dart';

part 'booking_settings_state.dart';

class BookingSettingsCubit extends Cubit<BookingSettingsState>
    with SafeEmitMixin<BookingSettingsState> {
  BookingSettingsCubit(this._bookingSettingsRepo)
      : super(BookingSettingsState.initial());

  final BookingSettingsRepo _bookingSettingsRepo;
  final _changesTracker = ProfileFormChangesTracker();

  static const maxDailyBookingsOptions = [5, 10, 15, 20, 25, 30, 40, 50];
  static const intervalMinutesOptions = [10, 15, 20, 30, 45, 60];

  /// Loads the doctor's saved booking settings and fills the form with them.
  Future<void> loadInitialData() async {
    safeEmit(state.copyWith(loadStatus: RequestStatus.loading));
    final response = await _bookingSettingsRepo.getBookingSettings();
    response.when(
      success: (settings) {
        if (settings == null) {
          safeEmit(state.copyWith(loadStatus: RequestStatus.success));
          return;
        }
        final initial = BookingSettingsState.initial();
        final loaded = state.copyWith(
          // Guard against a zero/negative value, which the calculated
          // getters divide by.
          maxDailyBookings: settings.maxDailyBookings > 0
              ? settings.maxDailyBookings
              : initial.maxDailyBookings,
          intervalMinutes: settings.intervalMinutes > 0
              ? settings.intervalMinutes
              : initial.intervalMinutes,
          weeklySchedule: _fullWeek(settings.weeklySchedule),
        );
        final restored = loaded.copyWith(
          valueSource: _restoredValueSource(loaded),
        );
        _changesTracker.setBaseline(_buildRequestJson(restored));
        safeEmit(restored.copyWith(
          loadStatus: RequestStatus.success,
          isEditMode: true,
          hasChanges: false,
        ));
      },
      failure: (error) => safeEmit(state.copyWith(
        loadStatus: RequestStatus.failure,
        message: error.errors.first,
      )),
    );
  }

  /// All 7 days in the screen's order. Days missing from the saved data are
  /// shown as disabled with no time ranges.
  List<WeekdayScheduleModel> _fullWeek(List<WeekdayScheduleModel> saved) => [
        for (final day in Weekday.values)
          saved.firstWhere(
            (schedule) => schedule.day == day,
            orElse: () => WeekdayScheduleModel(
              day: day,
              isEnabled: false,
              timeRanges: const <TimeRangeModel>[],
            ),
          ),
      ];

  /// The value source isn't saved on the server, so pick the one that shows
  /// both saved values unchanged: with the daily limit picked by hand the
  /// interval is calculated from the schedule, and vice versa. The screen's
  /// default (daily limit by hand) wins when both fit, and is also the
  /// fallback when neither does.
  BookingValueSource _restoredValueSource(BookingSettingsState loaded) {
    final byDailyBookings =
        loaded.copyWith(valueSource: BookingValueSource.dailyBookings);
    if (byDailyBookings.effectiveIntervalMinutes == loaded.intervalMinutes) {
      return BookingValueSource.dailyBookings;
    }
    final byInterval =
        loaded.copyWith(valueSource: BookingValueSource.interval);
    if (byInterval.effectiveMaxDailyBookings == loaded.maxDailyBookings) {
      return BookingValueSource.interval;
    }
    return BookingValueSource.dailyBookings;
  }

  /// The JSON the form would send. Built by hand rather than through
  /// [BookingSettingsRequestBodyModel] because the calculated value can be
  /// `null` while the doctor is still editing.
  Map<String, dynamic> _buildRequestJson(BookingSettingsState form) => {
        'maxDailyBookings': form.effectiveMaxDailyBookings,
        'intervalMinutes': form.effectiveIntervalMinutes,
        'weeklySchedule':
            form.weeklySchedule.map((schedule) => schedule.toJson()).toList(),
      };

  void _updateHasChanges() {
    final hasChanges = _changesTracker.hasChanges(_buildRequestJson(state));
    if (hasChanges != state.hasChanges) {
      safeEmit(state.copyWith(hasChanges: hasChanges));
    }
  }

  void updateMaxDailyBookings(int value) {
    safeEmit(state.copyWith(maxDailyBookings: value));
    _updateHasChanges();
  }

  void updateIntervalMinutes(int value) {
    safeEmit(state.copyWith(intervalMinutes: value));
    _updateHasChanges();
  }

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
    _updateHasChanges();
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
    _updateHasChanges();
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
    _updateHasChanges();
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
    _updateHasChanges();
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
