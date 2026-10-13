part of 'bookings_cubit.dart';

@immutable
class BookingsState extends Equatable {
  final RequestStatus status;
  final BookingsModel? bookings;
  final String message;

  /// `bookingId` of the waiting patient whose accept / reject request is
  /// running — empty when none is.
  final String processingBookingId;

  /// Status of the last accept / reject request.
  final RequestStatus actionStatus;

  /// Failure message of the last accept / reject request — shown as a toast.
  final String actionMessage;

  const BookingsState({
    required this.status,
    this.bookings,
    this.message = '',
    this.processingBookingId = '',
    this.actionStatus = RequestStatus.initial,
    this.actionMessage = '',
  });

  factory BookingsState.initial() =>
      const BookingsState(status: RequestStatus.initial);

  BookingsState copyWith({
    RequestStatus? status,
    BookingsModel? bookings,
    String? message,
    String? processingBookingId,
    RequestStatus? actionStatus,
    String? actionMessage,
  }) {
    return BookingsState(
      status: status ?? this.status,
      bookings: bookings ?? this.bookings,
      message: message ?? this.message,
      processingBookingId: processingBookingId ?? this.processingBookingId,
      actionStatus: actionStatus ?? this.actionStatus,
      actionMessage: actionMessage ?? this.actionMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        bookings,
        message,
        processingBookingId,
        actionStatus,
        actionMessage,
      ];
}
