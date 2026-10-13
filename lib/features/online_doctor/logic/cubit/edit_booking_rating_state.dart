part of 'edit_booking_rating_cubit.dart';

class EditBookingRatingState extends Equatable {
  final RequestStatus saveStatus;

  /// رسالة فشل آخر طلب حفظ — بتتعرض كـ toast.
  final String errorMessage;

  /// الموعد بالتقييم الجديد بعد نجاح الحفظ — بيرجع لشاشة التفاصيل.
  final BookingHistoryModel? ratedBooking;

  const EditBookingRatingState({
    this.saveStatus = RequestStatus.initial,
    this.errorMessage = '',
    this.ratedBooking,
  });

  EditBookingRatingState copyWith({
    RequestStatus? saveStatus,
    String? errorMessage,
    BookingHistoryModel? ratedBooking,
  }) {
    return EditBookingRatingState(
      saveStatus: saveStatus ?? this.saveStatus,
      errorMessage: errorMessage ?? this.errorMessage,
      ratedBooking: ratedBooking ?? this.ratedBooking,
    );
  }

  @override
  List<Object?> get props => [saveStatus, errorMessage, ratedBooking];
}
