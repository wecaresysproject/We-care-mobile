part of 'appointment_room_cubit.dart';

class AppointmentRoomState extends Equatable {
  final RequestStatus requestStatus;

  /// بيانات الغرفة — `null` لحد ما الـ API يرد.
  final AppointmentRoomModel? room;
  final String errorMessage;

  /// أسئلة المريض للطبيب — بتبدأ من رد الغرفة وبتتحدث من رد كل إضافة
  /// أو تعديل أو حذف من غير إعادة تحميل الغرفة.
  final List<RoomQuestionModel> questions;

  /// حالة آخر طلب إضافة/تعديل/حذف سؤال.
  final RequestStatus questionRequestStatus;

  /// رسالة فشل آخر طلب على الأسئلة — بتتعرض كـ toast.
  final String questionErrorMessage;

  const AppointmentRoomState({
    this.requestStatus = RequestStatus.initial,
    this.room,
    this.errorMessage = '',
    this.questions = const [],
    this.questionRequestStatus = RequestStatus.initial,
    this.questionErrorMessage = '',
  });

  AppointmentRoomState copyWith({
    RequestStatus? requestStatus,
    AppointmentRoomModel? room,
    String? errorMessage,
    List<RoomQuestionModel>? questions,
    RequestStatus? questionRequestStatus,
    String? questionErrorMessage,
  }) {
    return AppointmentRoomState(
      requestStatus: requestStatus ?? this.requestStatus,
      room: room ?? this.room,
      errorMessage: errorMessage ?? this.errorMessage,
      questions: questions ?? this.questions,
      questionRequestStatus:
          questionRequestStatus ?? this.questionRequestStatus,
      questionErrorMessage: questionErrorMessage ?? this.questionErrorMessage,
    );
  }

  @override
  List<Object?> get props => [
        requestStatus,
        room,
        errorMessage,
        questions,
        questionRequestStatus,
        questionErrorMessage,
      ];
}
