import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/custom_app_bar_with_centered_title_widget.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/my_medical_reports/data/models/medical_category_model.dart';
import 'package:we_care/features/my_medical_reports/data/models/medical_report_categories_data.dart';
import 'package:we_care/features/my_medical_reports/logic/medical_report_export_logic.dart';
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
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
      ),
      body: SingleChildScrollView(
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
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: categoriesView.length,
              separatorBuilder: (context, index) => verticalSpacing(12),
              itemBuilder: (context, index) {
                final category = categoriesView[index];
                final isExpanded = _expandedStates[index] ?? false;
                final isSelected = _selectedStates[index] ?? false;

                return Column(
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
                      },
                      onCheckboxToggle: () {
                        setState(() {
                          _selectedStates[index] = !isSelected;
                        });
                      },
                    ),
                    if (isExpanded) ...[
                      if (category.selectionType ==
                              MedicalSelectionType.selection ||
                          category.selectionType ==
                              MedicalSelectionType.selectionAndFilters)
                        MedicalCategorySelectionWidget(
                          options: category.radioOptions,
                          selectedValues: _selectedOptionValues[index] ?? {},
                          onChanged: (value, isSelected) {
                            setState(() {
                              final currentSelected =
                                  _selectedOptionValues[index] ?? {};
                              if (isSelected) {
                                currentSelected.add(value);
                              } else {
                                currentSelected.remove(value);
                              }
                              _selectedOptionValues[index] = currentSelected;
                            });
                          },
                        ),
                      if (category.selectionType ==
                              MedicalSelectionType.filters ||
                          category.selectionType ==
                              MedicalSelectionType.selectionAndFilters)
                        CategoryFiltersWidget(
                          filterSections: category.filterSections!,
                          selectedFilters: _selectedFilters[index] ?? {},
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
                              categoryFilters[filterTitle] = selectedValues;
                              _selectedFilters[index] = categoryFilters;
                            });
                          },
                        ),
                    ],
                  ],
                );
              },
            ),
            verticalSpacing(20),
          ],
        ),
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
    );
  }
}
