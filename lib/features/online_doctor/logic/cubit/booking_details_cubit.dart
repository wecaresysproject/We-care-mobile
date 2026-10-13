import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/features/online_doctor/data/models/booking_history_model.dart';
import 'package:we_care/features/online_doctor/data/repos/online_doctor_repo.dart';

part 'booking_details_state.dart';

class BookingDetailsCubit extends Cubit<BookingDetailsState> {
  BookingDetailsCubit(this._onlineDoctorRepo)
      : super(const BookingDetailsState());

  final OnlineDoctorRepo _onlineDoctorRepo;

  Future<void> getBookingDetails(String bookingId) async {
    emit(state.copyWith(requestStatus: RequestStatus.loading));

    final result = await _onlineDoctorRepo.getBookingDetails(
      bookingId: bookingId,
    );
    if (isClosed) return;

    result.when(
      success: (booking) {
        emit(
          state.copyWith(
            requestStatus: RequestStatus.success,
            booking: booking,
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
}
