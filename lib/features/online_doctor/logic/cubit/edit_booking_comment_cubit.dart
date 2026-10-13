import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/features/online_doctor/data/models/booking_history_model.dart';
import 'package:we_care/features/online_doctor/data/repos/online_doctor_repo.dart';

part 'edit_booking_comment_state.dart';

class EditBookingCommentCubit extends Cubit<EditBookingCommentState> {
  EditBookingCommentCubit(this._onlineDoctorRepo)
      : super(const EditBookingCommentState());

  final OnlineDoctorRepo _onlineDoctorRepo;

  /// نفس الطلب لأول تعليق ولتعديله — [text] من غير مسافات فى الأطراف.
  Future<void> saveComment({
    required BookingHistoryModel booking,
    required String text,
  }) async {
    if (state.saveStatus == RequestStatus.loading) return;
    emit(state.copyWith(saveStatus: RequestStatus.loading));

    final result = await _onlineDoctorRepo.saveBookingComment(
      booking: booking,
      text: text,
    );
    if (isClosed) return;

    result.when(
      success: (commentedBooking) {
        emit(
          state.copyWith(
            saveStatus: RequestStatus.success,
            commentedBooking: commentedBooking,
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
