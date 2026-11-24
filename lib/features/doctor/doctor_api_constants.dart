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

  /// الرئيسية — كل سكشن له endpoint مستقل، من غير parameters.
  static const getHomeProfileSummary = "/DoctorHome/profile-summary";
  static const getHomeBookingsStats = "/DoctorHome/bookings-stats";
  static const getHomeMonthlyExaminations = "/DoctorHome/monthly-examinations";
  static const getHomePerformanceStats = "/DoctorHome/performance-stats";

  /// إعلانات الرئيسية — `?userType=Doctor&language=ar`، وبيرجّع `data` كـ
  /// list من روابط الصور.
  static const getHomeAds = "/Ad/doctor/all";
  static const getHomeLatestComments = "/DoctorHome/latest-comments";
  static const getHomeRatingsSummary = "/DoctorHome/ratings-summary";

  /// "إحصائيات" لشهر — `?month=&year=`.
  static const getStatistics = "/DoctorHome/statistics";

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

  /// روشتة الحجز — `GET` لقراءتها و`PUT` بنفس المسار لحفظها أو تعديلها،
  /// و`?bookingId=` فى الاتنين.
  static const bookingPrescription = "/DoctorBookings/bookings/prescription";

  /// "الروشتات القديمة": الروشتات اللى الطبيب كتبها لمريض الحجز فى حجوزات
  /// سابقة — `?bookingId=`.
  static const previousPrescriptions =
      "/DoctorBookings/bookings/previous-prescriptions";

  /// "ملفات المرضى" — الحجوزات اللى صلاحية بيانات مريضها لسه مفتوحة.
  static const openPatientFiles = "/DoctorBookings/patient-files/open";

  /// "ملفات المرضى القدامى" — كل مريض الطبيب كشف عليه قبل كده.
  static const previousPatients = "/DoctorBookings/patient-files/previous";

  /// روشتات الطبيب لمريض قديم — `?patientId=`.
  static const patientPrescriptions =
      "/DoctorBookings/patient-files/prescriptions";
}
