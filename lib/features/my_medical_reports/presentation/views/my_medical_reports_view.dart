import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/di/dependency_injection.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/custom_app_bar_with_centered_title_widget.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/my_medical_reports/data/models/medical_category_model.dart';
import 'package:we_care/features/my_medical_reports/data/models/medical_report_categories_data.dart';
import 'package:we_care/features/my_medical_reports/logic/medical_report_export_logic.dart';
import 'package:we_care/features/my_medical_reports/logic/medical_report_generation_cubit.dart';
import 'package:we_care/features/my_medical_reports/presentation/widgets/category_filters_widget.dart';
import 'package:we_care/features/my_medical_reports/presentation/widgets/generate_button_bloc_consumer_widget.dart';
import 'package:we_care/features/my_medical_reports/presentation/widgets/medical_category_selection_widget.dart';
import 'package:we_care/features/my_medical_reports/presentation/widgets/medical_report_category_item.dart';

class MyMedicalReportsView extends StatefulWidget {
  const MyMedicalReportsView({super.key});

  @override
  State<MyMedicalReportsView> createState() => _MyMedicalReportsViewState();
}

class _MyMedicalReportsViewState extends State<MyMedicalReportsView> {
  // Map to track expanded state of each category
  final Map<int, bool> _expandedStates = {};
  // Map to track selected state of each category
  final Map<int, bool> _selectedStates = {};
  // Map to track selected option values for each category (multi-selection)
  final Map<int, Set<String>> _selectedOptionValues = {};
  // Map to track selected filters for each category: {categoryIndex: {filterTitle: {selectedValues}}}
  final Map<int, Map<String, Set<String>>> _selectedFilters = {};

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<MedicalReportGenerationCubit>(),
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 0,
        ),
        body: BlocBuilder<MedicalReportGenerationCubit,
            MedicalReportGenerationState>(
          builder: (context, state) {
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const AppBarWithCenteredTitle(
                    title: 'تقاريرى الطبية',
                    showActionButtons: false,
                  ),
                  verticalSpacing(24),
                  Column(
                    children: categoriesView.asMap().entries.map((entry) {
                      final index = entry.key;
                      final dummyCategory = entry.value;
                      final filterData =
                          state.categoryFilters[dummyCategory.title];
                      final status =
                          state.categoryFiltersStatus[dummyCategory.title] ??
                              RequestStatus.initial;

                      // Use dynamic data if available, otherwise fallback to dummy list for title/image
                      final category = MedicalCategoryModel(
                        title: dummyCategory.title,
                        image: dummyCategory.image,
                        selectionType: filterData?.selectionType ??
                            dummyCategory.selectionType,
                        radioOptions: filterData?.radioOptions ??
                            dummyCategory.radioOptions,
                        filterSections: filterData?.filterSections ??
                            dummyCategory.filterSections,
                      );

                      final isExpanded = _expandedStates[index] ?? false;
                      final isSelected = _selectedStates[index] ?? false;

                      return Padding(
                        padding: EdgeInsets.only(bottom: 12.h),
                        child: Column(
                          children: [
                            MedicalReportCategoryItem(
                              title: category.title,
                              iconPath: category.image,
                              isExpanded: isExpanded,
                              isSelected: isSelected,
                              onExpandToggle: () {
                                setState(() {
                                  _expandedStates[index] = !isExpanded;
                                });
                                if (!isExpanded) {
                                  context
                                      .read<MedicalReportGenerationCubit>()
                                      .fetchCategoryFilters(
                                          dummyCategory.title, 'ar');
                                }
                              },
                              onCheckboxToggle: () {
                                setState(() {
                                  _selectedStates[index] = !isSelected;
                                });

                                // Basic Info Selection sync
                                if (dummyCategory.title ==
                                    "البيانات الاساسية") {
                                  _syncBasicInfoSelectionToCubit(
                                      context, index);
                                }
                                if (dummyCategory.title == "القياسات الحيوية") {
                                  _syncVitalSignsSelectionToCubit(
                                    context,
                                    index,
                                  );
                                }

                                // Medicine Selection sync
                                if (dummyCategory.title == "الأدوية") {
                                  _syncMedicineSelectionToCubit(context, index);
                                }

                                // Chronic Diseases Selection sync
                                if (dummyCategory.title == "الامراض المزمنه") {
                                  _syncChronicDiseasesSelectionToCubit(
                                      context, index);
                                }

                                // Urgent Complaints Selection sync
                                if (dummyCategory.title == "الشكاوى الطارئة") {
                                  _syncUrgentComplaintsSelectionToCubit(
                                      context, index);
                                }

                                // Radiology Selection sync
                                if (dummyCategory.title == "الأشعة") {
                                  _syncRadiologySelectionToCubit(
                                      context, index);
                                }

                                // Medical Tests Selection sync
                                if (dummyCategory.title == "التحاليل الطبية") {
                                  _syncMedicalTestsSelectionToCubit(
                                      context, index);
                                }

                                // Doctors Prescription Selection sync
                                if (dummyCategory.title == "روشتة الأطباء") {
                                  _syncPrescriptionsSelectionToCubit(
                                      context, index);
                                }

                                // Surgeries Selection sync
                                if (dummyCategory.title ==
                                    "العمليات الجراحية") {
                                  _syncSurgeriesSelectionToCubit(
                                      context, index);
                                }

                                // Genetic Diseases Selection sync
                                if (dummyCategory.title == "الأمراض الوراثية") {
                                  _syncGeneticDiseasesSelectionToCubit(
                                      context, index);
                                }

                                // Allergies Selection sync
                                if (dummyCategory.title == "الحساسية") {
                                  _syncAllergiesSelectionToCubit(
                                      context, index);
                                }

                                // Eyes Selection sync
                                if (dummyCategory.title == "العيون") {
                                  _syncEyesSelectionToCubit(context, index);
                                }

                                // Dental Selection sync
                                if (dummyCategory.title == "الأسنان") {
                                  _syncDentalSelectionToCubit(context, index);
                                }

                                // Smart Nutrition Selection sync
                                if (dummyCategory.title ==
                                    "المحلل الغذائي الذكي") {
                                  _syncSmartNutritionSelectionToCubit(
                                      context, index);
                                }

                                // Supplements Selection sync
                                if (dummyCategory.title ==
                                    "المكملات الغذائية") {
                                  _syncSupplementsSelectionToCubit(
                                      context, index);
                                }

                                // Physical Activity Selection sync
                                if (dummyCategory.title == "النشاط الرياضي") {
                                  _syncPhysicalActivitySelectionToCubit(
                                      context, index, state);
                                }

                                // Mental Diseases Selection sync
                                if (dummyCategory.title == "الأمراض النفسية") {
                                  _syncMentalDiseasesSelectionToCubit(
                                      context, index);
                                }
                              },
                            ),
                            if (isExpanded) ...[
                              if (status == RequestStatus.loading)
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 16.h),
                                  child: const Center(
                                      child: CircularProgressIndicator()),
                                )
                              else ...[
                                if (category.selectionType ==
                                        MedicalSelectionType.selection ||
                                    category.selectionType ==
                                        MedicalSelectionType
                                            .selectionAndFilters)
                                  MedicalCategorySelectionWidget(
                                    options: category.radioOptions,
                                    selectedValues:
                                        _selectedOptionValues[index] ?? {},
                                    onChanged: (value, isSelected) {
                                      setState(() {
                                        final currentSelected =
                                            _selectedOptionValues[index] ?? {};
                                        if (isSelected) {
                                          currentSelected.add(value);
                                        } else {
                                          currentSelected.remove(value);
                                        }
                                        _selectedOptionValues[index] =
                                            currentSelected;
                                      });

                                      // Basic Info Integration (using dummyTitle for key)
                                      if (dummyCategory.title ==
                                          "البيانات الاساسية") {
                                        _syncBasicInfoSelectionToCubit(
                                            context, index);
                                      }
                                      if (dummyCategory.title ==
                                          "القياسات الحيوية") {
                                        _syncVitalSignsSelectionToCubit(
                                          context,
                                          index,
                                        );
                                      }

                                      // Medicine Selection Integration
                                      if (dummyCategory.title == "الأدوية") {
                                        _syncMedicineSelectionToCubit(
                                            context, index);
                                      }

                                      // Radiology Selection Integration
                                      if (dummyCategory.title == "الأشعة") {
                                        _syncRadiologySelectionToCubit(
                                            context, index);
                                      }

                                      // Medical Tests Selection Integration
                                      if (dummyCategory.title ==
                                          "التحاليل الطبية") {
                                        _syncMedicalTestsSelectionToCubit(
                                            context, index);
                                      }

                                      // Doctors Prescription Selection Integration
                                      if (dummyCategory.title ==
                                          "روشتة الأطباء") {
                                        _syncPrescriptionsSelectionToCubit(
                                            context, index);
                                      }

                                      // Surgeries Selection Integration
                                      if (dummyCategory.title ==
                                          "العمليات الجراحية") {
                                        _syncSurgeriesSelectionToCubit(
                                            context, index);
                                      }

                                      // Genetic Diseases Selection Integration
                                      if (dummyCategory.title ==
                                          "الأمراض الوراثية") {
                                        _syncGeneticDiseasesSelectionToCubit(
                                            context, index);
                                      }

                                      // Eyes Selection Integration
                                      if (dummyCategory.title == "العيون") {
                                        _syncEyesSelectionToCubit(
                                            context, index);
                                      }

                                      // Dental Selection Integration
                                      if (dummyCategory.title == "الأسنان") {
                                        _syncDentalSelectionToCubit(
                                            context, index);
                                      }
                                      // Urgent Complaints Selection Integration
                                      if (dummyCategory.title ==
                                          "الشكاوى الطارئة") {
                                        _syncUrgentComplaintsSelectionToCubit(
                                            context, index);
                                      }
                                    },
                                  ),
                                if (category.selectionType ==
                                        MedicalSelectionType.filters ||
                                    category.selectionType ==
                                        MedicalSelectionType
                                            .selectionAndFilters)
                                  CategoryFiltersWidget(
                                    filterSections: category.filterSections!,
                                    selectedFilters:
                                        _selectedFilters[index] ?? {},
                                    onFilterToggle:
                                        (sectionIndex, filterTitle, value) {
                                      setState(
                                        () {
                                          final categoryFilters =
                                              _selectedFilters[index] ?? {};
                                          final String key =
                                              "${sectionIndex}_$filterTitle";
                                          final selectedValues =
                                              categoryFilters[key] ?? {};

                                          final String currentKey =
                                              "${sectionIndex}_$filterTitle";

                                          _handleFilterMutualExclusion(
                                            categoryTitle: dummyCategory.title,
                                            filterTitle: filterTitle,
                                            value: value,
                                            categoryFilters: categoryFilters,
                                            currentKey: currentKey,
                                          );
                                          if (selectedValues.contains(value)) {
                                            selectedValues.remove(value);
                                          } else {
                                            selectedValues.add(value);
                                          }
                                          categoryFilters[key] = selectedValues;
                                          _selectedFilters[index] =
                                              categoryFilters;
                                        },
                                      );

                                      // Medicine Selection Integration
                                      if (dummyCategory.title == "الأدوية") {
                                        _syncMedicineSelectionToCubit(
                                            context, index);
                                      }

                                      // Radiology Selection Integration
                                      if (dummyCategory.title == "الأشعة") {
                                        _syncRadiologySelectionToCubit(
                                            context, index);
                                      }

                                      // Medical Tests Selection Integration
                                      if (dummyCategory.title ==
                                          "التحاليل الطبية") {
                                        _syncMedicalTestsSelectionToCubit(
                                            context, index);
                                      }

                                      // Doctors Prescription Selection Integration
                                      if (dummyCategory.title ==
                                          "روشتة الأطباء") {
                                        _syncPrescriptionsSelectionToCubit(
                                            context, index);
                                      }

                                      // Surgeries Selection Integration
                                      if (dummyCategory.title ==
                                          "العمليات الجراحية") {
                                        _syncSurgeriesSelectionToCubit(
                                            context, index);
                                      }
                                      // Allergies Selection sync
                                      if (dummyCategory.title == "الحساسية") {
                                        _syncAllergiesSelectionToCubit(
                                            context, index);
                                      }

                                      // Eyes Selection sync
                                      if (dummyCategory.title == "العيون") {
                                        _syncEyesSelectionToCubit(
                                            context, index);
                                      }

                                      // Dental Selection sync
                                      if (dummyCategory.title == "الأسنان") {
                                        _syncDentalSelectionToCubit(
                                            context, index);
                                      }

                                      // Urgent Complaints Selection sync
                                      if (dummyCategory.title ==
                                          "الشكاوى الطارئة") {
                                        _syncUrgentComplaintsSelectionToCubit(
                                            context, index);
                                      }

                                      // Smart Nutrition Selection sync
                                      if (dummyCategory.title ==
                                          "المحلل الغذائي الذكي") {
                                        _syncSmartNutritionSelectionToCubit(
                                            context, index);
                                      }

                                      // Supplements Selection sync
                                      if (dummyCategory.title ==
                                          "المكملات الغذائية") {
                                        _syncSupplementsSelectionToCubit(
                                            context, index);
                                      }

                                      // Physical Activity Selection sync
                                      if (dummyCategory.title ==
                                          "النشاط الرياضي") {
                                        _syncPhysicalActivitySelectionToCubit(
                                            context, index, state);
                                      }

                                      // Mental Diseases Selection sync
                                      if (dummyCategory.title ==
                                          "الأمراض النفسية") {
                                        _syncMentalDiseasesSelectionToCubit(
                                            context, index);
                                      }
                                    },
                                  ),
                              ],
                            ],
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                  verticalSpacing(40),
                  GenerateButtonBlocConsumer(),
                  verticalSpacing(40),
                ],
              ),
            );
          },
        ),
        floatingActionButton: buildFloatingActionButtonBlocBuilder(),
      ),
    );
  }

  BlocBuilder<MedicalReportGenerationCubit, MedicalReportGenerationState>
      buildFloatingActionButtonBlocBuilder() {
    return BlocBuilder<MedicalReportGenerationCubit,
        MedicalReportGenerationState>(
      buildWhen: (previous, current) =>
          previous.generateReportStatus != current.generateReportStatus,
      builder: (context, state) {
        if (state.medicalReportData.isNotNull &&
            state.generateReportStatus == RequestStatus.success) {
          return FloatingActionButton.extended(
            onPressed: state.generateReportStatus == RequestStatus.loading
                ? null
                : () async {
                    final logic = MedicalReportExportLogic();
                    await logic.exportAndShareReport(
                        context, state.medicalReportData);
                  },
            backgroundColor: AppColorsManager.mainDarkBlue,
            icon: state.generateReportStatus == RequestStatus.loading
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : const Icon(Icons.picture_as_pdf, color: Colors.white),
            label: Text(
              state.generateReportStatus == RequestStatus.loading
                  ? 'Generating...'
                  : 'Export as PDF',
              style: const TextStyle(color: Colors.white),
            ),
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }

  void _syncBasicInfoSelectionToCubit(BuildContext context, int index) {
    final getAll =
        _selectedStates.isEmpty ? false : (_selectedStates[index] ?? false);
    context.read<MedicalReportGenerationCubit>().updateBasicInfoSelection(
          getAll: getAll,
          selectedValues: _selectedOptionValues[index]?.toList(),
        );
  }

  void _syncVitalSignsSelectionToCubit(BuildContext context, int index) {
    final getAll =
        _selectedStates.isEmpty ? false : (_selectedStates[index] ?? false);
    context.read<MedicalReportGenerationCubit>().updateVitalSignsInfoSelection(
          getAll: getAll,
          selectedValues: _selectedOptionValues[index]?.toList(),
        );
  }

  void _syncMedicineSelectionToCubit(BuildContext context, int index) {
    final getAll =
        _selectedStates.isEmpty ? false : (_selectedStates[index] ?? false);
    final filters = _selectedFilters[index] ?? {};
    context.read<MedicalReportGenerationCubit>().updateMedicineSelection(
          getAll: getAll,
          currentNames: filters["0_اسم الدواء"]?.toList() ?? [],
          expiredNames:
              (filters["1_اسم الدواء"] ?? filters["1_اسم الدواء_expired"])
                      ?.toList() ??
                  [],
        );
  }

  void _syncChronicDiseasesSelectionToCubit(BuildContext context, int index) {
    final getAll =
        _selectedStates.isEmpty ? false : (_selectedStates[index] ?? false);
    final filters = _selectedFilters[index] ?? {};
    context.read<MedicalReportGenerationCubit>().updateChronicDiseasesSelection(
          getAll: getAll,
          selectedValues: filters["0_المرض المزمن"]?.toList() ?? [],
        );
  }

  void _syncUrgentComplaintsSelectionToCubit(BuildContext context, int index) {
    final getAll =
        _selectedStates.isEmpty ? false : (_selectedStates[index] ?? false);
    final filters = _selectedFilters[index] ?? {};
    context
        .read<MedicalReportGenerationCubit>()
        .updateUrgentComplaintsSelection(
          attachImages:
              _selectedOptionValues[index]?.contains("ارفاق صورة الشكوي") ??
                  false,
          getAll: getAll,
          selectedYears: filters["0_السنة"]?.toList() ?? [],
          selectedOrgans: filters["0_العضو"]?.toList() ?? [],
          selectedComplaints: filters["0_الشكوى"]?.toList() ?? [],
          selectedOtherComplaints:
              filters["0_شكاوي إضافية أخرى"]?.toList() ?? [],
        );
  }

  void _syncRadiologySelectionToCubit(BuildContext context, int index) {
    final getAll =
        _selectedStates.isEmpty ? false : (_selectedStates[index] ?? false);
    final filters = _selectedFilters[index] ?? {};
    final attachImages =
        _selectedOptionValues[index]?.contains("ارفاق التقرير الطبي") ?? false;
    context.read<MedicalReportGenerationCubit>().updateRadiologySelection(
          getAll: getAll,
          attachImages: attachImages,
          selectedYears: filters["0_السنة"]?.toList() ?? [],
          selectedRegions: filters["0_منطقة الأشعة"]?.toList() ?? [],
          selectedTypes: filters["0_نوع الأشعة"]?.toList() ?? [],
        );
  }

  void _syncMedicalTestsSelectionToCubit(BuildContext context, int index) {
    final getAll =
        _selectedStates.isEmpty ? false : (_selectedStates[index] ?? false);
    final filters = _selectedFilters[index] ?? {};
    context.read<MedicalReportGenerationCubit>().updateMedicalTestsSelection(
          getAll: getAll,
          selectedYears: filters["0_السنة"]?.toList() ?? [],
          selectedTestGroups: filters["0_مجموعة التحاليل"]?.toList() ?? [],
        );
  }

  void _syncPrescriptionsSelectionToCubit(BuildContext context, int index) {
    final getAll =
        _selectedStates.isEmpty ? false : (_selectedStates[index] ?? false);
    final filters = _selectedFilters[index] ?? {};
    final attachImages =
        _selectedOptionValues[index]?.contains("ارفاق صور الروشتات") ?? false;
    context.read<MedicalReportGenerationCubit>().updatePrescriptionsSelection(
          getAll: getAll,
          attachImages: attachImages,
          selectedYears: filters["0_السنة"]?.toList() ?? [],
          selectedSpecialties: filters["0_التخصص"]?.toList() ?? [],
          selectedDoctorNames: filters["0_اسم الطبيب"]?.toList() ?? [],
        );
  }

  void _syncSurgeriesSelectionToCubit(BuildContext context, int index) {
    final getAll =
        _selectedStates.isEmpty ? false : (_selectedStates[index] ?? false);
    final filters = _selectedFilters[index] ?? {};
    final attachReport =
        _selectedOptionValues[index]?.contains("ارفاق التقرير الطبي") ?? false;
    context.read<MedicalReportGenerationCubit>().updateSurgeriesSelection(
          getAll: getAll,
          attachReport: attachReport,
          selectedYears: filters["0_السنة"]?.toList() ?? [],
          selectedSurgeryNames: filters["0_اسم العملية"]?.toList() ?? [],
        );
  }

  void _handleFilterMutualExclusion({
    required String categoryTitle,
    required String filterTitle,
    required String value,
    required Map<String, Set<String>> categoryFilters,
    required String currentKey,
  }) {
    // --- حالة الشكاوى الطارئة (عضو VS شكوى) ---
    if (categoryTitle == "الشكاوى الطارئة") {
      if (filterTitle == "الشكوى" &&
          !(categoryFilters[currentKey]?.contains(value) ?? false)) {
        if (categoryFilters["0_العضو"]?.isNotEmpty ?? false) {
          categoryFilters["0_العضو"] = {};
          _showAutoClearToast(
              context, "تم إلغاء اختيار 'العضو' لاختيار 'الشكوى'");
        }
      } else if (filterTitle == "العضو" &&
          !(categoryFilters[currentKey]?.contains(value) ?? false)) {
        if (categoryFilters["0_الشكوى"]?.isNotEmpty ?? false) {
          categoryFilters["0_الشكوى"] = {};
          _showAutoClearToast(
              context, "تم إلغاء اختيار 'الشكوى' لاختيار 'العضو'");
        }
      }
    }

    // --- حالة روشتة الأطباء (طبيب VS تخصص) ---
    if (categoryTitle == "روشتة الأطباء") {
      if (filterTitle == "اسم الطبيب" &&
          !(categoryFilters[currentKey]?.contains(value) ?? false)) {
        if (categoryFilters["0_التخصص"]?.isNotEmpty ?? false) {
          categoryFilters["0_التخصص"] = {};
          _showAutoClearToast(
              context, "تم إلغاء اختيار 'التخصص' لاختيار 'اسم الطبيب'");
        }
      } else if (filterTitle == "التخصص" &&
          !(categoryFilters[currentKey]?.contains(value) ?? false)) {
        if (categoryFilters["0_اسم الطبيب"]?.isNotEmpty ?? false) {
          categoryFilters["0_اسم الطبيب"] = {};
          _showAutoClearToast(
              context, "تم إلغاء اختيار 'اسم الطبيب' لاختيار 'التخصص'");
        }
      }
    }
    // --- حالة الأشعة (منطقة الأشعة VS نوع الأشعة) ---
    if (categoryTitle == "الأشعة") {
      if (filterTitle == "نوع الأشعة" &&
          !(categoryFilters[currentKey]?.contains(value) ?? false)) {
        // إذا اختار نوع الأشعة، امسح منطقة الأشعة
        if (categoryFilters["0_منطقة الأشعة"]?.isNotEmpty ?? false) {
          categoryFilters["0_منطقة الأشعة"] = {};
          _showAutoClearToast(
              context, "تم إلغاء اختيار 'منطقة الأشعة' لاختيار 'نوع الأشعة'");
        }
      } else if (filterTitle == "منطقة الأشعة" &&
          !(categoryFilters[currentKey]?.contains(value) ?? false)) {
        // إذا اختار منطقة الأشعة، امسح نوع الأشعة
        if (categoryFilters["0_نوع الأشعة"]?.isNotEmpty ?? false) {
          categoryFilters["0_نوع الأشعة"] = {};
          _showAutoClearToast(
              context, "تم إلغاء اختيار 'نوع الأشعة' لاختيار 'منطقة الأشعة'");
        }
      }
    }
    // --- حالة العيون (المنطقه VS الأعراض) ---
    if (categoryTitle == "العيون") {
      if (filterTitle == "الأعراض" &&
          !(categoryFilters[currentKey]?.contains(value) ?? false)) {
        // إذا اختار الأعراض، امسح المنطقه
        if (categoryFilters["0_المنطقه"]?.isNotEmpty ?? false) {
          categoryFilters["0_المنطقه"] = {};
          _showAutoClearToast(
              context, "تم إلغاء اختيار 'المنطقه' لاختيار 'الأعراض'");
        }
      } else if (filterTitle == "المنطقه" &&
          !(categoryFilters[currentKey]?.contains(value) ?? false)) {
        // إذا اختار المنطقه، امسح الأعراض
        if (categoryFilters["0_الأعراض"]?.isNotEmpty ?? false) {
          categoryFilters["0_الأعراض"] = {};
          _showAutoClearToast(
              context, "تم إلغاء اختيار 'الأعراض' لاختيار 'المنطقه'");
        }
      }
    }
  }

  void _syncGeneticDiseasesSelectionToCubit(BuildContext context, int index) {
    final getAll =
        _selectedStates.isEmpty ? false : (_selectedStates[index] ?? false);
    final filters = _selectedFilters[index] ?? {};
    context.read<MedicalReportGenerationCubit>().updateGeneticDiseasesSelection(
          getAll: getAll,
          expectedGeneticDiseasesSelectedValues:
              filters["0_أمراضي الوراثية المتوقعة"]?.toList() ?? [],
          familyDiseasesSelectedValues:
              filters["0_امراض العائلة الوراثية"]?.toList() ?? [],
        );
  }

  void _syncAllergiesSelectionToCubit(BuildContext context, int index) {
    final getAll =
        _selectedStates.isEmpty ? false : (_selectedStates[index] ?? false);
    final filters = _selectedFilters[index] ?? {};
    context.read<MedicalReportGenerationCubit>().updateAllergiesSelection(
          getAll: getAll,
          selectedTypes: filters["0_النوع"]?.toList() ?? [],
        );
  }

  void _syncEyesSelectionToCubit(BuildContext context, int index) {
    final getAll =
        _selectedStates.isEmpty ? false : (_selectedStates[index] ?? false);
    final filters = _selectedFilters[index] ?? {};
    final attachReport =
        _selectedOptionValues[index]?.contains("ارفاق التقرير الطبي") ?? false;
    final attachMedicalTests =
        _selectedOptionValues[index]?.contains("ارفاق الفحوصات الطبية") ??
            false;
    context.read<MedicalReportGenerationCubit>().updateEyesSelection(
          getAll: getAll,
          attachReport: attachReport,
          attachMedicalTests: attachMedicalTests,
          selectedYears: filters["0_السنة"]?.toList() ?? [],
          selectedRegions: filters["0_المنطقه"]?.toList() ?? [],
          selectedSymptoms: filters["0_الأعراض"]?.toList() ?? [],
          selectedMedicalProcedures: filters["0_الإجراء الطبي"]?.toList() ?? [],
        );
  }

  void _syncDentalSelectionToCubit(BuildContext context, int index) {
    final getAll =
        _selectedStates.isEmpty ? false : (_selectedStates[index] ?? false);
    final filters = _selectedFilters[index] ?? {};
    final attachReport =
        _selectedOptionValues[index]?.contains("ارفاق التقرير الطبي") ?? false;
    context.read<MedicalReportGenerationCubit>().updateDentalSelection(
          getAll: getAll,
          attachReport: attachReport,
          selectedYears: filters["0_السنة"]?.toList() ?? [],
          selectedTeethNumbers: filters["0_رقم السن"]?.toList() ?? [],
          selectedComplaints: filters["0_الشكوى"]?.toList() ?? [],
          selectedMedicalProcedures: filters["0_الإجراء الطبي"]?.toList() ?? [],
        );
  }

  void _syncSmartNutritionSelectionToCubit(BuildContext context, int index) {
    final getAll =
        _selectedStates.isEmpty ? false : (_selectedStates[index] ?? false);
    final filters = _selectedFilters[index] ?? {};
    context.read<MedicalReportGenerationCubit>().updateSmartNutritionSelection(
          getAll: getAll,
          selectedReports: filters["0_تقرير المتابعة الغذائيه"]?.toList() ?? [],
        );
  }

  void _syncSupplementsSelectionToCubit(BuildContext context, int index) {
    final getAll =
        _selectedStates.isEmpty ? false : (_selectedStates[index] ?? false);
    final filters = _selectedFilters[index] ?? {};
    context.read<MedicalReportGenerationCubit>().updateSupplementsSelection(
          getAll: getAll,
          selectedYears: filters["0_السنة"]?.toList() ?? [],
          selectedNames:
              filters["0_اسم الفيتامين أو المكمل الغذائي"]?.toList() ?? [],
        );
  }

  void _syncPhysicalActivitySelectionToCubit(
      BuildContext context, int index, MedicalReportGenerationState state) {
    final getAll = _selectedStates[index] ?? false;
    final filters = _selectedFilters[index] ?? {};
    final selectedReports =
        filters["0_تقرير المتابعة الرياضية"]?.toList() ?? [];

    context
        .read<MedicalReportGenerationCubit>()
        .updatePhysicalActivitySelection(
          getAll: getAll,
          selectedReports: selectedReports,
        );
  }

  void _syncMentalDiseasesSelectionToCubit(BuildContext context, int index) {
    final getAll =
        _selectedStates.isEmpty ? false : (_selectedStates[index] ?? false);
    final filters = _selectedFilters[index] ?? {};
    context.read<MedicalReportGenerationCubit>().updateMentalDiseasesSelection(
          getAll: getAll,
          selectedTypes: filters["0_نوع المرض النفسي"]?.toList() ?? [],
          selectedMethods:
              filters["0_المحاور النفسية و السلوكية"]?.toList() ?? [],
        );
  }
}

void _showAutoClearToast(BuildContext context, String message) {
  ScaffoldMessenger.of(context).clearSnackBars(); // يمسح أي رسالة قديمة فوراً
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message, style: TextStyle(fontSize: 14.sp)),
      duration: const Duration(milliseconds: 1500), // تظهر وتختفي بسرعة
      backgroundColor: AppColorsManager.mainDarkBlue.withAlpha(200),
    ),
  );
}
