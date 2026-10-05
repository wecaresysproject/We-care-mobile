/// Which of the two linked booking values the doctor sets by hand. The other
/// one is calculated from the weekly booking days and times, and shown
/// locked.
enum BookingValueSource {
  /// The doctor picks the daily bookings limit; the interval is calculated.
  dailyBookings,

  /// The doctor picks the appointment interval; the daily limit is calculated.
  interval,
}
