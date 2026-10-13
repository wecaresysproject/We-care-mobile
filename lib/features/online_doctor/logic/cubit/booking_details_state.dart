part of 'booking_details_cubit.dart';

class BookingDetailsState extends Equatable {
  final RequestStatus requestStatus;

  /// تفاصيل الموعد الكاملة — `null` لحد ما الـ API يرد.
  final BookingHistoryModel? booking;
  final String errorMessage;

  const BookingDetailsState({
    this.requestStatus = RequestStatus.initial,
    this.booking,
    this.errorMessage = '',
  });

  BookingDetailsState copyWith({
    RequestStatus? requestStatus,
    BookingHistoryModel? booking,
    String? errorMessage,
  }) {
    return BookingDetailsState(
      requestStatus: requestStatus ?? this.requestStatus,
      booking: booking ?? this.booking,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [requestStatus, booking, errorMessage];
}
