import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/core/routing/routes.dart';

class DataEntryCategoriesGridView extends StatelessWidget {
  const DataEntryCategoriesGridView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GridView.builder(
        itemCount: categories.length,
        physics: const BouncingScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisExtent:
              146.h, //! Fixed height for each item until text overflows
          childAspectRatio: .85,
          crossAxisSpacing: 13.w,
          mainAxisSpacing: 32.h,
        ),
        itemBuilder: (context, index) {
          return CategoryItem(
            title: categories[index]["title"]!,
            imagePath: categories[index]["image"]!,
            routeName: categories[index]["route"]!,
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

  const CategoryItem({
    super.key,
    required this.title,
    required this.imagePath,
    required this.routeName,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 99.w,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () async {
              await context.pushNamed(routeName);
            },
            child: Container(
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
          ),
          verticalSpacing(8.h),
          Text(
            title,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.font22WhiteWeight600.copyWith(
              fontSize: 14.sp,
              color: AppColorsManager.textColor,
            ),
          )
        ],
      ),
    );
  }
}

// Categories with Named Routes
final List<Map<String, String>> categories = [
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
    "route": "/doctor_routine"
  },
  {
    "title": "التحاليل الطبية",
    "image": "assets/images/test_tube.png",
    "route": "/radiology"
  },
  {
    "title": "الأشعة",
    "image": "assets/images/x_ray.png",
    "route": Routes.xrayCategoryDataEntryView,
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
