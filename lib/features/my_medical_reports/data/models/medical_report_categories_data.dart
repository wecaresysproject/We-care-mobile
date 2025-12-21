final List<Map<String, dynamic>> categoriesView = [
  {
    "title": "البيانات الاساسية",
    "image": "assets/images/pin_edit_icon.png",
    "selectionType": "selection",
    "radioOptions": [
      "الاسم",
      "تاريخ الميلاد",
      "النوع",
      "صورة الفرد",
      "الجنسية",
      "الحالة الاجتماعية",
      "فصيلة الدم",
      "العنوان الطبي"
    ],
  },
  {
    "title": "القياسات الحيوية",
    "image": "assets/images/medical_tools_img.png",
    "selectionType": "selection",
    "radioOptions": [
      "ضغط الدم",
      "درجة الحرارة",
      "الأكسجين",
      "السكر الصائم",
      "نبضات القلب",
      "الوزن",
      "BMI"
    ],
  },
  {
    "title": "الأدوية",
    "image": "assets/images/medicines_icon.png",
    "selectionType": "filters",
    "filters": [
      {
        "title": "اسم الدواء",
        "values": ["بنادول", "كونجستال", "أوجمنتين", "بروفين"]
      },
      {
        "title": "السنة",
        "values": ["2024", "2023", "2022", "2021", "2020", "2019", "2018", "2017", "2016", "2015", "2014", "2013", "2012", "2011", "2010", "2009", "2008", "2007", "2006", "2005", "2004", "2003", "2002", "2001", "2000"]
      }
    ],
  },
  {
    "title": "الشكاوى الطارئة",
    "image": "assets/images/urgent_icon.png",
    "selectionType": "filters",
    "filters": [
      {
        "title": "السنة",
        "values": ["2025", "2024", "2023"]
      },
      {
        "title": "العضو",
        "values": ["الرأس", "الصدر", "البطن", "الظهر"]
      },
      {
        "title": "الشكوى",
        "values": ["ألم شديد", "دوخة", "غثيان"]
      }
    ],
  },
  {
    "title": "روشتة الأطباء",
    "image": "assets/images/doctor_medicines.png",
    "selectionType": "selection_and_filters",
    "radioOptions": ["ارفاق صور الروشتات"],
    "filters": [
      {
        "title": "السنة",
        "values": ["2024", "2023", "2022", "2021"]
      },
      {
        "title": "التخصص",
        "values": ["عيون", "أسنان", "عظام", "باطنة"]
      },
      {
        "title": "اسم الطبيب",
        "values": ["د. أحمد", "د. محمد", "د. سارة"]
      }
    ],
  },
  {
    "title": "التحاليل الطبية",
    "image": "assets/images/test_tube.png",
    "selectionType": "selection_and_filters",
    "radioOptions": ["ارفاق صور التحاليل"],
    "filters": [
      {
        "title": "السنة",
        "values": ["2024", "2023"]
      },
      {
        "title": "مجموعة التحاليل",
        "values": ["دم", "هرمونات", "بول", "براز"]
      }
    ],
  },
  {
    "title": "الأشعة",
    "image": "assets/images/x_ray.png",
    "selectionType": "selection_and_filters",
    "radioOptions": ["ارفاق صور الاشعة"],
    "filters": [
      {
        "title": "السنة",
        "values": ["2024", "2023"]
      },
      {
        "title": "منطقة الأشعة",
        "values": ["الصدر", "القدم", "الرأس"]
      },
      {
        "title": "نوع الأشعة",
        "values": ["سينية", "مقطعية", "رنين"]
      }
    ],
  },
  {
    "title": "العمليات الجراحية",
    "image": "assets/images/surgery_icon.png",
    "selectionType": "selection_and_filters",
    "radioOptions": ["ارفاق التقرير الطبي"],
    "filters": [
      {
        "title": "اسم العملية",
        "values": ["زايدة", "لوز", "فتق"]
      }
    ],
  },
  {
    "title": "المناظير الطبيه",
    "image": "assets/images/machine_icon.png",
  },
  {
    "title": "الامراض المزمنه",
    "image": "assets/images/time_icon.png",
    "selectionType": "filters",
    "filters": [
      {
        "title": "المرض المزمن",
        "values": ["ضغط", "سكر", "قلب"]
      },
      {
        "title": "السنة",
        "values": ["2024", "2023"]
      }
    ],
  },
  {
    "title": "الأورام",
    "image": "assets/images/tumor_icon.png",
  },
  {
    "title": "الأمراض الوراثية",
    "image": "assets/images/icon_family.png",
    "selectionType": "selection",
    "radioOptions": [
      "امراض العائلة الوراثية",
      "أمراضي الوراثية المتوقعة"
    ],
  },
  {
    "title": "الغسيل الكلوى",
    "image": "assets/images/kidney_wash.png",
  },
  {
    "title": "الحساسية",
    "image": "assets/images/hand_icon.png",
    "selectionType": "filters",
    "filters": [
      {
        "title": "النوع",
        "values": ["جلدية", "صدرية", "طعام"]
      }
    ],
  },
  {
    "title": "العيون",
    "image": "assets/images/eye_module_pic.png",
    "selectionType": "selection_and_filters",
    "radioOptions": ["ارفاق التقرير الطبي"],
    "filters": [
      {
        "title": "السنة",
        "values": ["2024", "2023"]
      },
      {
        "title": "المنطقه",
        "values": ["الشبكية", "القرنية"]
      },
      {
        "title": "الأعراض",
        "values": ["احمرار", "زغللة"]
      },
      {
        "title": "الإجراء الطبي",
        "values": ["كشف", "عملية"]
      }
    ],
  },
  {
    "title": "الأسنان",
    "image": "assets/images/teeth_icon.png",
    "selectionType": "selection_and_filters",
    "radioOptions": ["ارفاق التقرير الطبي"],
    "filters": [
      {
        "title": "السنة",
        "values": ["2024", "2023"]
      },
      {
        "title": "لرقم السن",
        "values": ["1", "2", "3", "4"]
      },
      {
        "title": "الشكوى",
        "values": ["ألم", "تسوس"]
      },
      {
        "title": "الإجراء الطبي",
        "values": ["حشو", "خلع"]
      }
    ],
  },
  {
    "title": "العلاج الطبيعي",
    "image": "assets/images/physical_therapy.png",
  },
  {
    "title": "التطعيمات",
    "image": "assets/images/eye_dropper.png",
  },
  {
    "title": "متابعة الحمل",
    "image": "assets/images/pergenant_woman.png",
  },
  {
    "title": "علاج مشاكل الانجاب",
    "image": "assets/images/baby_icon.png",
  },
  {
    "title": "الحروق",
    "image": "assets/images/fire_icon.png",
  },
  {
    "title": "الجراحات التجميلية",
    "image": "assets/images/woman.png",
  },
  {
    "title": "الأمراض النفسية",
    "image": "assets/images/mental_health.png",
    "selectionType": "filters",
    "filters": [
      {
        "title": "السنة",
        "values": ["2024", "2023"]
      },
      {
        "title": "نوع المرض النفسي",
        "values": ["اكتئاب", "قلق"]
      },
      {
        "title": "العلاج النفسي والسلوكي",
        "values": ["جلسات", "أدوية"]
      }
    ],
  },
  {
    "title": "السلوكيات الخطرة",
    "image": "assets/images/red_icon.png",
  },
  {
    "title": "الصحه العامه",
    "image": "assets/images/heart_icon.png",
  },
  {
    "title": "العادات الغذائية",
    "image": "assets/images/spoon_icon.png",
  },
  {
    "title": "المتابعه الغذائية",
    "image": "assets/images/chemical_medicine.png",
    "selectionType": "selection",
    "radioOptions": ["تقرير المتابعة الغذائيه"],
  },
  {
    "title": "النشاط الرياضي",
    "image": "assets/images/physical_exercise.png",
    "selectionType": "selection",
    "radioOptions": ["تقرير المتابعة الرياضية"],
  },
  {
    "title": "الفيتامينات والمكملات الغذائية",
    "image": "assets/images/vitamin_module_icon.png",
    "selectionType": "filters",
    "filters": [
      {
        "title": "اسم الفيتامين أو المكمل الغذائي",
        "values": ["فيتامين د", "حديد", "زنك"]
      }
    ],
  },
];
