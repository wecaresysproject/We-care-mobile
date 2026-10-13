part of 'upcoming_bookings_cubit.dart';

class UpcomingBookingsState extends Equatable {
  final RequestStatus requestStatus;
  final List<BookingModel> bookings;
  final String errorMessage;

  /// حالة طلب إلغاء موعد — منفصلة عن تحميل القايمة.
  final RequestStatus cancelStatus;

  /// رسالة فشل آخر طلب إلغاء — بتتعرض كـ toast.
  final String cancelMessage;

  const UpcomingBookingsState({
    this.requestStatus = RequestStatus.initial,
    this.bookings = const [],
    this.errorMessage = '',
    this.cancelStatus = RequestStatus.initial,
    this.cancelMessage = '',
  });

  UpcomingBookingsState copyWith({
    RequestStatus? requestStatus,
    List<BookingModel>? bookings,
    String? errorMessage,
    RequestStatus? cancelStatus,
    String? cancelMessage,
  }) {
    return UpcomingBookingsState(
      requestStatus: requestStatus ?? this.requestStatus,
      bookings: bookings ?? this.bookings,
      errorMessage: errorMessage ?? this.errorMessage,
      cancelStatus: cancelStatus ?? this.cancelStatus,
      cancelMessage: cancelMessage ?? this.cancelMessage,
    );
  }

  @override
  List<Object?> get props => [
        requestStatus,
        bookings,
        errorMessage,
        cancelStatus,
        cancelMessage,
      ];
}
