import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/di/dependency_injection.dart';
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
            audio: dataEntryCategories[index]["audio"] ?? "",
          );
        },
      ),
    );
  }
}

class CategoryItem extends StatefulWidget {
  const CategoryItem({
    super.key,
    required this.title,
    required this.imagePath,
    required this.routeName,
    this.isActive = false,
    required this.cornerImagePath,
    this.audio,
  });

  final String title;
  final String imagePath;
  final String routeName;
  final bool isActive;
  final String cornerImagePath;
  final String? audio;

  @override
  State<CategoryItem> createState() => _CategoryItemState();
}

class _CategoryItemState extends State<CategoryItem> {
  bool isPlaying = false;

  @override
  void didUpdateWidget(covariant CategoryItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    // عند الرجوع، نتاكد ان الصوت موقف والصورة غامقة
    if (!mounted) return;
    setState(() {
      isPlaying = false;
    });
  }

  Future<void> _toggleAudio() async {
    try {
      final AudioPlayer audioPlayer = getIt.get<AudioPlayer>();
      await playSound(assetPath: widget.audio!);
      setState(() => isPlaying = true);

      audioPlayer.onPlayerComplete.listen((event) {
        if (mounted) {
          setState(() => isPlaying = false);
        }
      });
    } catch (e) {
      debugPrint('Audio play error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: widget.isActive
              ? () async {
                  await stopSound();
                  if (mounted) {
                    setState(() => isPlaying = false); // قبل الانتقال
                  }

                  if (!context.mounted) return;

                  await context.pushNamed(widget.routeName);
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
                        widget.imagePath,
                        fit: BoxFit.contain,
                        height: 51.h,
                        width: 52.w,
                      ),
                    ),
                  ),
                  if (!widget.isActive)
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
              Positioned(
                top: -23,
                left: -1,
                child: GestureDetector(
                  onTap: _toggleAudio,
                  child: ColorFiltered(
                    colorFilter: isPlaying
                        ? ColorFilter.matrix(<double>[
                            1, 0, 0, 0, 60, // Red
                            0, 1, 0, 0, 60, // Green
                            0, 0, 1, 0, 60, // Blue
                            0, 0, 0, 1, 0, // Alpha
                          ])
                        : const ColorFilter.mode(
                            Colors.transparent, BlendMode.dst),
                    child: Image.asset(
                      widget.cornerImagePath,
                      width: 35.w,
                      height: 35.h,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        verticalSpacing(8.h),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            widget.title,
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
    "audio": "",
  },
  {
    "title": "الشكاوى\nالطارئة",
    "image": "assets/images/urgent_icon.png",
    "route": Routes.emergenciesComplaintDataEntryView,
    "isActive": true,
    "cornerImagePath": "assets/images/emergency_module.png",
    "audio": "",
  },
  {
    "title": "روشتة الأطباء",
    "image": "assets/images/doctor_medicines.png",
    "route": Routes.prescriptionCategoryDataEntryView,
    "isActive": true,
    "cornerImagePath": "assets/images/ebn_senaa.png",
    "audio": "",
  },
  {
    "title": "التحاليل الطبية",
    "image": "assets/images/test_tube.png",
    "route": Routes.testAnalsisDataEntryView,
    "isActive": true,
    "cornerImagePath": "assets/images/laboratory_test.png",
    "audio": "",
  },
  {
    "title": "الأشعة",
    "image": "assets/images/x_ray.png",
    "route": Routes.xrayCategoryDataEntryView,
    "isActive": true,
    "cornerImagePath": "assets/images/xray_module.png",
    "audio": "",
  },
  {
    "title": "العمليات\nالجراحية",
    "image": "assets/images/surgery_icon.png",
    "route": Routes.surgeriesDataEntryView,
    "isActive": true,
    "cornerImagePath": "assets/images/surgery_module.png",
    "audio": "",
  },
  {
    "title": "المناظير\nالطبيه",
    "image": "assets/images/machine_icon.png",
    "route": "/tumors",
    "cornerImagePath": "assets/images/manazeer_tebeya_module.png",
    "audio": "",
  },
  {
    "title": "الامراض\n المزمنه",
    "image": "assets/images/time_icon.png",
    "route": "/organic_disorders",
    "cornerImagePath": "assets/images/chronic_disease_module.png",
    "audio": "sounds/ebn_sena.mp3",
  },
  {
    "title": "الأورام",
    "image": "assets/images/tumor_icon.png",
    "route": "/biological_regulation",
    "cornerImagePath": "assets/images/tumors_module.png",
    "audio": "",
  },
  {
    "title": "الأمراض\n الوراثيه",
    "image": "assets/images/icon_family.png",
    "cornerImagePath": "assets/images/genetic_dissease_module.png",
    "route": Routes.geneticDiseaeseMainView,
    "isActive": true,
    "audio": "",
  },
  {
    "title": "الغسيل\nالكلوى",
    "image": "assets/images/kidney_wash.png",
    "route": "/other_sections",
    "cornerImagePath": "assets/images/gaseel_kelawey_module.png",
    "audio": "",
  },
  {
    "title": "الحساسية",
    "image": "assets/images/hand_icon.png",
    "route": "/genetic_disorders",
    "cornerImagePath": "assets/images/hasseya_module.png",
    "audio": "",
  },
  {
    "title": "العيون",
    "image": "assets/images/hand_icon.png", //TODO: Change Icon مشفثق
    "route": "kklsmq",
    "cornerImagePath": "assets/images/eyes_module.png",
    "audio": "",
  },
  {
    "title": "الأسنان",
    "image": "assets/images/teeth_icon.png",
    "route": Routes.dentalAnatomyDiagramEntryView,
    "isActive": true,
    "cornerImagePath": "assets/images/tooth_module.png",
    "audio": "",
  },
  {
    "title": "العلاج\nالطبيعى",
    "image": "assets/images/physical_therapy.png",
    "route": "/other_sections",
    "cornerImagePath": "assets/images/physical_therapy_module.png",
    "audio": "",
  },
  {
    "title": "التطعيمات",
    "image": "assets/images/eye_dropper.png",
    "route": Routes.vaccineDataEntryView,
    "isActive": true,
    "cornerImagePath": "assets/images/tatemaat_module.png",
    "audio": "",
  },
  {
    "title": "متابعة\n الحمل",
    "image": "assets/images/pergenant_woman.png",
    "route": "/specializations",
    "cornerImagePath": "assets/images/prenatal_care_module.png",
    "audio": "",
  },
  {
    "title": "علاج مشاكل\nالانجاب",
    "image": "assets/images/baby_icon.png",
    "route": "/psychological_disorders",
    "cornerImagePath": "assets/images/fertility_treatment_module.png",
    "audio": "",
  },
  {
    "title": "الحروق",
    "image": "assets/images/fire_icon.png",
    "route": "/cosmetic_procedures",
    "cornerImagePath": "assets/images/burns_degrees_module.png",
    "audio": "",
  },
  {
    "title": "الجراحات\nالتجميلية",
    "image": "assets/images/woman.png",
    "route": "/dietary_habits",
    "cornerImagePath": "assets/images/cosmetic_surgeries_module.png",
    "audio": "",
  },
  {
    "title": "الأمراض\nالنفسية",
    "image": "assets/images/mental_health.png",
    "route": "/general_health",
    "cornerImagePath": "assets/images/mental_disorder_module.png",
    "audio": "",
  },
  {
    "title": "السلوكيات\nالخطرة",
    "image": "assets/images/red_icon.png",
    "route": "/risky_behaviors",
    "cornerImagePath": "assets/images/risky_behavior_module.png",
    "audio": "",
  },
  {
    "title": "الصحه\nالعامه",
    "image": "assets/images/heart_icon.png",
    "route": "/mental_issues",
    "cornerImagePath": "assets/images/public_health_module.png",
    "audio": "",
  },
  {
    "title": "العادات\nالغذائية",
    "image": "assets/images/spoon_icon.png",
    "route": "/mental_issues",
    "cornerImagePath": "assets/images/eating_habits_module.png",
    "audio": "",
  },
  // {
  //   "title": "المكملات\nالغذائية",
  //   "image": "assets/images/chemical_medicine.png",
  //   "route": "/mental_issues"
  // },
];
