part of 'booking_settings_cubit.dart';

class BookingSettingsState extends Equatable {
  const BookingSettingsState({
    required this.maxDailyBookings,
    required this.intervalMinutes,
    required this.weeklySchedule,
    required this.submissionStatus,
    required this.message,
  });

  factory BookingSettingsState.initial() => BookingSettingsState(
        maxDailyBookings: 10,
        intervalMinutes: 30,
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

  final int maxDailyBookings;
  final int intervalMinutes;
  final List<WeekdayScheduleModel> weeklySchedule;

  final RequestStatus submissionStatus;
  final String? message;

  BookingSettingsState copyWith({
    int? maxDailyBookings,
    int? intervalMinutes,
    List<WeekdayScheduleModel>? weeklySchedule,
    RequestStatus? submissionStatus,
    String? message,
  }) {
    return BookingSettingsState(
      maxDailyBookings: maxDailyBookings ?? this.maxDailyBookings,
      intervalMinutes: intervalMinutes ?? this.intervalMinutes,
      weeklySchedule: weeklySchedule ?? this.weeklySchedule,
      submissionStatus: submissionStatus ?? this.submissionStatus,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [
        maxDailyBookings,
        intervalMinutes,
        weeklySchedule,
        submissionStatus,
        message,
      ];
}
