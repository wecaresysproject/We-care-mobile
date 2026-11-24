import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/features/online_doctor/data/repos/online_doctor_repo.dart';

part 'consultation_review_state.dart';

class ConsultationReviewCubit extends Cubit<ConsultationReviewState> {
  ConsultationReviewCubit(this._onlineDoctorRepo)
      : super(const ConsultationReviewState());

  final OnlineDoctorRepo _onlineDoctorRepo;

  /// التقييم والتعليق الاتنين اختياريين — بيتبعت اللى المريض اختاره بس.
  Future<void> submitReview({
    required String bookingId,
    int? stars,
    String comment = '',
  }) async {
    if (state.submitStatus == RequestStatus.loading) return;
    emit(state.copyWith(submitStatus: RequestStatus.loading));

    final result = await _onlineDoctorRepo.submitConsultationReview(
      bookingId: bookingId,
      stars: stars,
      comment: comment,
    );
    if (isClosed) return;

    result.when(
      success: (_) => emit(state.copyWith(submitStatus: RequestStatus.success)),
      failure: (error) => emit(
        state.copyWith(
          submitStatus: RequestStatus.failure,
          errorMessage: error.errors.first,
        ),
      ),
    );
  }
}
