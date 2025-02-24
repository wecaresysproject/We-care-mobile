import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/core/routing/routes.dart';

class MedicalCategoriesTypesGridView extends StatelessWidget {
  const MedicalCategoriesTypesGridView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
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
          return MedicalCategoryItem(
            title: categoriesView[index]["title"]!,
            imagePath: categoriesView[index]["image"]!,
            routeName: categoriesView[index]["route"]!,
            notificationCount: index % 2 == 0 ? 1 : 10,
          );
        },
      ),
    );
  }
}

class MedicalCategoryItem extends StatelessWidget {
  final String title;
  final String imagePath;
  final String routeName;
  final int? notificationCount; // Added notification count

  const MedicalCategoryItem({
    super.key,
    required this.title,
    required this.imagePath,
    required this.routeName,
    this.notificationCount, // Optional parameter for the badge
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: () async {
            await context.pushNamed(routeName);
          },
          child: Stack(
            clipBehavior: Clip.none, // Allows badge to overflow
            children: [
              // Main Category Container
              Container(
                width: 99.w,
                height: 88.h,
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
              if (notificationCount != null && notificationCount! > 0)
                Positioned(
                  top: 60.h,
                  right: -5.w,
                  child: Container(
                    height: 30.31.h,
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
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
            style: AppTextStyles.font18blackWight500,
          ),
        ),
      ],
    );
  }
}

// Categories with Named Routes
final List<Map<String, String>> categoriesView = [
  {
    "title": "الأدوية",
    "image": "assets/images/medicines_icon.png",
    "route": "/medications"
  },
  {
    "title": "الشكاوى\nالطارئة",
    "image": "assets/images/urgent_icon.png",
    "route": "/lab_diagnostics"
  },
  {
    "title": "روشتة الأطباء",
    "image": "assets/images/doctor_medicines.png",
    "route": Routes.prescriptionView,
  },
  {
    "title": "التحاليل الطبية",
    "image": "assets/images/test_tube.png",
    "route": Routes.medicalAnalysisView,
  },
  {
    "title": "الأشعة",
    "image": "assets/images/x_ray.png",
    "route": Routes.xRayDataView,
  },
  {
    "title": "العمليات\nالجراحية",
    "image": "assets/images/surgery_icon.png",
    "route": "/surgeries"
  },
  {
    "title": "المناظير\nالطبيه",
    "image": "assets/images/machine_icon.png",
    "route": "/tumors",
  },
  {
    "title": "الامراض\n المزمنه",
    "image": "assets/images/time_icon.png",
    "route": "/organic_disorders"
  },
  {
    "title": "الأورام",
    "image": "assets/images/tumor_icon.png",
    "route": "/biological_regulation"
  },
  {
    "title": "الأمراض\n الوراثيه",
    "image": "assets/images/icon_family.png",
    "route": "/allergy"
  },
  {
    "title": "الغسيل\nالكلوى",
    "image": "assets/images/kidney_wash.png",
    "route": "/other_sections"
  },
  {
    "title": "الحساسية",
    "image": "assets/images/hand_icon.png",
    "route": "/genetic_disorders"
  },
  {
    "title": "العيون",
    "image": "assets/images/hand_icon.png", //TODO: Change Icon مشفثق
    "route": "/eye_care",
  },
  {
    "title": "الأسنان",
    "image": "assets/images/teeth_icon.png",
    "route": "/dental",
  },
  {
    "title": "العلاج\nالطبيعى",
    "image": "assets/images/physical_therapy.png",
    "route": "/other_sections"
  },
  {
    "title": "التطعيمات",
    "image": "assets/images/eye_dropper.png",
    "route": "/pregnancy_followup"
  },
  {
    "title": "متابعة\n الحمل",
    "image": "assets/images/pergenant_woman.png",
    "route": "/specializations"
  },
  {
    "title": "علاج مشاكل\nالانجاب",
    "image": "assets/images/baby_icon.png",
    "route": "/psychological_disorders"
  },
  {
    "title": "الحروق",
    "image": "assets/images/fire_icon.png",
    "route": "/cosmetic_procedures"
  },
  {
    "title": "الجراحات\nالتجميلية",
    "image": "assets/images/woman.png",
    "route": "/dietary_habits"
  },
  {
    "title": "الأمراض\nالنفسية",
    "image": "assets/images/mental_health.png",
    "route": "/general_health"
  },
  {
    "title": "السلوكيات\nالخطرة",
    "image": "assets/images/red_icon.png",
    "route": "/risky_behaviors"
  },
  {
    "title": "الصحه\nالعامه",
    "image": "assets/images/heart_icon.png",
    "route": "/mental_issues"
  },
  {
    "title": "العادات\nالغذائية",
    "image": "assets/images/spoon_icon.png",
    "route": "/mental_issues"
  },
  {
    "title": "المكملات\nالغذائية",
    "image": "assets/images/chemical_medicine.png",
    "route": "/mental_issues"
  },
];
