import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/features/online_doctor/data/models/booking_history_model.dart';
import 'package:we_care/features/online_doctor/data/repos/online_doctor_repo.dart';

part 'edit_booking_rating_state.dart';

class EditBookingRatingCubit extends Cubit<EditBookingRatingState> {
  EditBookingRatingCubit(this._onlineDoctorRepo)
      : super(const EditBookingRatingState());

  final OnlineDoctorRepo _onlineDoctorRepo;

  /// نفس الطلب لأول تقييم ولتعديله — [stars] من 1 لـ 5.
  Future<void> saveRating({
    required BookingHistoryModel booking,
    required int stars,
  }) async {
    if (state.saveStatus == RequestStatus.loading) return;
    emit(state.copyWith(saveStatus: RequestStatus.loading));

    final result = await _onlineDoctorRepo.saveBookingRating(
      booking: booking,
      stars: stars,
    );
    if (isClosed) return;

    result.when(
      success: (ratedBooking) {
        emit(
          state.copyWith(
            saveStatus: RequestStatus.success,
            ratedBooking: ratedBooking,
          ),
        );
      },
      failure: (error) {
        emit(
          state.copyWith(
            saveStatus: RequestStatus.failure,
            errorMessage: error.errors.first,
          ),
        );
      },
    );
  }
}
