import 'package:we_care/core/models/medical_module_enum.dart';
import 'package:we_care/features/online_doctor/data/models/appointment_slot_model.dart';
import 'package:we_care/features/online_doctor/data/models/booking_model.dart';
import 'package:we_care/features/online_doctor/data/models/data_access_module_option.dart';

//! بيانات وهمية مؤقتة لحد ما endpoints الحجز والدفع تجهز.

/// توقيتات كل يوم متاح — عدد الأيام بعد النهارده، وبدايات المواعيد
/// (ساعة، دقيقة). كل ميعاد مدته [BookingModel.slotDuration].
const List<(int, List<(int, int)>)> _availableSlotsByDayOffset = [
  (0, [(12, 30), (14, 0), (18, 0)]),
  (2, [(13, 30), (15, 0), (17, 30), (20, 0)]),
  (4, [(12, 30), (16, 0)]),
  (6, [(11, 0), (13, 0), (19, 0)]),
  (8, [(14, 0), (17, 0)]),
];

/// الأيام المتاحة للحجز مرتبة من الأقرب للأبعد — أول يوم بيظهر على اليمين،
/// وتوقيتات اليوم المختار بتظهر تحت صف الأيام.
///
/// بتتبنى نسبةً للنهارده وبنفس شكل endpoint المواعيد المتاحة: المواعيد
/// اللى وقتها فات مش بترجع، واليوم اللى مفيهوش مواعيد مش بيظهر.
List<AppointmentDayModel> buildAvailableAppointmentDaysDummyData() {
  final now = DateTime.now();
  final days = <AppointmentDayModel>[];

  for (final (dayOffset, slotStarts) in _availableSlotsByDayOffset) {
    final date = DateTime(now.year, now.month, now.day + dayOffset);
    final slots = <AppointmentTimeSlot>[];

    for (final (hour, minute) in slotStarts) {
      final startsAt = DateTime(date.year, date.month, date.day, hour, minute);
      if (!startsAt.isAfter(now)) continue;
      slots.add(
        AppointmentTimeSlot(
          startsAt: startsAt,
          endsAt: startsAt.add(BookingModel.slotDuration),
        ),
      );
    }

    if (slots.isNotEmpty) {
      days.add(AppointmentDayModel(date: date, slots: slots));
    }
  }

  return days;
}

/// المدة اللى الطبيب هيقدر يشوف فيها بيانات المريض بعد الكشف —
/// أول عنصر بيظهر على اليمين، والصف بيتسحب أفقيًا لباقى المدد.
///
/// نفس ترتيب [dataAccessDurationsInHours].
const List<String> dataAccessDurations = [
  "12 ساعة",
  "يوم",
  "يومين",
  "3 أيام",
  "4 أيام",
  "5 أيام",
  "6 أيام",
  "أسبوع",
  "10 أيام",
  "أسبوعين",
];

/// قيمة كل مدة فى [dataAccessDurations] بالساعات — دى اللى بتتبعت للـ API.
const List<int> dataAccessDurationsInHours = [
  12,
  24,
  48,
  72,
  96,
  120,
  144,
  168,
  240,
  336,
];

/// الموديولات اللى المريض بيختار منها اللى يسمح للطبيب يشوفه (صلاحيات الطبيب).
///
/// الترتيب مقصود ومتفق عليه — متغيّرش ترتيب العناصر:
/// الموديولات المفعّلة الأول، وبعدها اللى لسه غير مفعّلة (`isEnabled: false`)
/// بتظهر باهتة ومش بتتضغط لحد ما تتفعّل.
const List<DataAccessModuleOption> dataAccessModules = [
  DataAccessModuleOption(
    module: MedicalModule.vitalSigns,
    label: "القياسات الحيوية",
    // القياسات الحيوية مش من كروت "ملفاتى الطبية" — بنستخدم أيقونة
    // موديول Biometrics نفسه.
    iconOverride: "assets/images/blood-pressure.png",
  ),
  DataAccessModuleOption(module: MedicalModule.medications, label: "الأدوية"),
  DataAccessModuleOption(
    module: MedicalModule.urgentComplaints,
    label: "الشكاوى الطارئة",
  ),
  DataAccessModuleOption(
    module: MedicalModule.doctorsPrescriptions,
    label: "روشتة الأطباء",
  ),
  DataAccessModuleOption(
    module: MedicalModule.medicalTests,
    label: "التحاليل الطبية",
  ),
  DataAccessModuleOption(module: MedicalModule.radiology, label: "الأشعة"),
  DataAccessModuleOption(module: MedicalModule.surgeries, label: "العمليات"),
  DataAccessModuleOption(
    module: MedicalModule.chronicDiseases,
    label: "الأمراض المزمنة",
  ),
  DataAccessModuleOption(
    module: MedicalModule.geneticDiseases,
    label: "الأمراض الوراثية",
  ),
  DataAccessModuleOption(module: MedicalModule.allergies, label: "الحساسية"),
  DataAccessModuleOption(module: MedicalModule.eyes, label: "العيون"),
  DataAccessModuleOption(module: MedicalModule.dental, label: "الأسنان"),
  DataAccessModuleOption(
    module: MedicalModule.vaccinations,
    label: "التطعيمات",
  ),
  DataAccessModuleOption(
    module: MedicalModule.mentalHealth,
    label: "الأمراض النفسية",
  ),
  DataAccessModuleOption(
    module: MedicalModule.riskyBehaviors,
    label: "السلوكيات الخطرة",
  ),
  DataAccessModuleOption(
    module: MedicalModule.smartNutritionalAnalyzer,
    label: "المتابعة الغذائية",
  ),
  DataAccessModuleOption(
    module: MedicalModule.sportsActivity,
    label: "النشاط الرياضي",
  ),
  DataAccessModuleOption(
    module: MedicalModule.supplements,
    label: "المكملات الغذائية",
  ),
  //* من هنا لآخر القايمة: موديولات معروضة بس لسه غير مفعّلة فى فلو الحجز.
  DataAccessModuleOption(
    module: MedicalModule.medicalEndoscopes,
    label: "المناظير الطبية",
    isEnabled: false,
  ),
  DataAccessModuleOption(
    module: MedicalModule.tumors,
    label: "الأورام",
    isEnabled: false,
  ),
  DataAccessModuleOption(
    module: MedicalModule.kidneyDialysis,
    label: "الغسيل الكلوى",
    isEnabled: false,
  ),
  DataAccessModuleOption(
    module: MedicalModule.physicalTherapy,
    label: "العلاج الطبيعى",
    isEnabled: false,
  ),
  DataAccessModuleOption(
    module: MedicalModule.pregnancyFollowUp,
    label: "متابعة الحمل",
    isEnabled: false,
  ),
  DataAccessModuleOption(
    module: MedicalModule.reproductiveProblems,
    label: "علاج مشاكل الانجاب",
    isEnabled: false,
  ),
  DataAccessModuleOption(
    module: MedicalModule.burns,
    label: "الحروق",
    isEnabled: false,
  ),
  DataAccessModuleOption(
    module: MedicalModule.cosmeticSurgeries,
    label: "الجراحات التجميلية",
    isEnabled: false,
  ),
];
