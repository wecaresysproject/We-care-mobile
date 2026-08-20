import 'package:we_care/features/online_doctor/data/models/booking_model.dart';

/// كشف أو استشارة خلصت — عنصر واحد فى شاشة "السجل السابق"،
/// وبياناته الكاملة بتتعرض فى شاشة "تفاصيل الكشف/الاستشارة".
class BookingHistoryModel {
  const BookingHistoryModel({
    required this.type,
    required this.doctor,
    required this.appointmentDateTime,
    required this.doctorRating,
    required this.doctorCommentsCount,
    this.examinationFee,
    this.paymentMethodLabel,
    this.linkedExaminationDate,
    this.prescriptionIssuedDate,
    this.userRating,
    this.userRatingDate,
    this.userComment,
    this.userCommentDate,
  });

  final BookingType type;
  final BookingDoctorInfo doctor;
  final DateTime appointmentDateTime;

  /// متوسط تقييم الطبيب من 5 وعدد التعليقات عليه — بيتعرضوا فى فوتر الكارت.
  final double doctorRating;
  final int doctorCommentsCount;

  /// تكلفة الكشف وطريقة الدفع — للكشف الأون لاين بس.
  final int? examinationFee;
  final String? paymentMethodLabel;

  /// تاريخ الكشف اللى الاستشارة المجانية كانت مرتبطة بيه — للاستشارات بس.
  final DateTime? linkedExaminationDate;

  /// تاريخ إصدار الروشتة — `null` لو الموعد ملوش روشتة.
  final DateTime? prescriptionIssuedDate;

  /// تقييم المستخدم نفسه للموعد ده وتاريخه — `null` لو لسه مقيّمش.
  final double? userRating;
  final DateTime? userRatingDate;

  /// تعليق المستخدم على الطبيب وتاريخ نشره — `null` لو لسه معلّقش.
  final String? userComment;
  final DateTime? userCommentDate;

  //! حالة الموعد لسه ثابتة "مكتملة" — هتبقى من الـ API لما حالات تانية
  //! (زى الملغية) تتحدد.
  String get statusLabel => "مكتملة";

  /// "الأحد 16 أغسطس 2026".
  String get dateLabel => arabicDateLabel(appointmentDateTime);

  /// "06:00 مساءً".
  String get timeLabel => arabicTimeLabel(appointmentDateTime);

  /// "مرتبطة بكشف يوم 16 أغسطس 2026".
  String get linkedExaminationLabel {
    final linkedDate = linkedExaminationDate;
    if (linkedDate == null) return "";
    return "مرتبطة بكشف يوم ${arabicShortDateLabel(linkedDate)}";
  }

  /// عنوان شاشة التفاصيل — "تفاصيل الكشف" / "تفاصيل الاستشارة".
  String get detailsTitle => "تفاصيل ${type.shortName}";
}

/// الوصف اللفظى للتقييم — بيتعرض تحت النجوم فى شاشة التفاصيل.
String ratingDescription(double rating) {
  if (rating >= 4.5) return "ممتاز";
  if (rating >= 3.5) return "جيد جداً";
  if (rating >= 2.5) return "جيد";
  if (rating >= 1.5) return "مقبول";
  return "ضعيف";
}
