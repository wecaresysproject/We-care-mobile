import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/di/dependency_injection.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/core/models/medical_module_enum.dart';
import 'package:we_care/core/networking/models/care_context_manager_model.dart';
import 'package:we_care/core/routing/routes.dart';
import 'package:we_care/features/show_data_entry_types/Data/Models/all_categories_tickets_count.dart';
import 'package:we_care/features/show_data_entry_types/Data/Repository/categories_repo.dart';

class MedicalCategoriesTypesGridView extends StatefulWidget {
  const MedicalCategoriesTypesGridView({
    super.key,
  });

  @override
  State<MedicalCategoriesTypesGridView> createState() =>
      _MedicalCategoriesTypesGridViewState();
}

class _MedicalCategoriesTypesGridViewState
    extends State<MedicalCategoriesTypesGridView> with WidgetsBindingObserver {
  // Future to hold the latest data
  late Future<CategoriesTicketsCount> _ticketsFuture;

  @override
  void initState() {
    super.initState();
    // Register as an observer to detect when app comes to foreground
    WidgetsBinding.instance.addObserver(this);
    // Initialize the future
    _refreshData();
  }

  @override
  void dispose() {
    // Clean up observer when widget is removed
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Refresh data when app comes back to foreground
    if (state == AppLifecycleState.resumed) {
      _refreshData();
    }
  }

  // Method to refresh the data
  void _refreshData() {
    setState(() {
      _ticketsFuture = getIt
          .get<CategoriesRepository>()
          .getAllCategoriesTicketsCount("ar", 'Patient');
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _ticketsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Expanded(
              child: const Center(child: CircularProgressIndicator()));
        }
        final sortedCategories = [...categoriesView]..sort((a, b) =>
            (b['isProductionModule'] ? 1 : 0)
                .compareTo(a['isProductionModule'] ? 1 : 0));
        return Expanded(
          child: GridView.builder(
            itemCount: sortedCategories.length,
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(vertical: 32.h),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisExtent:
                  148.h, //! Fixed height for each item until text overflows
              childAspectRatio: .85,
              crossAxisSpacing: 13.w,
              mainAxisSpacing: 32.h,
            ),
            itemBuilder: (context, index) {
              final counts = snapshot.data!;
              final categoryName = sortedCategories[index]["title"]!;
              final count = getCategoryCountByArabicTitle(counts, categoryName);

              final isProductionModule =
                  sortedCategories[index]["isProductionModule"] == true;
              final moduleNameIdentifier = sortedCategories[index]
                  ["moduleNameIdentifier"] as MedicalModule?;

              bool hasAccess = true;
              if (isProductionModule) {
                hasAccess = CareContextManager
                    .hasModuleAccessForViewMedicalFilesCategory(
                        moduleNameIdentifier);
              }

              return MedicalCategoryItem(
                title: categoryName,
                imagePath: sortedCategories[index]["image"]!,
                routeName: sortedCategories[index]["route"]!,
                notificationCount: count,
                isProductionModule: isProductionModule,
                hasAccess: hasAccess,
                onTap: (isProductionModule && hasAccess)
                    ? () async {
                        await context
                            .pushNamed(sortedCategories[index]["route"]!);
                        // Refresh data when returning from navigated screen
                        _refreshData();
                      }
                    : null,
              );
            },
          ),
        );
      },
    );
  }
}

class MedicalCategoryItem extends StatelessWidget {
  final String title;
  final String imagePath;
  final String routeName;
  final int? notificationCount;
  final bool isProductionModule;
  final bool hasAccess;
  final VoidCallback? onTap;

  const MedicalCategoryItem({
    super.key,
    required this.title,
    required this.imagePath,
    required this.routeName,
    this.notificationCount,
    this.isProductionModule = false,
    this.hasAccess = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: onTap,
          child: Stack(
            clipBehavior: Clip.none, // Allows badge to overflow
            children: [
              // Main Category Container
              Container(
                width: 99.w - 99.w * 0.09,
                height: 88.h - 88.h * 0.09,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40.r),
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFFCDE1F8),
                      Color(0xFFE7E9EB),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(75),
                      offset: const Offset(3, 4),
                      blurRadius: 4,
                    ),
                  ],
                ),
                padding: EdgeInsets.symmetric(vertical: 18.h, horizontal: 24.w),
                child: Center(
                  child: Image.asset(
                    imagePath,
                    fit: BoxFit.contain,
                    height: 51.h,
                    width: 52.w,
                  ),
                ),
              ),

              // Notification Badge (Only shows if notificationCount > 0)
              if (isProductionModule &&
                  notificationCount != null &&
                  notificationCount! > 0)
                Positioned(
                  top: 60.h - 12.h,
                  right: -4.5.w,
                  child: Container(
                    transformAlignment: Alignment.center,
                    padding: EdgeInsets.symmetric(
                      horizontal: 3.w,
                      vertical: 0.h,
                    ),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColorsManager.mainDarkBlue,
                      borderRadius: BorderRadius.circular(14.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black
                              .withOpacity(0.31), // Shadow color (31% opacity)
                          offset: Offset(3, 4), // X: 3, Y: 4
                          blurRadius: 4, // Blur 4
                          spreadRadius: 0, // No spread
                        ),
                      ],
                      border: Border.all(
                        color: AppColorsManager.backGroundColor,
                        width: 2.w,
                      ),
                    ),
                    child: Text(
                      '$notificationCount',
                      style: AppTextStyles.font20blackWeight600.copyWith(
                        color: Colors.white,
                        fontSize: 22.sp,
                      ),
                    ),
                  ),
                ),
              // Dim Overlay if not active
              if (!isProductionModule)
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.35),
                      borderRadius: BorderRadius.circular(40.r),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.hourglass_empty,
                        color: Colors.white,
                        size: 32.sp,
                      ),
                    ),
                  ),
                ),
              // Dim Overlay if no access
              if (!hasAccess)
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(40.r),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.lock_outline,
                        color: Colors.white,
                        size: 32.sp,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),

        verticalSpacing(8.h),

        // Category Title
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            title,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.font18blackWight500.copyWith(
              fontWeight: FontWeight.w400,
              fontSize: 16.sp,
            ),
          ),
        ),
      ],
    );
  }
}

final List<Map<String, dynamic>> categoriesView = [
  {
    "title": "الأدوية",
    "image": "assets/images/medicines_icon.png",
    "route": Routes.medcinesView,
    "isProductionModule": true,
    "moduleNameIdentifier": MedicalModule.medications,
  },
  {
    "title": "الشكاوى\nالطارئة",
    "image": "assets/images/urgent_icon.png",
    "route": Routes.emergenciesComplaintDataView,
    "isProductionModule": true,
    "moduleNameIdentifier": MedicalModule.urgentComplaints,
  },
  {
    "title": "روشتة الأطباء",
    "image": "assets/images/doctor_medicines.png",
    "route": Routes.prescriptionView,
    "isProductionModule": true,
    "moduleNameIdentifier": MedicalModule.doctorsPrescriptions,
  },
  {
    "title": "التحاليل الطبية",
    "image": "assets/images/test_tube.png",
    "route": Routes.medicalAnalysisView,
    "isProductionModule": true,
    "moduleNameIdentifier": MedicalModule.medicalTests,
  },
  {
    "title": "الأشعة",
    "image": "assets/images/x_ray.png",
    "route": Routes.xRayDataView,
    "isProductionModule": true,
    "moduleNameIdentifier": MedicalModule.radiology,
  },
  {
    "title": "العمليات\nالجراحية",
    "image": "assets/images/surgery_icon.png",
    "route": Routes.surgeriesView,
    "isProductionModule": true,
    "moduleNameIdentifier": MedicalModule.surgeries,
  },
  {
    "title": "المناظير\nالطبيه",
    "image": "assets/images/machine_icon.png",
    "route": "/tumors",
    "isProductionModule": false,
    "moduleNameIdentifier": MedicalModule.medicalEndoscopes,
  },
  {
    "title": "الامراض\n المزمنه",
    "image": "assets/images/time_icon.png",
    "route": Routes.chronicDiseaseDataView,
    "isProductionModule": true,
    "moduleNameIdentifier": MedicalModule.chronicDiseases,
  },
  {
    "title": "الأورام",
    "image": "assets/images/tumor_icon.png",
    "route": "/biological_regulation",
    "isProductionModule": false,
    "moduleNameIdentifier": MedicalModule.tumors,
  },
  {
    "title": "الأمراض\n الوراثيه",
    "image": "assets/images/icon_family.png",
    "route": Routes.geneticDiseasesHomeScreen,
    "isProductionModule": true,
    "moduleNameIdentifier": MedicalModule.geneticDiseases,
  },
  {
    "title": "الغسيل\nالكلوى",
    "image": "assets/images/kidney_wash.png",
    "route": "/other_sections",
    "isProductionModule": false,
    "moduleNameIdentifier": MedicalModule.kidneyDialysis,
  },
  {
    "title": "الحساسية",
    "image": "assets/images/hand_icon.png",
    "route": Routes.allergyDataView,
    "isProductionModule": true,
    "moduleNameIdentifier": MedicalModule.allergies,
  },
  {
    "title": "العيون",
    "image": "assets/images/eye_module_pic.png",
    "route": Routes.eyesOrGlassesDataView,
    "isProductionModule": true,
    "moduleNameIdentifier": MedicalModule.eyes,
  },
  {
    "title": "الأسنان",
    "image": "assets/images/teeth_icon.png",
    "route": Routes.toothAnatomyView,
    "isProductionModule": true,
    "moduleNameIdentifier": MedicalModule.dental,
  },
  {
    "title": "العلاج\nالطبيعى",
    "image": "assets/images/physical_therapy.png",
    "route": "/other_sections",
    "isProductionModule": false,
    "moduleNameIdentifier": MedicalModule.physicalTherapy,
  },
  {
    "title": "التطعيمات",
    "image": "assets/images/eye_dropper.png",
    "route": Routes.vaccineView,
    "isProductionModule": true,
    "moduleNameIdentifier": MedicalModule.vaccinations,
  },
  {
    "title": "متابعة\n الحمل",
    "image": "assets/images/pergenant_woman.png",
    "route": "/specializations",
    "isProductionModule": false,
    "moduleNameIdentifier": MedicalModule.pregnancyFollowUp,
  },
  {
    "title": "علاج مشاكل\nالانجاب",
    "image": "assets/images/baby_icon.png",
    "route": "/psychological_disorders",
    "isProductionModule": false,
    "moduleNameIdentifier": MedicalModule.reproductiveProblems,
  },
  {
    "title": "الحروق",
    "image": "assets/images/fire_icon.png",
    "route": "/cosmetic_procedures",
    "isProductionModule": false,
    "moduleNameIdentifier": MedicalModule.burns,
  },
  {
    "title": "الجراحات\nالتجميلية",
    "image": "assets/images/woman.png",
    "route": "/dietary_habits",
    "isProductionModule": false,
    "moduleNameIdentifier": MedicalModule.cosmeticSurgeries,
  },
  {
    "title": "الأمراض\nالنفسية",
    "image": "assets/images/mental_health.png",
    "route": Routes.medicalIllnessOrMindUmbrellaView,
    "isProductionModule": true,
    "moduleNameIdentifier": MedicalModule.mentalHealth,
  },
  {
    "title": "السلوكيات\nالخاطئة",
    "image": "assets/images/risk_behavior.png",
    "route": Routes.riskyBehaviorsDataView,
    "isProductionModule": true,
    "moduleNameIdentifier": MedicalModule.riskyBehaviors,
  },
  {
    "title": "الصحه\nالعامه",
    "image": "assets/images/heart_icon.png",
    "route": "/mental_issues",
    "isProductionModule": false,
    "moduleNameIdentifier": MedicalModule.publicHealth,
  },
  {
    "title": "المتابعه الغذائية",
    "image": "assets/images/chemical_medicine.png",
    "route": Routes.nutritionPlanDataView,
    "isProductionModule": true,
    "moduleNameIdentifier": MedicalModule.smartNutritionalAnalyzer,
  },
  {
    "title": "النشاط الرياضي",
    "image": "assets/images/physical_exercise.png",
    "route": Routes.physicalActivityDataView,
    "isProductionModule": true,
    "moduleNameIdentifier": MedicalModule.sportsActivity,
  },
  {
    "title": "الفيتامينات و\nالمكملات الغذائية",
    "image": "assets/images/vitamin_module_icon.png",
    "route": Routes.supplementsView,
    "isProductionModule": true,
    "moduleNameIdentifier": MedicalModule.supplements,
  },
];

const Map<String, String> _arabicTitleToField = {
  "التحاليل الطبية": "labTest",
  "العمليات\nالجراحية": "surgery",
  "الشكاوى\nالطارئة": "emergency",
  "الأشعة": "radiology",
  "الأدوية": "medicine",
  "التطعيمات": "vaccine",
  "روشتة الأطباء": "predescription",
};

int getCategoryCountByArabicTitle(
    CategoriesTicketsCount countData, String arabicTitle) {
  final fieldName = _arabicTitleToField[arabicTitle];
  if (fieldName == null) return 0;

  switch (fieldName) {
    case 'labTest':
      return countData.labTest;
    case 'surgery':
      return countData.surgery;
    case 'emergency':
      return countData.emergency;
    case 'radiology':
      return countData.radiology;
    case 'medicine':
      return countData.medicine;
    case 'vaccine':
      return countData.vaccine;
    case 'predescription':
      return countData.predescription;
    default:
      return 0;
  }
}
