part of 'bookings_history_cubit.dart';

class BookingsHistoryState extends Equatable {
  final RequestStatus requestStatus;
  final List<BookingHistoryModel> bookings;
  final String errorMessage;

  /// قيم الفلترين زى ما راجعة من الـ API.
  final BookingHistoryFiltersModel filters;

  /// الفلتر المختار — `null` يعنى "الكل".
  final BookingHistoryFilterDoctor? selectedDoctor;
  final String? selectedSpecialty;

  const BookingsHistoryState({
    this.requestStatus = RequestStatus.initial,
    this.bookings = const [],
    this.errorMessage = '',
    this.filters = const BookingHistoryFiltersModel(),
    this.selectedDoctor,
    this.selectedSpecialty,
  });

  bool get hasActiveFilters =>
      selectedDoctor != null || selectedSpecialty != null;

  /// الفلترين مش جزء من `copyWith` عشان `null` فيهم قيمة مقصودة ("الكل") —
  /// بيتغيروا من [withSelectedFilters].
  BookingsHistoryState copyWith({
    RequestStatus? requestStatus,
    List<BookingHistoryModel>? bookings,
    String? errorMessage,
    BookingHistoryFiltersModel? filters,
  }) {
    return BookingsHistoryState(
      requestStatus: requestStatus ?? this.requestStatus,
      bookings: bookings ?? this.bookings,
      errorMessage: errorMessage ?? this.errorMessage,
      filters: filters ?? this.filters,
      selectedDoctor: selectedDoctor,
      selectedSpecialty: selectedSpecialty,
    );
  }

  BookingsHistoryState withSelectedFilters({
    required BookingHistoryFilterDoctor? doctor,
    required String? specialty,
  }) {
    return BookingsHistoryState(
      requestStatus: requestStatus,
      bookings: bookings,
      errorMessage: errorMessage,
      filters: filters,
      selectedDoctor: doctor,
      selectedSpecialty: specialty,
    );
  }

  @override
  List<Object?> get props => [
        requestStatus,
        bookings,
        errorMessage,
        filters,
        selectedDoctor,
        selectedSpecialty,
      ];
}
