part of 'bookings_cubit.dart';

@immutable
class BookingsState extends Equatable {
  final RequestStatus status;
  final BookingsModel? bookings;
  final String message;

  const BookingsState({
    required this.status,
    this.bookings,
    this.message = '',
  });

  factory BookingsState.initial() =>
      const BookingsState(status: RequestStatus.initial);

  BookingsState copyWith({
    RequestStatus? status,
    BookingsModel? bookings,
    String? message,
  }) {
    return BookingsState(
      status: status ?? this.status,
      bookings: bookings ?? this.bookings,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [status, bookings, message];
}
