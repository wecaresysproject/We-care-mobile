import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/di/dependency_injection.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/core/routing/routes.dart';
import 'package:we_care/features/show_data_entry_types/Data/Models/all_categories_tickets_count.dart';
import 'package:we_care/features/show_data_entry_types/Data/Repository/categories_repo.dart';

class MedicalCategoriesTypesGridView extends StatelessWidget {
  const MedicalCategoriesTypesGridView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getIt.get<CategoriesRepository>().getAllCategoriesTicketsCount(
        "ar",'Patient'
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        return 
      Expanded(
        child: GridView.builder(
          itemCount: categoriesView.length,
          physics: const BouncingScrollPhysics(),
          clipBehavior: Clip.none,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisExtent:
                148.h, //! Fixed height for each item until text overflows
            childAspectRatio: .85,
            crossAxisSpacing: 13.w,
            mainAxisSpacing: 32.h,
          ),
itemBuilder: (context, index) {
  final counts = snapshot.data!; // This is CategoriesTicketsCount
  final categoryName = categoriesView[index]["title"]!;

  final count = getCategoryCountByArabicTitle(counts, categoryName);

  return MedicalCategoryItem(
    title: categoryName,
    imagePath: categoriesView[index]["image"]!,
    routeName: categoriesView[index]["route"]!,
    notificationCount: count,
    isActive: categoriesView[index]["isActive"],
  );
}


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
  final int? notificationCount; // Added notification count
  final bool isActive;

  const MedicalCategoryItem({
    super.key,
    required this.title,
    required this.imagePath,
    required this.routeName,
    this.notificationCount, // Optional parameter for the badge
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: isActive
              ? () async {
                  await context.pushNamed(routeName);
                }
              : null, // Disable interaction if not active

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
              if (isActive &&
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
              if (!isActive)
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

// Categories with Named Routes
final List<Map<String, dynamic>> categoriesView = [
  {
    "title": "الأدوية",
    "image": "assets/images/medicines_icon.png",
    "route": Routes.medcinesView,
    "isActive": true,
  },
  {
    "title": "الشكاوى\nالطارئة",
    "image": "assets/images/urgent_icon.png",
    "route": Routes.emergenciesComplaintDataView,
    "isActive": true,
  },
  {
    "title": "روشتة الأطباء",
    "image": "assets/images/doctor_medicines.png",
    "route": Routes.prescriptionView,
    "isActive": true,
  },
  {
    "title": "التحاليل الطبية",
    "image": "assets/images/test_tube.png",
    "route": Routes.medicalAnalysisView,
    "isActive": true,
  },
  {
    "title": "الأشعة",
    "image": "assets/images/x_ray.png",
    "route": Routes.xRayDataView,
    "isActive": true,
  },
  {
    "title": "العمليات\nالجراحية",
    "image": "assets/images/surgery_icon.png",
    "route": Routes.surgeriesView,
    "isActive": true,
  },
  {
    "title": "المناظير\nالطبيه",
    "image": "assets/images/machine_icon.png",
    "route": "/tumors",
    "isActive": false,
  },
  {
    "title": "الامراض\n المزمنه",
    "image": "assets/images/time_icon.png",
    "route": "/organic_disorders",
    "isActive": false,
  },
  {
    "title": "الأورام",
    "image": "assets/images/tumor_icon.png",
    "route": "/biological_regulation",
    "isActive": false,
  },
  {
    "title": "الأمراض\n الوراثيه",
    "image": "assets/images/icon_family.png",
    "route": "/allergy",
    "isActive": false,
  },
  {
    "title": "الغسيل\nالكلوى",
    "image": "assets/images/kidney_wash.png",
    "route": "/other_sections",
    "isActive": false,
  },
  {
    "title": "الحساسية",
    "image": "assets/images/hand_icon.png",
    "route": "/genetic_disorders",
    "isActive": false,
  },
  {
    "title": "العيون",
    "image": "assets/images/hand_icon.png", //TODO: Change Icon مشفثق
    "route": "/eye_care",
    "isActive": false,
  },
  {
    "title": "الأسنان",
    "image": "assets/images/teeth_icon.png",
    "route": "/dental",
    "isActive": false,
  },
  {
    "title": "العلاج\nالطبيعى",
    "image": "assets/images/physical_therapy.png",
    "route": "/other_sections",
    "isActive": false,
  },
  {
    "title": "التطعيمات",
    "image": "assets/images/eye_dropper.png",
    "route": Routes.vaccineView,
    "isActive": true,
  },
  {
    "title": "متابعة\n الحمل",
    "image": "assets/images/pergenant_woman.png",
    "route": "/specializations",
    "isActive": false,
  },
  {
    "title": "علاج مشاكل\nالانجاب",
    "image": "assets/images/baby_icon.png",
    "route": "/psychological_disorders",
    "isActive": false,
  },
  {
    "title": "الحروق",
    "image": "assets/images/fire_icon.png",
    "route": "/cosmetic_procedures",
    "isActive": false,
  },
  {
    "title": "الجراحات\nالتجميلية",
    "image": "assets/images/woman.png",
    "route": "/dietary_habits",
    "isActive": false,
  },
  {
    "title": "الأمراض\nالنفسية",
    "image": "assets/images/mental_health.png",
    "route": "/general_health",
    "isActive": false,
  },
  {
    "title": "السلوكيات\nالخطرة",
    "image": "assets/images/red_icon.png",
    "route": "/risky_behaviors",
    "isActive": false,
  },
  {
    "title": "الصحه\nالعامه",
    "image": "assets/images/heart_icon.png",
    "route": "/mental_issues",
    "isActive": false,
  },
  {
    "title": "العادات\nالغذائية",
    "image": "assets/images/spoon_icon.png",
    "route": "/mental_issues",
    "isActive": false,
  },
  {
    "title": "المكملات\nالغذائية",
    "image": "assets/images/chemical_medicine.png",
    "route": "/mental_issues",
    "isActive": false,
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


int getCategoryCountByArabicTitle(CategoriesTicketsCount countData, String arabicTitle) {
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
