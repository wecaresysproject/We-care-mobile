import 'package:we_care/features/online_doctor/data/models/booking_model.dart';

/// بيانات شاشة غرفة الكشف/الاستشارة لموعد قادم واحد — ملخص الطبيب والموعد،
/// المشاركين غير المريض، وأسئلة المريض للطبيب.
class AppointmentRoomModel {
  const AppointmentRoomModel({
    required this.booking,
    required this.maxParticipants,
    required this.participants,
    required this.questions,
  });

  /// `data` من endpoint الغرفة — الحجز نفسه بنفس حقول المواعيد القادمة.
  factory AppointmentRoomModel.fromJson(Map<String, dynamic> json) {
    return AppointmentRoomModel(
      booking: BookingModel.fromJson(json),
      maxParticipants:
          (json['maxParticipants'] as num?)?.toInt() ?? defaultMaxParticipants,
      participants: (json['participants'] as List? ?? const [])
          .map((e) => RoomParticipantModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      questions: (json['questions'] as List? ?? const [])
          .map((e) => RoomQuestionModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  /// الحد المعروض لحد ما الـ API يرد، ولو مرجّعش `maxParticipants`.
  static const int defaultMaxParticipants = 3;

  final BookingModel booking;

  /// أقصى عدد مشاركين غير المريض فى المحادثة.
  final int maxParticipants;
  final List<RoomParticipantModel> participants;

  /// مرتبة بالأقدم أولاً — الشاشة بترقمها 1، 2، 3…
  final List<RoomQuestionModel> questions;
}

/// مشارك واحد فى محادثة الكشف غير المريض — اسم وصلة قرابة وصورة اختيارية.
class RoomParticipantModel {
  const RoomParticipantModel({
    required this.name,
    required this.relation,
    this.imageUrl,
    this.participantId = '',
    this.userId = '',
  });

  factory RoomParticipantModel.fromJson(Map<String, dynamic> json) {
    final image = json['profileImage'] as String?;
    return RoomParticipantModel(
      participantId: json['participantId']?.toString() ?? '',
      userId: json['userId']?.toString() ?? '',
      name: json['name'] as String? ?? '',
      relation: json['relation'] as String? ?? '',
      imageUrl: image == null || image.trim().isEmpty ? null : image,
    );
  }

  /// بيتستخدم فى endpoint إزالة المشارك.
  final String participantId;

  /// حساب المشارك فى السيستم — بيمنع إضافة نفس الشخص مرتين.
  final String userId;
  final String name;
  final String relation;

  /// من غير صورة المشارك بيظهر بأول حرف من اسمه.
  final String? imageUrl;
}

/// سؤال واحد من أسئلة المريض للطبيب.
class RoomQuestionModel {
  const RoomQuestionModel({required this.text, this.questionId = ''});

  factory RoomQuestionModel.fromJson(Map<String, dynamic> json) {
    return RoomQuestionModel(
      questionId: json['questionId']?.toString() ?? '',
      text: json['text'] as String? ?? '',
    );
  }

  /// هيتستخدم فى تعديل وحذف السؤال — فاضى للسؤال المضاف محليًا.
  final String questionId;
  final String text;
}
