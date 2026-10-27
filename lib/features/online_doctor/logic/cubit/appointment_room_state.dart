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

  /// المشاركين غير المريض — بيبدأوا من رد الغرفة وبيتحدثوا من رد كل
  /// إضافة أو إزالة من غير إعادة تحميل الغرفة.
  final List<RoomParticipantModel> participants;

  /// حالة آخر طلب إضافة/إزالة مشارك.
  final RequestStatus participantRequestStatus;

  /// رسالة آخر طلب على المشاركين — نجاح أو فشل، وبتتعرض كـ toast.
  final String participantMessage;

  const AppointmentRoomState({
    this.requestStatus = RequestStatus.initial,
    this.room,
    this.errorMessage = '',
    this.questions = const [],
    this.questionRequestStatus = RequestStatus.initial,
    this.questionErrorMessage = '',
    this.participants = const [],
    this.participantRequestStatus = RequestStatus.initial,
    this.participantMessage = '',
  });

  AppointmentRoomState copyWith({
    RequestStatus? requestStatus,
    AppointmentRoomModel? room,
    String? errorMessage,
    List<RoomQuestionModel>? questions,
    RequestStatus? questionRequestStatus,
    String? questionErrorMessage,
    List<RoomParticipantModel>? participants,
    RequestStatus? participantRequestStatus,
    String? participantMessage,
  }) {
    return AppointmentRoomState(
      requestStatus: requestStatus ?? this.requestStatus,
      room: room ?? this.room,
      errorMessage: errorMessage ?? this.errorMessage,
      questions: questions ?? this.questions,
      questionRequestStatus:
          questionRequestStatus ?? this.questionRequestStatus,
      questionErrorMessage: questionErrorMessage ?? this.questionErrorMessage,
      participants: participants ?? this.participants,
      participantRequestStatus:
          participantRequestStatus ?? this.participantRequestStatus,
      participantMessage: participantMessage ?? this.participantMessage,
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
        participants,
        participantRequestStatus,
        participantMessage,
      ];
}
