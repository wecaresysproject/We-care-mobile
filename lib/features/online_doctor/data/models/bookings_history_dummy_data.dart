import 'package:we_care/features/online_doctor/data/models/booking_history_model.dart';
import 'package:we_care/features/online_doctor/data/models/booking_model.dart';

//! بيانات وهمية مؤقتة لحد ما endpoint السجل السابق يجهز.
//! التواريخ ثابتة وحقيقية (اسم اليوم بيتحسب من التاريخ نفسه) ومرتبة
//! من الأحدث للأقدم زى ما السجل المفروض يرجع من السيرفر.

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

const BookingDoctorInfo _pediatricsDoctor = BookingDoctorInfo(
  name: "د/ سارة محمد عبد الله",
  specialization: "طب الأطفال وحديثى الولادة",
  academicTitle: "استشارى",
  hospital: "مستشفى 57357",
  location: "مصر - الإسكندرية",
  imageUrl: "https://randomuser.me/api/portraits/women/65.jpg",
  isOnline: true,
);

const BookingDoctorInfo _internalMedicineDoctor = BookingDoctorInfo(
  name: "د/ عمرو يحيى عبد المنعم",
  specialization: "الباطنة",
  academicTitle: "أخصائى",
  hospital: "مستشفى المعادى العسكرى",
  location: "مصر - القاهرة",
  imageUrl: "https://randomuser.me/api/portraits/men/22.jpg",
  isOnline: true,
);

final List<BookingHistoryModel> bookingsHistoryDummyData = [
  BookingHistoryModel(
    type: BookingType.onlineExamination,
    doctor: _entDoctor,
    appointmentDateTime: DateTime(2026, 8, 16, 18, 0),
    doctorRating: 4.8,
    doctorCommentsCount: 95,
    examinationFee: 500,
    paymentMethodLabel: "بطاقة ائتمان",
    prescriptionIssuedDate: DateTime(2026, 8, 16),
    userRating: 5.0,
    userRatingDate: DateTime(2026, 8, 16),
    userComment: "دكتور محترم جداً، استمع لشكوتي باهتمام وشرح الحالة بالتفصيل.",
    userCommentDate: DateTime(2026, 8, 16),
  ),
  // استشارة متابعة مجانية — من غير روشتة، والمستخدم لسه مقيّمهاش
  // عشان حالات "أضف تقييمك/تعليقك" فى شاشة التفاصيل تظهر.
  BookingHistoryModel(
    type: BookingType.freeFollowUpConsultation,
    doctor: _dermatologyDoctor,
    appointmentDateTime: DateTime(2026, 8, 13, 11, 30),
    doctorRating: 5.0,
    doctorCommentsCount: 48,
    linkedExaminationDate: DateTime(2026, 8, 8),
  ),
  BookingHistoryModel(
    type: BookingType.onlineExamination,
    doctor: _pediatricsDoctor,
    appointmentDateTime: DateTime(2026, 7, 19, 18, 0),
    doctorRating: 4.6,
    doctorCommentsCount: 62,
    examinationFee: 400,
    paymentMethodLabel: "مدى",
    prescriptionIssuedDate: DateTime(2026, 7, 19),
    userRating: 4.0,
    userRatingDate: DateTime(2026, 7, 20),
  ),
  BookingHistoryModel(
    type: BookingType.onlineExamination,
    doctor: _internalMedicineDoctor,
    appointmentDateTime: DateTime(2026, 6, 10, 19, 30),
    doctorRating: 4.4,
    doctorCommentsCount: 35,
    examinationFee: 450,
    paymentMethodLabel: "بطاقة ائتمان",
    prescriptionIssuedDate: DateTime(2026, 6, 10),
    userRating: 4.5,
    userRatingDate: DateTime(2026, 6, 11),
    userComment: "تشخيص دقيق ومتابعة ممتازة، أنصح بالتعامل معه.",
    userCommentDate: DateTime(2026, 6, 11),
  ),
];
