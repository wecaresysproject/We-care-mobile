import 'package:we_care/core/models/medical_module_enum.dart';
import 'package:we_care/features/online_doctor/data/models/appointment_slot_model.dart';
import 'package:we_care/features/online_doctor/data/models/data_access_module_option.dart';

//! بيانات وهمية مؤقتة لحد ما endpoints الحجز والدفع تجهز.

/// الأيام المتاحة للحجز مرتبة من الأقرب للأبعد — أول يوم بيظهر على اليمين،
/// وتوقيتات اليوم المختار بتظهر تحت صف الأيام.
const List<AppointmentDayModel> availableAppointmentDays = [
  AppointmentDayModel(
    dayLabel: "اليوم",
    slots: [
      AppointmentTimeSlot(fromTime: "12:30م", toTime: "1م"),
      AppointmentTimeSlot(fromTime: "2م", toTime: "2:30م"),
      AppointmentTimeSlot(fromTime: "6م", toTime: "6:30م"),
    ],
  ),
  AppointmentDayModel(
    dayLabel: "الثلاثاء",
    dateLabel: "١٠ / ٧",
    slots: [
      AppointmentTimeSlot(fromTime: "1:30م", toTime: "2م"),
      AppointmentTimeSlot(fromTime: "3م", toTime: "3:30م"),
      AppointmentTimeSlot(fromTime: "5:30م", toTime: "6م"),
      AppointmentTimeSlot(fromTime: "8م", toTime: "8:30م"),
    ],
  ),
  AppointmentDayModel(
    dayLabel: "الخميس",
    dateLabel: "١٣ / ٧",
    slots: [
      AppointmentTimeSlot(fromTime: "12:30م", toTime: "1م"),
      AppointmentTimeSlot(fromTime: "4م", toTime: "4:30م"),
    ],
  ),
  AppointmentDayModel(
    dayLabel: "السبت",
    dateLabel: "١٥ / ٧",
    slots: [
      AppointmentTimeSlot(fromTime: "11ص", toTime: "11:30ص"),
      AppointmentTimeSlot(fromTime: "1م", toTime: "1:30م"),
      AppointmentTimeSlot(fromTime: "7م", toTime: "7:30م"),
    ],
  ),
  AppointmentDayModel(
    dayLabel: "الإثنين",
    dateLabel: "١٧ / ٧",
    slots: [
      AppointmentTimeSlot(fromTime: "2م", toTime: "2:30م"),
      AppointmentTimeSlot(fromTime: "5م", toTime: "5:30م"),
    ],
  ),
];

/// المدة اللى الطبيب هيقدر يشوف فيها بيانات المريض بعد الكشف —
/// أول عنصر بيظهر على اليمين، والصف بيتسحب أفقيًا لباقى المدد.
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
