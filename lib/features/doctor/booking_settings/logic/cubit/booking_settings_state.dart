part of 'booking_settings_cubit.dart';

class BookingSettingsState extends Equatable {
  const BookingSettingsState({
    required this.maxDailyBookings,
    required this.intervalMinutes,
    required this.valueSource,
    required this.weeklySchedule,
    required this.submissionStatus,
    required this.message,
  });

  factory BookingSettingsState.initial() => BookingSettingsState(
        maxDailyBookings: 10,
        intervalMinutes: 30,
        valueSource: BookingValueSource.dailyBookings,
        weeklySchedule: [
          WeekdayScheduleModel(
            day: Weekday.saturday,
            isEnabled: true,
            timeRanges: [
              TimeRangeModel(startTime: '10:00', endTime: '13:00'),
              TimeRangeModel(startTime: '18:00', endTime: '21:00'),
            ],
          ),
          WeekdayScheduleModel(
            day: Weekday.sunday,
            isEnabled: true,
            timeRanges: [
              TimeRangeModel(startTime: '10:00', endTime: '13:00'),
            ],
          ),
          WeekdayScheduleModel(
            day: Weekday.monday,
            isEnabled: true,
            timeRanges: [
              TimeRangeModel(startTime: '16:00', endTime: '20:00'),
            ],
          ),
          WeekdayScheduleModel(
            day: Weekday.tuesday,
            isEnabled: true,
            timeRanges: [
              TimeRangeModel(startTime: '10:00', endTime: '13:00'),
            ],
          ),
          WeekdayScheduleModel(
            day: Weekday.wednesday,
            isEnabled: true,
            timeRanges: [
              TimeRangeModel(startTime: '16:00', endTime: '20:00'),
            ],
          ),
          WeekdayScheduleModel(
            day: Weekday.thursday,
            isEnabled: true,
            timeRanges: [
              TimeRangeModel(startTime: '10:00', endTime: '13:00'),
            ],
          ),
          WeekdayScheduleModel(
            day: Weekday.friday,
            isEnabled: false,
            timeRanges: const [],
          ),
        ],
        submissionStatus: RequestStatus.initial,
        message: null,
      );

  /// The doctor's picked daily limit. Only meaningful while [valueSource]
  /// is [BookingValueSource.dailyBookings]; read [effectiveMaxDailyBookings].
  final int maxDailyBookings;

  /// The doctor's picked interval. Only meaningful while [valueSource] is
  /// [BookingValueSource.interval]; read [effectiveIntervalMinutes].
  final int intervalMinutes;

  final BookingValueSource valueSource;
  final List<WeekdayScheduleModel> weeklySchedule;

  final RequestStatus submissionStatus;
  final String? message;

  /// Total booking minutes of the busiest enabled day. The calculated value
  /// is sized against this day, so no day exceeds the daily limit.
  int get busiestDayMinutes {
    var busiest = 0;
    for (final schedule in weeklySchedule) {
      if (!schedule.isEnabled) continue;
      final minutes = schedule.timeRanges.fold<int>(
        0,
        (total, range) => total + _rangeMinutes(range),
      );
      if (minutes > busiest) busiest = minutes;
    }
    return busiest;
  }

  /// Interval that fits [maxDailyBookings] into the busiest day, or `null`
  /// when there are no booking times yet or the limit doesn't fit.
  int? get calculatedIntervalMinutes {
    final interval = busiestDayMinutes ~/ maxDailyBookings;
    return interval > 0 ? interval : null;
  }

  /// How many [intervalMinutes] slots fit into the busiest day, or `null`
  /// when not even one fits.
  int? get calculatedMaxDailyBookings {
    final bookings = busiestDayMinutes ~/ intervalMinutes;
    return bookings > 0 ? bookings : null;
  }

  int? get effectiveMaxDailyBookings =>
      valueSource == BookingValueSource.dailyBookings
          ? maxDailyBookings
          : calculatedMaxDailyBookings;

  int? get effectiveIntervalMinutes =>
      valueSource == BookingValueSource.interval
          ? intervalMinutes
          : calculatedIntervalMinutes;

  bool get canSubmit =>
      effectiveMaxDailyBookings != null && effectiveIntervalMinutes != null;

  BookingSettingsState copyWith({
    int? maxDailyBookings,
    int? intervalMinutes,
    BookingValueSource? valueSource,
    List<WeekdayScheduleModel>? weeklySchedule,
    RequestStatus? submissionStatus,
    String? message,
  }) {
    return BookingSettingsState(
      maxDailyBookings: maxDailyBookings ?? this.maxDailyBookings,
      intervalMinutes: intervalMinutes ?? this.intervalMinutes,
      valueSource: valueSource ?? this.valueSource,
      weeklySchedule: weeklySchedule ?? this.weeklySchedule,
      submissionStatus: submissionStatus ?? this.submissionStatus,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [
        maxDailyBookings,
        intervalMinutes,
        valueSource,
        weeklySchedule,
        submissionStatus,
        message,
      ];
}

/// Length of a `HH:mm` – `HH:mm` range in minutes. An end at or before the
/// start is treated as running past midnight.
int _rangeMinutes(TimeRangeModel range) {
  int toMinutes(String time) {
    final parts = time.split(':');
    return int.parse(parts[0]) * 60 + int.parse(parts[1]);
  }

  final start = toMinutes(range.startTime);
  var end = toMinutes(range.endTime);
  if (end <= start) end += 24 * 60;
  return end - start;
}
