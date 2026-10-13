import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/features/online_doctor/data/models/booking_model.dart';
import 'package:we_care/features/online_doctor/data/repos/online_doctor_repo.dart';

part 'upcoming_bookings_state.dart';

class UpcomingBookingsCubit extends Cubit<UpcomingBookingsState> {
  UpcomingBookingsCubit(this._onlineDoctorRepo)
      : super(const UpcomingBookingsState());

  final OnlineDoctorRepo _onlineDoctorRepo;

  Future<void> getUpcomingBookings() async {
    emit(state.copyWith(requestStatus: RequestStatus.loading));

    final result = await _onlineDoctorRepo.getUpcomingBookings();
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

  /// بيلغى الموعد على السيرفر — الكارت بيتشال بعد ما الـ API يأكد بس.
  Future<void> cancelBooking(BookingModel booking) async {
    if (state.cancelStatus == RequestStatus.loading) return;
    emit(state.copyWith(cancelStatus: RequestStatus.loading));

    final result = await _onlineDoctorRepo.cancelBooking(
      bookingId: booking.bookingId,
    );
    if (isClosed) return;

    result.when(
      success: (_) {
        emit(
          state.copyWith(
            cancelStatus: RequestStatus.success,
            bookings: state.bookings.where((b) => b != booking).toList(),
          ),
        );
      },
      failure: (error) {
        emit(
          state.copyWith(
            cancelStatus: RequestStatus.failure,
            cancelMessage: error.errors.first,
          ),
        );
      },
    );
  }

  /// بيحدّث الكارت بعد ما شاشة "تعديل الموعد" تأكد التعديل من الـ API.
  void replaceBooking(BookingModel booking, BookingModel updatedBooking) {
    emit(
      state.copyWith(
        bookings: [
          for (final b in state.bookings) b == booking ? updatedBooking : b,
        ],
      ),
    );
  }
}
