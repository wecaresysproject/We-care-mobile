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
      builder: (context, state) {
        if (state.medicalReportData.isNotNull &&
            state.status == RequestStatus.success) {
          return FloatingActionButton.extended(
            onPressed: state.status == RequestStatus.loading
                ? null
                : () async {
                    final logic = MedicalReportExportLogic();
                    await logic.exportAndShareReport(context);
                  },
            backgroundColor: AppColorsManager.mainDarkBlue,
            icon: state.status == RequestStatus.loading
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
              state.status == RequestStatus.loading
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
    final getAll = _selectedOptionValues[index]?.contains("الجميع") ?? false;
    context.read<MedicalReportGenerationCubit>().updateBasicInfoSelection(
          getAll: getAll,
          selectedValues: _selectedOptionValues[index]?.toList(),
        );
  }

  void _syncVitalSignsSelectionToCubit(BuildContext context, int index) {
    final getAll = _selectedOptionValues[index]?.contains("الجميع") ?? false;
    context.read<MedicalReportGenerationCubit>().updateVitalSignsInfoSelection(
          getAll: getAll,
          selectedValues: _selectedOptionValues[index]?.toList(),
        );
  }

  void _syncMedicineSelectionToCubit(BuildContext context, int index) {
    final filters = _selectedFilters[index] ?? {};
    context.read<MedicalReportGenerationCubit>().updateMedicineSelection(
          getAll: _selectedStates[index] ?? false,
          currentNames: filters["0_اسم الدواء"]?.toList() ?? [],
          expiredNames:
              (filters["1_اسم الدواء"] ?? filters["1_اسم الدواء_expired"])
                      ?.toList() ??
                  [],
        );
  }

  void _syncChronicDiseasesSelectionToCubit(BuildContext context, int index) {
    final filters = _selectedFilters[index] ?? {};
    context.read<MedicalReportGenerationCubit>().updateChronicDiseasesSelection(
          getAll: _selectedStates[index] ?? false,
          selectedValues: filters["0_المرض المزمن"]?.toList() ?? [],
        );
  }

  void _syncUrgentComplaintsSelectionToCubit(BuildContext context, int index) {
    final filters = _selectedFilters[index] ?? {};
    context
        .read<MedicalReportGenerationCubit>()
        .updateUrgentComplaintsSelection(
          getAll: _selectedStates[index] ?? false,
          selectedYears: filters["0_السنة"]?.toList() ?? [],
          selectedOrgans: filters["0_العضو"]?.toList() ?? [],
          selectedComplaints: filters["0_الشكوى"]?.toList() ?? [],
        );
  }

  void _syncRadiologySelectionToCubit(BuildContext context, int index) {
    final filters = _selectedFilters[index] ?? {};
    final attachImages =
        _selectedOptionValues[index]?.contains("ارفاق صور الاشعة") ?? false;
    context.read<MedicalReportGenerationCubit>().updateRadiologySelection(
          getAll: _selectedStates[index] ?? false,
          attachImages: attachImages,
          selectedYears: filters["0_السنة"]?.toList() ?? [],
          selectedRegions: filters["0_منطقة الأشعة"]?.toList() ?? [],
          selectedTypes: filters["0_نوع الأشعة"]?.toList() ?? [],
        );
  }
}
