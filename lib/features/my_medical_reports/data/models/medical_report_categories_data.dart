import 'package:we_care/features/my_medical_reports/data/models/medical_category_model.dart';

final basicInfoCategory = MedicalCategoryModel(
  title: "البيانات الاساسية",
  image: "assets/images/pin_edit_icon.png",
  selectionType: MedicalSelectionType.selection,
  radioOptions: [
    "الجميع",
    "تاريخ الميلاد",
    "الاسم",
    "النوع",
    "الصورة",
    "فصيلة الدم",
    "الدولة",
    "المدينة",
    'نوع العجز الجسدي',
    "التأمين الطبي",
  ],
);

final vitalSignsCategory = MedicalCategoryModel(
  title: "القياسات الحيوية",
  image: "assets/images/medical_tools_img.png",
  selectionType: MedicalSelectionType.selection,
  radioOptions: [
    "الضغط",
    "درجة الحرارة",
    "الأكسجين",
    "السكر الصائم",
    'السكر عشوائي',
    "نبضات القلب",
    "الوزن",
    "BMI"
  ],
);

final medicinesCategory = MedicalCategoryModel(
  title: "الأدوية",
  image: "assets/images/medicines_icon.png",
  selectionType: MedicalSelectionType.filters,
  filterSections: [
    MedicalFilterSectionModel(
      filters: [
        MedicalFilterModel(
          title: "اسم الدواء",
          values: ["بنادول", "كونجستال", "أوجمنتين", "بروفين"],
        ),
        MedicalFilterModel(
          title: "السنة",
          values: [
            "2024",
            "2023",
            "2022",
            "2021",
            "2020",
            "2019",
            "2018",
            "2017",
            "2016",
            "2015",
            "2014",
            "2013",
            "2012",
            "2011",
            "2010",
            "2009",
            "2008",
            "2007",
            "2006",
            "2005",
            "2004",
            "2003",
            "2002",
            "2001",
            "2000"
          ],
        ),
      ],
    ),
    MedicalFilterSectionModel(
      title: "الادوية منتهية الصلاحية اخر 3 أشهر",
      filters: [
        MedicalFilterModel(
          title: "اسم الدواء_expired",
          displayTitle: "اسم الدواء",
          values: ["بنادول", "كونجستال", "أوجمنتين", "بروفين"],
        ),
        MedicalFilterModel(
          title: "السنة_expired",
          displayTitle: "السنة",
          values: [
            "2024",
            "2023",
            "2022",
            "2021",
            "2020",
            "2019",
            "2018",
            "2017",
            "2016",
            "2015",
            "2014",
            "2013",
            "2012",
            "2011",
            "2010",
            "2009",
            "2008",
            "2007",
            "2006",
            "2005",
            "2004",
            "2003",
            "2002",
            "2001",
            "2000"
          ],
        ),
      ],
    ),
  ],
);

final chronicDiseasesCategory = MedicalCategoryModel(
  title: "الامراض المزمنه",
  image: "assets/images/time_icon.png",
  selectionType: MedicalSelectionType.filters,
  filterSections: [
    MedicalFilterSectionModel(
      filters: [
        MedicalFilterModel(
          title: "المرض المزمن",
          values: ["ضغط", "سكر", "قلب"],
        ),
        MedicalFilterModel(
          title: "السنة",
          values: ["2024", "2023"],
        ),
      ],
    ),
  ],
);

final urgentComplaintsCategory = MedicalCategoryModel(
  title: "الشكاوى الطارئة",
  image: "assets/images/urgent_icon.png",
  selectionType: MedicalSelectionType.filters,
  filterSections: [
    MedicalFilterSectionModel(
      filters: [
        MedicalFilterModel(
          title: "السنة",
          values: ["2025", "2024", "2023"],
        ),
        MedicalFilterModel(
          title: "العضو",
          values: ["الرأس", "الصدر", "البطن", "الظهر"],
        ),
        MedicalFilterModel(
          title: "الشكوى",
          values: ["ألم شديد", "دوخة", "غثيان"],
        ),
      ],
    ),
  ],
);

final doctorsPrescriptionCategory = MedicalCategoryModel(
  title: "روشتة الأطباء",
  image: "assets/images/doctor_medicines.png",
  selectionType: MedicalSelectionType.selectionAndFilters,
  radioOptions: ["ارفاق صور الروشتات"],
  filterSections: [
    MedicalFilterSectionModel(
      filters: [
        MedicalFilterModel(
          title: "السنة",
          values: ["2024", "2023", "2022", "2021"],
        ),
        MedicalFilterModel(
          title: "التخصص",
          values: ["عيون", "أسنان", "عظام", "باطنة"],
        ),
        MedicalFilterModel(
          title: "اسم الطبيب",
          values: ["د. أحمد", "د. محمد", "د. سارة"],
        ),
      ],
    ),
  ],
);

final medicalTestsCategory = MedicalCategoryModel(
  title: "التحاليل الطبية",
  image: "assets/images/test_tube.png",
  selectionType: MedicalSelectionType.filters,
  radioOptions: ["ارفاق صور التحاليل"],
  filterSections: [
    MedicalFilterSectionModel(
      filters: [
        MedicalFilterModel(
          title: "السنة",
          values: ["2024", "2023"],
        ),
        MedicalFilterModel(
          title: "مجموعة التحاليل",
          values: ["دم", "هرمونات", "بول", "براز"],
        ),
      ],
    ),
  ],
);

final radiologyCategory = MedicalCategoryModel(
  title: "الأشعة",
  image: "assets/images/x_ray.png",
  selectionType: MedicalSelectionType.selectionAndFilters,
  radioOptions: ["ارفاق صور الاشعة"],
  filterSections: [
    MedicalFilterSectionModel(
      filters: [
        MedicalFilterModel(
          title: "السنة",
          values: ["2024", "2023"],
        ),
        MedicalFilterModel(
          title: "منطقة الأشعة",
          values: ["الصدر", "القدم", "الرأس"],
        ),
        MedicalFilterModel(
          title: "نوع الأشعة",
          values: ["سينية", "مقطعية", "رنين"],
        ),
      ],
    ),
  ],
);

final surgeriesCategory = MedicalCategoryModel(
  title: "العمليات الجراحية",
  image: "assets/images/surgery_icon.png",
  selectionType: MedicalSelectionType.selectionAndFilters,
  radioOptions: ["ارفاق التقرير الطبي"],
  filterSections: [
    MedicalFilterSectionModel(
      filters: [
        MedicalFilterModel(
          title: "اسم العملية",
          values: ["زايدة", "لوز", "فتق"],
        ),
      ],
    ),
  ],
);

final geneticDiseasesCategory = MedicalCategoryModel(
  title: "الأمراض الوراثية",
  image: "assets/images/icon_family.png",
  selectionType: MedicalSelectionType.selection,
  radioOptions: ["امراض العائلة الوراثية", "أمراضي الوراثية المتوقعة"],
);

final allergiesCategory = MedicalCategoryModel(
  title: "الحساسية",
  image: "assets/images/hand_icon.png",
  selectionType: MedicalSelectionType.filters,
  filterSections: [
    MedicalFilterSectionModel(
      filters: [
        MedicalFilterModel(
          title: "النوع",
          values: ["جلدية", "صدرية", "طعام"],
        ),
      ],
    ),
  ],
);

final eyesCategory = MedicalCategoryModel(
  title: "العيون",
  image: "assets/images/eye_module_pic.png",
  selectionType: MedicalSelectionType.selectionAndFilters,
  radioOptions: ["ارفاق التقرير الطبي"],
  filterSections: [
    MedicalFilterSectionModel(
      filters: [
        MedicalFilterModel(
          title: "السنة",
          values: ["2024", "2023"],
        ),
        MedicalFilterModel(
          title: "المنطقه",
          values: ["الشبكية", "القرنية"],
        ),
        MedicalFilterModel(
          title: "الأعراض",
          values: ["احمرار", "زغللة"],
        ),
        MedicalFilterModel(
          title: "الإجراء الطبي",
          values: ["كشف", "عملية"],
        ),
      ],
    ),
  ],
);

final dentalCategory = MedicalCategoryModel(
  title: "الأسنان",
  image: "assets/images/teeth_icon.png",
  selectionType: MedicalSelectionType.selectionAndFilters,
  radioOptions: ["ارفاق التقرير الطبي"],
  filterSections: [
    MedicalFilterSectionModel(
      filters: [
        MedicalFilterModel(
          title: "السنة",
          values: ["2024", "2023"],
        ),
        MedicalFilterModel(
          title: "لرقم السن",
          values: ["1", "2", "3", "4"],
        ),
        MedicalFilterModel(
          title: "الشكوى",
          values: ["ألم", "تسوس"],
        ),
        MedicalFilterModel(
          title: "الإجراء الطبي",
          values: ["حشو", "خلع"],
        ),
      ],
    ),
  ],
);

final mentalHealthCategory = MedicalCategoryModel(
  title: "الأمراض النفسية",
  image: "assets/images/mental_health.png",
  selectionType: MedicalSelectionType.filters,
  filterSections: [
    MedicalFilterSectionModel(
      filters: [
        MedicalFilterModel(
          title: "السنة",
          values: ["2024", "2023"],
        ),
        MedicalFilterModel(
          title: "نوع المرض النفسي",
          values: ["اكتئاب", "قلق"],
        ),
        MedicalFilterModel(
          title: " المحاور النفسية و السلوكية ",
          values: ["جلسات", "أدوية"],
        ),
      ],
    ),
  ],
);

final smartNutritionalAnalyzerCategory = MedicalCategoryModel(
  title: "المحلل الغذائي الذكي",
  image: "assets/images/chemical_medicine.png",
  selectionType: MedicalSelectionType.selection,
  radioOptions: ["تقرير المتابعة الغذائيه"],
);

final sportsActivityCategory = MedicalCategoryModel(
  title: "النشاط الرياضي",
  image: "assets/images/physical_exercise.png",
  selectionType: MedicalSelectionType.selection,
  radioOptions: ["تقرير المتابعة الرياضية"],
);

final supplementsCategory = MedicalCategoryModel(
  title: "المكملات الغذائية",
  image: "assets/images/vitamin_module_icon.png",
  selectionType: MedicalSelectionType.filters,
  filterSections: [
    MedicalFilterSectionModel(
      filters: [
        MedicalFilterModel(
          title: "اسم الفيتامين أو المكمل الغذائي",
          values: ["فيتامين د", "حديد", "زنك"],
        ),
      ],
    ),
  ],
);

final List<MedicalCategoryModel> categoriesView = [
  basicInfoCategory,
  vitalSignsCategory,
  medicinesCategory,
  chronicDiseasesCategory,
  urgentComplaintsCategory,
  doctorsPrescriptionCategory,
  medicalTestsCategory,
  radiologyCategory,
  surgeriesCategory,
  geneticDiseasesCategory,
  allergiesCategory,
  eyesCategory,
  dentalCategory,
  mentalHealthCategory,
  smartNutritionalAnalyzerCategory,
  sportsActivityCategory,
  supplementsCategory,
];
