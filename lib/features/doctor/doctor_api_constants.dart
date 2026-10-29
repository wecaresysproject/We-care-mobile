/// The doctor profile module paths (`basic-data` … `service-prices`) serve
/// both `POST` (save, replaces the saved data) and `GET` (read it back).
class DoctorApiConstants {
  static const baseUrl = "http://147.93.57.70/api";

  /// البيانات الأساسية للطبيب.
  static const postBasicData = "/DoctorUserForDoctor/basic-data";

  /// التراخيص المهنية — بتتبعت كلها مرة واحدة كـ `licenses[]`.
  static const postLicenses = "/DoctorUserForDoctor/licenses";

  /// الخبرات المهنية — بتتبعت كلها مرة واحدة كـ `experiences[]`.
  static const postExperiences = "/DoctorUserForDoctor/experiences";

  /// الشهادات العلمية — كل نوع شهادة (`bachelor`, `master`, ...) مصفوفة لوحده.
  static const postCertificates = "/DoctorUserForDoctor/certificates";

  /// العضوية فى الجمعيات الطبية — بتتبعت كلها مرة واحدة كـ `memberships[]`.
  static const postMemberships = "/DoctorUserForDoctor/memberships";

  /// الأبحاث والرسائل — بتتبعت كلها مرة واحدة كـ `researchPapers[]`.
  static const postResearchPapers = "/DoctorUserForDoctor/research-papers";

  /// الجوائز والتكريمات — بتتبعت كلها مرة واحدة كـ `awards[]`.
  static const postAwards = "/DoctorUserForDoctor/awards";

  /// الميديا والمقالات — بتتبعت كلها مرة واحدة كـ `mediaArticles[]`.
  static const postMediaArticles = "/DoctorUserForDoctor/media-articles";

  /// أسعار الخدمات (الكشف داخل/خارج مصر والاستشارة).
  static const postServicePrices = "/DoctorUserForDoctor/service-prices";

  /// المعلومات البنكية — بتتبعت كلها مرة واحدة كـ `bankAccounts[]`.
  static const postBankInfo = "/DoctorUserForDoctor/bank-info";

  /// إعدادات الحجز (الحد اليومى، الفاصل بين المواعيد، والجدول الأسبوعى).
  static const postBookingSettings = "/DoctorUserForDoctor/booking-settings";

  /// مستهدفات الكشف الشهرية — `GET` للسجل و`POST` بنفس المسار لحفظ الهدف.
  static const monthlyExaminationTargets =
      "/DoctorUserForDoctor/monthly-examination-targets";

  /// التخصص الطبى (الرئيسى والفرعى والاهتمامات).
  static const postMedicalSpecialty = "/DoctorUserForDoctor/medical-specialty";

  /// شاشة الحجوزات — بيانات الطبيب ومواعيد اليوم وقائمة الانتظار، من غير
  /// parameters.
  static const getDoctorBookings = "/DoctorBookings/bookings";

  /// قبول مريض من قائمة الانتظار — `POST` و`?bookingId=` من غير body.
  static const acceptWaitingPatient = "/DoctorBookings/waiting-list/accept";

  /// رفض مريض من قائمة الانتظار — `POST` و`?bookingId=` من غير body.
  static const rejectWaitingPatient = "/DoctorBookings/waiting-list/reject";

  /// إنشاء اجتماع الفيديو لموعد — `POST` و`appointmentId` فى الـ body،
  /// وبيرجّع الاجتماع الموجود لو اتعمل قبل كده.
  static const createVideoMeeting = "/Video/create";

  /// تسجيل بدء اجتماع الفيديو — `POST` و`?appointmentId=` من غير body.
  static const startVideoMeeting = "/Video/start";

  /// تسجيل انتهاء اجتماع الفيديو — `POST` و`?appointmentId=` من غير body.
  static const endVideoMeeting = "/Video/end";

  /// صلاحيات الطبيب على الملف الطبى لمريض الحجز (الموديولات المسموحة
  /// وميعاد انتهاء الوصول) — `?bookingId=`.
  static const getBookingPatientAccess =
      "/DoctorBookings/bookings/patient-access";
}
