import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/features/online_doctor/data/models/booking_history_filters_model.dart';
import 'package:we_care/features/online_doctor/data/models/booking_history_model.dart';
import 'package:we_care/features/online_doctor/data/repos/online_doctor_repo.dart';

part 'bookings_history_state.dart';

class BookingsHistoryCubit extends Cubit<BookingsHistoryState> {
  BookingsHistoryCubit(this._onlineDoctorRepo)
      : super(const BookingsHistoryState());

  final OnlineDoctorRepo _onlineDoctorRepo;

  /// أول تحميل للشاشة — قيم الفلترين والسجل كامل مع بعض.
  Future<void> loadHistory() async {
    await Future.wait([_getFilters(), getBookingsHistory()]);
  }

  /// فشل تحميل قيم الفلاتر مش بيوقف الشاشة — القوايم بتفضل على "الكل" بس.
  Future<void> _getFilters() async {
    final result = await _onlineDoctorRepo.getBookingsHistoryFilters();
    if (isClosed) return;

    result.when(
      success: (filters) => emit(state.copyWith(filters: filters)),
      failure: (_) {},
    );
  }

  /// بيحمّل السجل بالفلاتر المختارة حاليًا.
  Future<void> getBookingsHistory() async {
    emit(state.copyWith(requestStatus: RequestStatus.loading));

    final result = await _onlineDoctorRepo.getBookingsHistory(
      doctorId: state.selectedDoctor?.id,
      specialty: state.selectedSpecialty,
    );
    if (isClosed) return;

    result.when(
      success: (bookings) {
        emit(
          state.copyWith(
            requestStatus: RequestStatus.success,
            bookings: bookings,
          ),
        );
      },
      failure: (error) {
        emit(
          state.copyWith(
            requestStatus: RequestStatus.failure,
            errorMessage: error.errors.first,
          ),
        );
      },
    );
  }

  Future<void> selectDoctor(BookingHistoryFilterDoctor? doctor) =>
      _applyFilters(doctor: doctor, specialty: state.selectedSpecialty);

  Future<void> selectSpecialty(String? specialty) =>
      _applyFilters(doctor: state.selectedDoctor, specialty: specialty);

  Future<void> clearFilters() => _applyFilters(doctor: null, specialty: null);

  Future<void> _applyFilters({
    required BookingHistoryFilterDoctor? doctor,
    required String? specialty,
  }) async {
    emit(state.withSelectedFilters(doctor: doctor, specialty: specialty));
    await getBookingsHistory();
  }
}
