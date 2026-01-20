import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/di/dependency_injection.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/app_custom_button.dart';
import 'package:we_care/core/global/SharedWidgets/custom_app_bar_with_centered_title_widget.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/my_medical_reports/data/models/medical_category_model.dart';
import 'package:we_care/features/my_medical_reports/data/models/medical_report_categories_data.dart';
import 'package:we_care/features/my_medical_reports/logic/medical_report_export_logic.dart';
import 'package:we_care/features/my_medical_reports/logic/medical_report_generation_cubit.dart';
import 'package:we_care/features/my_medical_reports/presentation/widgets/category_filters_widget.dart';
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

  bool _isExporting = false;

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
                                        final getAll =
                                            _selectedOptionValues[index]
                                                    ?.contains("الجميع") ??
                                                false;
                                        context
                                            .read<
                                                MedicalReportGenerationCubit>()
                                            .updateBasicInfoSelection(
                                              getAll: getAll,
                                              selectedValues:
                                                  _selectedOptionValues[index]
                                                      ?.toList(),
                                            );
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
                                    onFilterToggle: (filterTitle, value) {
                                      setState(() {
                                        final categoryFilters =
                                            _selectedFilters[index] ?? {};
                                        final selectedValues =
                                            categoryFilters[filterTitle] ?? {};
                                        if (selectedValues.contains(value)) {
                                          selectedValues.remove(value);
                                        } else {
                                          selectedValues.add(value);
                                        }
                                        categoryFilters[filterTitle] =
                                            selectedValues;
                                        _selectedFilters[index] =
                                            categoryFilters;
                                      });
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
                  BlocConsumer<MedicalReportGenerationCubit,
                      MedicalReportGenerationState>(
                    listener: (context, state) {
                      if (state.status == RequestStatus.success) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Report generated successfully'),
                            backgroundColor: Colors.green,
                          ),
                        );
                      } else if (state.status == RequestStatus.failure) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(state.message.isNotEmpty
                                ? state.message
                                : 'Unknown error'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                    builder: (context, state) {
                      return AppCustomButton(
                        title: 'Generate Report',
                        isEnabled: true,
                        onPressed: () {
                          context
                              .read<MedicalReportGenerationCubit>()
                              .emitGenerateReport('ar');
                        },
                        isLoading: state.status == RequestStatus.loading,
                      );
                    },
                  ),
                  verticalSpacing(40),
                ],
              ),
            );
          },
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: _isExporting
              ? null
              : () async {
                  setState(() {
                    _isExporting = true;
                  });

                  final logic = MedicalReportExportLogic();
                  await logic.exportAndShareReport(context);

                  if (mounted) {
                    setState(() {
                      _isExporting = false;
                    });
                  }
                },
          backgroundColor: AppColorsManager.mainDarkBlue,
          icon: _isExporting
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
            _isExporting ? 'Generating...' : 'Export as PDF',
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
