import 'package:we_care/features/online_doctor/data/models/booking_model.dart';
import 'package:we_care/features/online_doctor/data/models/booking_payment_method.dart';

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
    this.prescriptionFileUrl,
    this.userRating,
    this.userRatingDate,
    this.userComment,
    this.userCommentDate,
    this.bookingId = '',
  });

  /// عنصر من endpoint السجل السابق أو رد endpoint التفاصيل — نفس الشكل،
  /// والروشتة والتقييم والتعليق بييجوا من التفاصيل بس.
  factory BookingHistoryModel.fromJson(Map<String, dynamic> json) {
    final type = BookingType.fromApi(json['type'] as String?);
    final doctorJson = json['doctor'] as Map<String, dynamic>? ?? const {};
    final linkedDate = json['linkedExaminationDate'] as String?;
    final paymentMethod = BookingPaymentMethod.values
        .where((method) => method.name == json['paymentMethod'])
        .firstOrNull;
    final prescription = json['prescription'] as Map<String, dynamic>?;
    final userRating = json['userRating'] as Map<String, dynamic>?;
    final userComment = json['userComment'] as Map<String, dynamic>?;
    return BookingHistoryModel(
      bookingId: json['bookingId']?.toString() ?? '',
      type: type,
      doctor: BookingDoctorInfo.fromJson(doctorJson),
      appointmentDateTime: parseBookingInstant(json['startsAt'] as String),
      doctorRating: (doctorJson['rating'] as num?)?.toDouble() ?? 0,
      doctorCommentsCount: (doctorJson['commentsCount'] as num?)?.toInt() ?? 0,
      examinationFee:
          type.isExamination ? (json['fee'] as num?)?.toInt() : null,
      paymentMethodLabel: type.isExamination ? paymentMethod?.label : null,
      linkedExaminationDate: type.isExamination || linkedDate == null
          ? null
          : DateTime.tryParse(linkedDate),
      prescriptionIssuedDate: _tryParseDate(prescription?['issuedDate']),
      prescriptionFileUrl: prescription?['fileUrl'] as String?,
      userRating: (userRating?['value'] as num?)?.toDouble(),
      userRatingDate: _tryParseDate(userRating?['date']),
      userComment: userComment?['text'] as String?,
      userCommentDate: _tryParseDate(userComment?['date']),
    );
  }

  static DateTime? _tryParseDate(Object? value) =>
      value is String ? DateTime.tryParse(value) : null;

  /// بيتستخدم فى endpoint التفاصيل والتقييم والتعليق.
  final String bookingId;
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

  /// ملف الروشتة — `null` بيخفى زرار "عرض / تحميل الروشتة".
  final String? prescriptionFileUrl;

  /// تقييم المستخدم نفسه للموعد ده وتاريخه — `null` لو لسه مقيّمش.
  final double? userRating;
  final DateTime? userRatingDate;

  /// تعليق المستخدم على الطبيب وتاريخ نشره — `null` لو لسه معلّقش.
  final String? userComment;
  final DateTime? userCommentDate;

  /// نسخة من الموعد بتقييم و/أو تعليق جديد — بعد "تعديل التقييم/التعليق".
  BookingHistoryModel copyWith({
    double? userRating,
    DateTime? userRatingDate,
    String? userComment,
    DateTime? userCommentDate,
  }) =>
      BookingHistoryModel(
        bookingId: bookingId,
        type: type,
        doctor: doctor,
        appointmentDateTime: appointmentDateTime,
        doctorRating: doctorRating,
        doctorCommentsCount: doctorCommentsCount,
        examinationFee: examinationFee,
        paymentMethodLabel: paymentMethodLabel,
        linkedExaminationDate: linkedExaminationDate,
        prescriptionIssuedDate: prescriptionIssuedDate,
        prescriptionFileUrl: prescriptionFileUrl,
        userRating: userRating ?? this.userRating,
        userRatingDate: userRatingDate ?? this.userRatingDate,
        userComment: userComment ?? this.userComment,
        userCommentDate: userCommentDate ?? this.userCommentDate,
      );

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
