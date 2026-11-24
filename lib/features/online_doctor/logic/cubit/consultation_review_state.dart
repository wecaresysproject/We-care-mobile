part of 'consultation_review_cubit.dart';

class ConsultationReviewState extends Equatable {
  final RequestStatus submitStatus;

  /// رسالة فشل آخر إرسال — بتتعرض كـ toast.
  final String errorMessage;

  const ConsultationReviewState({
    this.submitStatus = RequestStatus.initial,
    this.errorMessage = '',
  });

  ConsultationReviewState copyWith({
    RequestStatus? submitStatus,
    String? errorMessage,
  }) {
    return ConsultationReviewState(
      submitStatus: submitStatus ?? this.submitStatus,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [submitStatus, errorMessage];
}
