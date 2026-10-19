part of 'examination_call_cubit.dart';

enum ExaminationCallStatus {
  loading,

  /// مفيش اجتماع لسه أو الطبيب أنشأه ومبدأش — الـ cubit بيعيد المحاولة.
  waitingForDoctor,

  /// الطبيب بدأ الاجتماع — الشاشة تفتح الغرفة.
  ready,
  ended,
  failure,
}

class ExaminationCallState extends Equatable {
  final ExaminationCallStatus status;

  /// `null` لحد ما الطبيب ينشئ الاجتماع.
  final VideoMeetingModel? meeting;
  final String errorMessage;

  const ExaminationCallState({
    this.status = ExaminationCallStatus.loading,
    this.meeting,
    this.errorMessage = '',
  });

  ExaminationCallState copyWith({
    ExaminationCallStatus? status,
    VideoMeetingModel? meeting,
    String? errorMessage,
  }) {
    return ExaminationCallState(
      status: status ?? this.status,
      meeting: meeting ?? this.meeting,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, meeting, errorMessage];
}
