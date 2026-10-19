class OnlineDoctorApiConstants {
  static const baseUrl = "http://147.93.57.70/api";

  /// قايمة الأطباء حسب التخصص — `?specialty=`.
  static const getDoctorsBySpecialty = "/OnlineDoctor";

  /// ملف طبيب واحد — `?doctorId=`.
  static const getDoctorProfile = "/OnlineDoctor/profile";

  /// إضافة/إزالة طبيب من المفضلة — `POST` / `DELETE` بنفس المسار و`?doctorId=`.
  static const favoriteDoctor = "/OnlineDoctor/favorite";

  /// الأيام المتاحة للحجز وتوقيتاتها — `?doctorId=&fromDate=&days=`.
  static const getDoctorAvailability = "/PatientBooking/availability";

  /// حجز موعد كشف أون لاين — `POST` والبيانات فى الـ body.
  static const bookAppointment = "/PatientBooking/bookings";

  /// مواعيد المريض القادمة — من غير parameters.
  static const getUpcomingBookings = "/PatientBooking/bookings/upcoming";

  /// السجل السابق — `?doctorId=&specialty=` اختياريين للفلترة.
  static const getBookingsHistory = "/PatientBooking/bookings/history";

  /// قيم فلترين السجل السابق (الأطباء والتخصصات) — من غير parameters.
  static const getBookingsHistoryFilters =
      "/PatientBooking/bookings/history/filters";

  /// تفاصيل موعد واحد — `?bookingId=`.
  static const getBookingDetails = "/PatientBooking/bookings/details";

  /// إلغاء موعد كشف قادم — `POST` و`?bookingId=` من غير body.
  static const cancelBooking = "/PatientBooking/bookings/cancel";

  /// نقل موعد كشف قادم لميعاد تانى عند نفس الطبيب — `PUT` و`?bookingId=`،
  /// والميعاد الجديد فى الـ body.
  static const rescheduleBooking = "/PatientBooking/bookings/reschedule";

  /// إضافة أو تعديل تقييم المريض لموعد سابق — `PUT` و`?bookingId=`،
  /// والتقييم فى الـ body.
  static const saveBookingRating = "/PatientBooking/bookings/rating";

  /// إضافة أو تعديل تعليق المريض على الطبيب لموعد سابق — `PUT`
  /// و`?bookingId=`، ونص التعليق فى الـ body.
  static const saveBookingComment = "/PatientBooking/bookings/comment";

  /// بيانات غرفة الكشف/الاستشارة لموعد قادم (الطبيب والموعد والمشاركين
  /// وأسئلة المريض) — `?bookingId=`.
  static const getAppointmentRoom = "/PatientBooking/bookings/room";

  /// أسئلة المريض للطبيب فى موعد قادم — `POST` للإضافة، `PUT` للتعديل،
  /// `DELETE` للحذف بنفس المسار؛ `?bookingId=` دايمًا و`&questionId=` فى
  /// التعديل والحذف، ونص السؤال فى الـ body.
  static const bookingQuestions = "/PatientBooking/bookings/questions";

  /// اجتماع الفيديو المرتبط بالموعد — `?appointmentId=`. بيرجّعه لطرفى
  /// الحجز، و`404` لو الطبيب لسه منشأهوش.
  static const getVideoMeeting = "/Video";
}
