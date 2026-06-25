import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/di/dependency_injection.dart';
import 'package:we_care/core/global/Helpers/app_logger.dart';
import 'package:we_care/core/global/Helpers/app_toasts.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/shared_repo.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/models/medical_module_enum.dart';
import 'package:we_care/core/routing/routes.dart';
import 'package:we_care/features/nutration/data/repos/nutration_data_entry_repo.dart';
import 'package:we_care/features/nutration/nutration_data_entry/logic/cubit/nutration_data_entry_cubit.dart';
import 'package:we_care/features/physical_activaty/physical_activaty_data_entry/logic/cubit/physical_activaty_data_entry_cubit.dart';
import 'package:we_care/features/supplements/supplements_data_entry/logic/supplements_data_entry_cubit.dart';

class DataEntryCategoriesGridView extends StatelessWidget {
  const DataEntryCategoriesGridView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Builder(
        builder: (context) {
          // Sort active first
          final sortedCategories = [...dataEntryCategories]..sort((a, b) =>
              (b["isProductionModule"] == true ? 1 : 0)
                  .compareTo(a["isProductionModule"] == true ? 1 : 0));

          return GridView.builder(
            itemCount: sortedCategories.length,
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(vertical: 32.h),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisExtent: 148.h,
              childAspectRatio: .85,
              crossAxisSpacing: 13.w,
              mainAxisSpacing: 32.h,
            ),
            itemBuilder: (context, index) {
              final category = sortedCategories[index];
              return CategoryItem(
                title: category["title"]!,
                imagePath: category["image"]!,
                routeName: category["route"]!,
                isProductionModule: category["isProductionModule"] ?? false,
                cornerImagePath: category["cornerImagePath"] ??
                    "assets/images/basic_data.png",
                audio: category["audio"] ?? "",
              );
            },
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
    this.isProductionModule = false,
    required this.cornerImagePath,
    this.audio,
  });

  final String title;
  final String imagePath;
  final String routeName;
  final bool isProductionModule;
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
      AppLogger.error('Audio play error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<NutrationDataEntryCubit>(
          create: (context) => NutrationDataEntryCubit(
              getIt<NutrationDataEntryRepo>(), context, getIt<AppSharedRepo>()),
        ),
        BlocProvider<SupplementsDataEntryCubit>(
          create: (context) => getIt<SupplementsDataEntryCubit>(),
        ),
        BlocProvider<PhysicalActivatyDataEntryCubit>(
          create: (context) => getIt<PhysicalActivatyDataEntryCubit>(),
        ),
      ],
      child: Builder(builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: widget.isProductionModule
                  ? () => _handleCategoryTap(context)
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
                      if (!widget.isProductionModule)
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
      }),
    );
  }

  Future<void> _handleCategoryTap(BuildContext context) async {
    await stopSound();

    if (!mounted) return;
    setState(() => isPlaying = false);

    if (!context.mounted) return;

    if (widget.title == "المتابعه الغذائية") {
      await _handleNutritionFollowUpTap(context);
    } else if (widget.title == "الفيتامينات و\nالمكملات الغذائية") {
      await _handleSupplementsFollowUpTap(context);
    } else if (widget.title == "النشاط الرياضي") {
      await _handlePhysicalActivityFollowUpTap(context);
    } else {
      await _navigateTo(context, widget.routeName);
    }
  }

  Future<void> _handlePhysicalActivityFollowUpTap(BuildContext context) async {
    final physicalActivityCubit =
        context.read<PhysicalActivatyDataEntryCubit>();

    final result = await physicalActivityCubit.getAnyActivePlanStatus();

    if (!context.mounted) return;

    switch (result) {
      case true:
        await _navigateTo(context, Routes.physicalActivatyPlansDataEntry);
        break;
      case false:
        await _navigateTo(context, widget.routeName);
        break;
      default:
        await showError("من فضلك حاول مرة اخري");
    }
  }

  Future<void> _handleSupplementsFollowUpTap(BuildContext context) async {
    final supplementsCubit = context.read<SupplementsDataEntryCubit>();

    final result = await supplementsCubit.getAnyActivePlanStatus();

    if (!context.mounted) return;

    switch (result) {
      case true:
        await _navigateTo(context, Routes.supplementsFollowUpPlansView);
        break;
      case false:
        await _navigateTo(context, widget.routeName);
        break;
      default:
        await showError("من فضلك حاول مرة اخري");
    }
  }

  Future<void> _handleNutritionFollowUpTap(BuildContext context) async {
    final nutrationCubit = context.read<NutrationDataEntryCubit>();

    final result = await nutrationCubit.getAnyActivePlanStatus();

    if (!context.mounted) return;

    switch (result) {
      case true:
        await _navigateTo(context, Routes.followUpNutrationPlansView);
        break;
      case false:
        await _navigateTo(context, widget.routeName);
        break;
      default:
        await showError("من فضلك حاول مرة اخري");
    }
  }

  Future<void> _navigateTo(BuildContext context, String routeName) async {
    if (!context.mounted) return;
    await context.pushNamed(routeName);
  }
}

// Categories with Named Routes
final List<Map<String, dynamic>> dataEntryCategories = [
  {
    "title": "الأدوية",
    "moduleNameIdentifier": MedicalModule.medications,
    "image": "assets/images/medicines_icon.png",
    "route": Routes.medcinesDataEntryView,
    "isProductionModule": true,
    "cornerImagePath": "assets/images/medicine_module.png",
    "audio": "",
  },
  {
    "title": "الشكاوى\nالطارئة",
    "moduleNameIdentifier": MedicalModule.urgentComplaints,
    "image": "assets/images/urgent_icon.png",
    "route": Routes.emergenciesComplaintDataEntryView,
    "isProductionModule": true,
    "cornerImagePath": "assets/images/emergency_module.png",
    "audio": "",
  },
  {
    "title": "روشتة الأطباء",
    "moduleNameIdentifier": MedicalModule.doctorsPrescriptions,
    "image": "assets/images/doctor_medicines.png",
    "route": Routes.prescriptionCategoryDataEntryView,
    "isProductionModule": true,
    "cornerImagePath": "assets/images/ebn_senaa.png",
    "audio": "",
  },
  {
    "title": "التحاليل الطبية",
    "moduleNameIdentifier": MedicalModule.medicalTests,
    "image": "assets/images/test_tube.png",
    "route": Routes.testAnalsisDataEntryView,
    "isProductionModule": true,
    "cornerImagePath": "assets/images/laboratory_test.png",
    "audio": "",
  },
  {
    "title": "الأشعة",
    "moduleNameIdentifier": MedicalModule.radiology,
    "image": "assets/images/x_ray.png",
    "route": Routes.xrayCategoryDataEntryView,
    "isProductionModule": true,
    "cornerImagePath": "assets/images/xray_module.png",
    "audio": "",
  },
  {
    "title": "العمليات\nالجراحية",
    "moduleNameIdentifier": MedicalModule.surgeries,
    "image": "assets/images/surgery_icon.png",
    "route": Routes.surgeriesDataEntryView,
    "isProductionModule": true,
    "cornerImagePath": "assets/images/surgery_module.png",
    "audio": "",
  },
  {
    "title": "المناظير\nالطبيه",
    "moduleNameIdentifier": MedicalModule.medicalEndoscopes,
    "image": "assets/images/machine_icon.png",
    "route": "/tumors",
    "isProductionModule": false,
    "cornerImagePath": "assets/images/manazeer_tebeya_module.png",
    "audio": "",
  },
  {
    "title": "الامراض\n المزمنه",
    "moduleNameIdentifier": MedicalModule.chronicDiseases,
    "image": "assets/images/time_icon.png",
    "route": Routes.chronicDiseaseDataEntry,
    "cornerImagePath": "assets/images/chronic_disease_module_agent.png",
    "audio": "sounds/ebn_sena.mp3",
    "isProductionModule": true,
  },
  {
    "title": "الأورام",
    "moduleNameIdentifier": MedicalModule.tumors,
    "image": "assets/images/tumor_icon.png",
    "route": "/biological_regulation",
    "isProductionModule": false,
    "cornerImagePath": "assets/images/tumors_module.png",
    "audio": "",
  },
  {
    "title": "الأمراض\n الوراثيه",
    "moduleNameIdentifier": MedicalModule.geneticDiseases,
    "image": "assets/images/icon_family.png",
    "cornerImagePath": "assets/images/genetic_dissease_module.png",
    "route": Routes.geneticDiseaeseMainView,
    "isProductionModule": true,
    "audio": "",
  },
  {
    "title": "الغسيل\nالكلوى",
    "moduleNameIdentifier": MedicalModule.kidneyDialysis,
    "image": "assets/images/kidney_wash.png",
    "route": "/other_sections",
    "isProductionModule": false,
    "cornerImagePath": "assets/images/gaseel_kelawey_module.png",
    "audio": "",
  },
  {
    "title": "الحساسية",
    "moduleNameIdentifier": MedicalModule.allergies,
    "image": "assets/images/hand_icon.png",
    "route": Routes.allergyDataEntry,
    "cornerImagePath": "assets/images/hasseya_module.png",
    "audio": "",
    "isProductionModule": true,
  },
  {
    "title": "العيون",
    "moduleNameIdentifier": MedicalModule.eyes,
    "image": "assets/images/eye_module_pic.png",
    "cornerImagePath": "assets/images/eyes_module.png",
    "audio": "",
    "isProductionModule": true,
    "route": Routes.eyeOrGlassesView,
  },
  {
    "title": "الأسنان",
    "moduleNameIdentifier": MedicalModule.dental,
    "image": "assets/images/teeth_icon.png",
    "route": Routes.dentalAnatomyDiagramEntryView,
    "isProductionModule": true,
    "cornerImagePath": "assets/images/tooth_module.png",
    "audio": "",
  },
  {
    "title": "العلاج\nالطبيعى",
    "moduleNameIdentifier": MedicalModule.physicalTherapy,
    "image": "assets/images/physical_therapy.png",
    "route": "/other_sections",
    "isProductionModule": false,
    "cornerImagePath": "assets/images/physical_therapy_module.png",
    "audio": "",
  },
  {
    "title": "التطعيمات",
    "moduleNameIdentifier": MedicalModule.vaccinations,
    "image": "assets/images/eye_dropper.png",
    "route": Routes.vaccineDataEntryView,
    "isProductionModule": true,
    "cornerImagePath": "assets/images/tatemaat_module.png",
    "audio": "",
  },
  {
    "title": "متابعة\n الحمل",
    "moduleNameIdentifier": MedicalModule.pregnancyFollowUp,
    "image": "assets/images/pergenant_woman.png",
    "route": "/specializations",
    "isProductionModule": false,
    "cornerImagePath": "assets/images/prenatal_care_module.png",
    "audio": "",
  },
  {
    "title": "علاج مشاكل\nالانجاب",
    "moduleNameIdentifier": MedicalModule.reproductiveProblems,
    "image": "assets/images/baby_icon.png",
    "route": "/psychological_disorders",
    "isProductionModule": false,
    "cornerImagePath": "assets/images/fertility_treatment_module.png",
    "audio": "",
  },
  {
    "title": "الحروق",
    "moduleNameIdentifier": MedicalModule.burns,
    "image": "assets/images/fire_icon.png",
    "route": "/cosmetic_procedures",
    "isProductionModule": false,
    "cornerImagePath": "assets/images/burns_degrees_module.png",
    "audio": "",
  },
  {
    "title": "الجراحات\nالتجميلية",
    "moduleNameIdentifier": MedicalModule.cosmeticSurgeries,
    "image": "assets/images/woman.png",
    "route": "/dietary_habits",
    "isProductionModule": false,
    "cornerImagePath": "assets/images/cosmetic_surgeries_module.png",
    "audio": "",
  },
  {
    "title": "الأمراض\nالنفسية",
    "moduleNameIdentifier": MedicalModule.mentalHealth,
    "image": "assets/images/mental_health.png",
    "route": Routes.mentalIllnessChoiceScreen,
    "cornerImagePath": "assets/images/mental_disorder_module.png",
    "audio": "",
    "isProductionModule": true,
  },
  {
    "title": "السلوكيات\nالخاطئة",
    "moduleNameIdentifier": MedicalModule.riskyBehaviors,
    "image": "assets/images/risk_behavior.png",
    "route": Routes.riskyBehaviorsDataEntryView,
    "isProductionModule": true,
    "cornerImagePath": "assets/images/risky_behavior_module.png",
    "audio": "",
  },
  {
    "title": "الصحه\nالعامه",
    "moduleNameIdentifier": MedicalModule.publicHealth,
    "image": "assets/images/heart_icon.png",
    "route": "/mental_issues",
    "isProductionModule": false,
    "cornerImagePath": "assets/images/public_health_module.png",
    "audio": "",
  },
  {
    "title": "المتابعه الغذائية",
    "moduleNameIdentifier": MedicalModule.smartNutritionalAnalyzer,
    "image": "assets/images/chemical_medicine.png",
    "route": Routes.userInfoNutrationDataEntry,
    "isProductionModule": true,
  },
  {
    "title": "النشاط الرياضي",
    "moduleNameIdentifier": MedicalModule.sportsActivity,
    "image": "assets/images/physical_exercise.png",
    "route": Routes.userPhysicalActivatyInfoDataEntry,
    "isProductionModule": true,
  },
  {
    "title": "الفيتامينات و\nالمكملات الغذائية",
    "moduleNameIdentifier": MedicalModule.supplements,
    "image": "assets/images/vitamin_module_icon.png",
    "route": Routes.supplementsDataEntry,
    "isProductionModule": true,
    "audio": "",
  },
];
