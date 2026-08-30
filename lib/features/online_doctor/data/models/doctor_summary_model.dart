import 'package:json_annotation/json_annotation.dart';
import 'package:we_care/features/online_doctor/data/models/nearest_appointment_model.dart';

part 'doctor_summary_model.g.dart';

/// عنصر واحد فى قايمة الأطباء (`GET /OnlineDoctor?specialty=`) —
/// الملف الكامل بيتجاب بـ [id] من endpoint البروفايل.
@JsonSerializable()
class DoctorSummaryModel {
  final String id;
  final String name;

  /// التخصص/اللقب المعروض تحت الاسم — مثال: "أخصائي باطنة".
  final String specialty;

  /// الدرجة الوظيفية وجهة العمل — مثال: "أستاذ مساعد - مستشفى عين شمس".
  @JsonKey(defaultValue: '')
  final String workplace;

  final String? profileImage;

  /// متوسط التقييم من 5.
  @JsonKey(defaultValue: 0.0)
  final double rating;

  @JsonKey(defaultValue: 0)
  final int likesCount;

  @JsonKey(defaultValue: 0)
  final int commentsCount;

  /// متاح لاستشارة أون لاين دلوقتى.
  @JsonKey(defaultValue: false)
  final bool isOnline;

  /// بيقبل حجوزات حاليًا.
  @JsonKey(defaultValue: false)
  final bool acceptsBookings;

  /// `null` لو مفيش موعد متاح.
  final NearestAppointmentModel? nearestAvailableAppointment;

  const DoctorSummaryModel({
    required this.id,
    required this.name,
    required this.specialty,
    required this.workplace,
    required this.rating,
    required this.likesCount,
    required this.commentsCount,
    required this.isOnline,
    required this.acceptsBookings,
    this.profileImage,
    this.nearestAvailableAppointment,
  });

  factory DoctorSummaryModel.fromJson(Map<String, dynamic> json) =>
      _$DoctorSummaryModelFromJson(json);
  Map<String, dynamic> toJson() => _$DoctorSummaryModelToJson(this);

  /// رابط الصورة للـ `CachedNetworkImage` — فاضى لو مفيش صورة عشان يعرض البديل.
  String get imageUrl => profileImage ?? '';
}
