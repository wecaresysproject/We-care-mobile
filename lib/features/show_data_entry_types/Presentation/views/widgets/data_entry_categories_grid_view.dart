import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/routing/routes.dart';

class DataEntryCategoriesGridView extends StatelessWidget {
  const DataEntryCategoriesGridView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GridView.builder(
        itemCount: dataEntryCategories.length,
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
          return CategoryItem(
            title: dataEntryCategories[index]["title"]!,
            imagePath: dataEntryCategories[index]["image"]!,
            routeName: dataEntryCategories[index]["route"]!,
            isActive: dataEntryCategories[index]["isActive"] ?? false,
            cornerImagePath: dataEntryCategories[index]["cornerImagePath"] ??
                "assets/images/basic_data.png", // Default corner image
          );
        },
      ),
    );
  }
}

class CategoryItem extends StatelessWidget {
  final String title;
  final String imagePath;
  final String routeName;
  final bool isActive;
  final String cornerImagePath;

  const CategoryItem({
    super.key,
    required this.title,
    required this.imagePath,
    required this.routeName,
    this.isActive = false,
    required this.cornerImagePath,
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
              : null,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Stack(
                children: [
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
                    padding: EdgeInsets.symmetric(
                      vertical: 18.h,
                      horizontal: 24.w,
                    ),
                    child: Center(
                      child: Image.asset(
                        imagePath,
                        fit: BoxFit.contain,
                        height: 51.h,
                        width: 52.w,
                      ),
                    ),
                  ),
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

              // Conditionally show corner image if provided
              Positioned(
                top: -23,
                left: -1,
                child: Image.asset(
                  cornerImagePath,
                  width: 35.w,
                  height: 35.h,
                ),
              ),
            ],
          ),
        ),
        verticalSpacing(8.h),
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
        )
      ],
    );
  }
}

// Categories with Named Routes
final List<Map<String, dynamic>> dataEntryCategories = [
  {
    "title": "الأدوية",
    "image": "assets/images/medicines_icon.png",
    "route": Routes.medcinesDataEntryView,
    "isActive": true,
    "cornerImagePath": "assets/images/medicine_module.png",
  },
  {
    "title": "الشكاوى\nالطارئة",
    "image": "assets/images/urgent_icon.png",
    "route": Routes.emergenciesComplaintDataEntryView,
    "isActive": true,
    "cornerImagePath": "assets/images/emergency_module.png",
  },
  {
    "title": "روشتة الأطباء",
    "image": "assets/images/doctor_medicines.png",
    "route": Routes.prescriptionCategoryDataEntryView,
    "isActive": true,
    "cornerImagePath": "assets/images/ebn_senaa.png",
  },
  {
    "title": "التحاليل الطبية",
    "image": "assets/images/test_tube.png",
    "route": Routes.testAnalsisDataEntryView,
    "isActive": true,
    "cornerImagePath": "assets/images/laboratory_test.png",
  },
  {
    "title": "الأشعة",
    "image": "assets/images/x_ray.png",
    "route": Routes.xrayCategoryDataEntryView,
    "isActive": true,
    "cornerImagePath": "assets/images/xray_module.png",
  },
  {
    "title": "العمليات\nالجراحية",
    "image": "assets/images/surgery_icon.png",
    "route": Routes.surgeriesDataEntryView,
    "isActive": true,
    "cornerImagePath": "assets/images/surgery_module.png",
  },
  {
    "title": "المناظير\nالطبيه",
    "image": "assets/images/machine_icon.png",
    "route": "/tumors",
    "cornerImagePath": "assets/images/manazeer_tebeya_module.png",
  },
  {
    "title": "الامراض\n المزمنه",
    "image": "assets/images/time_icon.png",
    "route": "/organic_disorders",
    "cornerImagePath": "assets/images/chronic_disease_module.png",
  },
  {
    "title": "الأورام",
    "image": "assets/images/tumor_icon.png",
    "route": "/biological_regulation",
    "cornerImagePath": "assets/images/tumors_module.png",
  },
  {
    "title": "الأمراض\n الوراثيه",
    "image": "assets/images/icon_family.png",
    "route": "/allergy",
    "cornerImagePath": "assets/images/genetic_dissease_module.png",
  },
  {
    "title": "الغسيل\nالكلوى",
    "image": "assets/images/kidney_wash.png",
    "route": "/other_sections",
    "cornerImagePath": "assets/images/gaseel_kelawey_module.png",
  },
  {
    "title": "الحساسية",
    "image": "assets/images/hand_icon.png",
    "route": "/genetic_disorders",
    "cornerImagePath": "assets/images/hasseya_module.png",
  },
  {
    "title": "العيون",
    "image": "assets/images/hand_icon.png", //TODO: Change Icon مشفثق
    "route": "kklsmq",
    "cornerImagePath": "assets/images/eyes_module.png",
  },
  {
    "title": "الأسنان",
    "image": "assets/images/teeth_icon.png",
    "route": Routes.dentalAnatomyDiagramEntryView,
    "isActive": true,
    "cornerImagePath": "assets/images/tooth_module.png",
  },
  {
    "title": "العلاج\nالطبيعى",
    "image": "assets/images/physical_therapy.png",
    "route": "/other_sections",
    "cornerImagePath": "assets/images/physical_therapy_module.png",
  },
  {
    "title": "التطعيمات",
    "image": "assets/images/eye_dropper.png",
    "route": Routes.vaccineDataEntryView,
    "isActive": true,
    "cornerImagePath": "assets/images/tatemaat_module.png",
  },
  {
    "title": "متابعة\n الحمل",
    "image": "assets/images/pergenant_woman.png",
    "route": "/specializations",
    "cornerImagePath": "assets/images/prenatal_care_module.png",
  },
  {
    "title": "علاج مشاكل\nالانجاب",
    "image": "assets/images/baby_icon.png",
    "route": "/psychological_disorders",
    "cornerImagePath": "assets/images/fertility_treatment_module.png",
  },
  {
    "title": "الحروق",
    "image": "assets/images/fire_icon.png",
    "route": "/cosmetic_procedures",
    "cornerImagePath": "assets/images/burns_degrees_module.png",
  },
  {
    "title": "الجراحات\nالتجميلية",
    "image": "assets/images/woman.png",
    "route": "/dietary_habits",
    "cornerImagePath": "assets/images/cosmetic_surgeries_module.png",
  },
  {
    "title": "الأمراض\nالنفسية",
    "image": "assets/images/mental_health.png",
    "route": "/general_health",
    "cornerImagePath": "assets/images/mental_disorder_module.png",
  },
  {
    "title": "السلوكيات\nالخطرة",
    "image": "assets/images/red_icon.png",
    "route": "/risky_behaviors",
    "cornerImagePath": "assets/images/risky_behavior_module.png",
  },
  {
    "title": "الصحه\nالعامه",
    "image": "assets/images/heart_icon.png",
    "route": "/mental_issues",
    "cornerImagePath": "assets/images/public_health_module.png",
  },
  {
    "title": "العادات\nالغذائية",
    "image": "assets/images/spoon_icon.png",
    "route": "/mental_issues",
    "cornerImagePath": "assets/images/eating_habits_module.png",
  },
  // {
  //   "title": "المكملات\nالغذائية",
  //   "image": "assets/images/chemical_medicine.png",
  //   "route": "/mental_issues"
  // },
];
