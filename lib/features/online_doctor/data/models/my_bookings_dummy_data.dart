import 'package:we_care/features/online_doctor/data/models/booking_model.dart';

//! بيانات وهمية مؤقتة لحد ما endpoint "حجوزاتى" يجهز.
//! المواعيد بتتبنى نسبةً لوقت فتح الشاشة عشان الأقسام الأربعة اللى فى التصميم
//! تظهر دايمًا: كشف واستشارة مستنيين، وكشف واستشارة حان وقتهم.

const BookingDoctorInfo _entDoctor = BookingDoctorInfo(
  name: "د/ أحمد محمود مصطفى",
  specialization: "أنف وأذن وحنجرة",
  academicTitle: "أستاذ مساعد",
  hospital: "مستشفى عين شمس التخصصى",
  location: "مصر - القاهرة",
  imageUrl: "https://randomuser.me/api/portraits/men/32.jpg",
  isOnline: true,
);

const BookingDoctorInfo _dermatologyDoctor = BookingDoctorInfo(
  name: "د/ محمد أنور السيد",
  specialization: "طب الجلدية والتجميل",
  academicTitle: "مدرس",
  hospital: "مستشفى دار الفؤاد",
  location: "مصر - الجيزة",
  imageUrl: "https://randomuser.me/api/portraits/men/75.jpg",
  isOnline: true,
);

/// بترجّع حجوزات وهمية مبنية على اللحظة الحالية —
/// بتتبنى مرة واحدة عند فتح الشاشة والعد التنازلى بيتحسب منها لايف.
List<BookingModel> buildMyBookingsDummyData() {
  final now = DateTime.now();

  // كشف مستنى — العد التنازلى بيبدأ بنفس قيمة التصميم: 12 ساعة و 25 دقيقة.
  final upcomingExamination = BookingModel(
    type: BookingType.onlineExamination,
    doctor: _entDoctor,
    appointmentDateTime: now.add(const Duration(hours: 12, minutes: 25)),
    examinationFee: 500,
  );

  // استشارة متابعة مجانية بعد 5 أيام الساعة 11:30 صباحاً —
  // مرتبطة بالكشف اللى حان وقته النهارده.
  final upcomingConsultation = BookingModel(
    type: BookingType.freeFollowUpConsultation,
    doctor: _dermatologyDoctor,
    appointmentDateTime: DateTime(now.year, now.month, now.day, 11, 30)
        .add(const Duration(days: 5)),
    linkedExaminationDate: now,
  );

  // كشف واستشارة حان وقتهم — بدأوا من دقايق قليلة فيفضلوا فى قسم
  // "حان وقت الموعد" طول مدة الـ slot قبل ما ينتقلوا للسجل السابق.
  final timeNowExamination = BookingModel(
    type: BookingType.onlineExamination,
    doctor: _entDoctor,
    appointmentDateTime: now.subtract(const Duration(minutes: 2)),
    examinationFee: 500,
  );

  final timeNowConsultation = BookingModel(
    type: BookingType.freeFollowUpConsultation,
    doctor: _dermatologyDoctor,
    appointmentDateTime: now.subtract(const Duration(minutes: 1)),
    linkedExaminationDate: now.subtract(const Duration(days: 5)),
  );

  return [
    upcomingExamination,
    upcomingConsultation,
    timeNowExamination,
    timeNowConsultation,
  ];
}
