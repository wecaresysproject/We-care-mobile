part of 'book_appointment_cubit.dart';

class BookAppointmentState extends Equatable {
  /// حالة تحميل الأيام المتاحة وتوقيتاتها.
  final RequestStatus availabilityStatus;
  final List<AppointmentDayModel> availableDays;
  final String errorMessage;

  /// حالة طلب الحجز نفسه — منفصلة عن تحميل المواعيد.
  final RequestStatus bookingStatus;

  /// رسالة فشل آخر طلب حجز — بتتعرض كـ toast.
  final String bookingMessage;

  const BookAppointmentState({
    this.availabilityStatus = RequestStatus.initial,
    this.availableDays = const [],
    this.errorMessage = '',
    this.bookingStatus = RequestStatus.initial,
    this.bookingMessage = '',
  });

  BookAppointmentState copyWith({
    RequestStatus? availabilityStatus,
    List<AppointmentDayModel>? availableDays,
    String? errorMessage,
    RequestStatus? bookingStatus,
    String? bookingMessage,
  }) {
    return BookAppointmentState(
      availabilityStatus: availabilityStatus ?? this.availabilityStatus,
      availableDays: availableDays ?? this.availableDays,
      errorMessage: errorMessage ?? this.errorMessage,
      bookingStatus: bookingStatus ?? this.bookingStatus,
      bookingMessage: bookingMessage ?? this.bookingMessage,
    );
  }

  @override
  List<Object?> get props => [
        availabilityStatus,
        availableDays,
        errorMessage,
        bookingStatus,
        bookingMessage,
      ];
}
