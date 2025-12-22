import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';

import 'package:we_care/features/my_medical_reports/data/models/medical_category_model.dart';

class CategoryFiltersWidget extends StatelessWidget {
  final List<MedicalFilterModel> filters;
  final Map<String, Set<String>> selectedFilters;
  final Function(String, String) onFilterToggle;

  const CategoryFiltersWidget({
    super.key,
    required this.filters,
    required this.selectedFilters,
    required this.onFilterToggle,
  });

  @override
  Widget build(BuildContext context) {
    if (filters.isEmpty) return const SizedBox.shrink();

    return Container(
      margin: EdgeInsets.only(top: 4.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppColorsManager.secondaryColor.withOpacity(0.3),
        border:
            Border.all(color: AppColorsManager.mainDarkBlue.withOpacity(0.5)),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: filters.map((filter) {
          final String title = filter.title;
          final String displayTitle = filter.displayTitle ?? title;
          final String? sectionTitle = filter.sectionTitle;
          final List<String> values = filter.values;
          final bool isLast = filters.last == filter;

          return Padding(
            padding: EdgeInsets.only(bottom: isLast ? 0 : 16.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (sectionTitle != null) ...[
                  Text(
                    sectionTitle,
                    style: AppTextStyles.font16BlackSemiBold.copyWith(
                      color: AppColorsManager.mainDarkBlue,
                      fontSize: 14.sp,
                    ),
                  ),
                  verticalSpacing(12),
                ],
                _FilterSection(
                  title: displayTitle,
                  values: values,
                  selectedValues: selectedFilters[title] ?? {},
                  onToggle: (value) => onFilterToggle(title, value),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _FilterSection extends StatefulWidget {
  final String title;
  final List<String> values;
  final Set<String> selectedValues;
  final ValueChanged<String> onToggle;

  const _FilterSection({
    required this.title,
    required this.values,
    required this.selectedValues,
    required this.onToggle,
  });

  @override
  State<_FilterSection> createState() => _FilterSectionState();
}

class _FilterSectionState extends State<_FilterSection> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(widget.title),
        verticalSpacing(8),
        ConstrainedBox(
          constraints: BoxConstraints(maxHeight: 120.h),
          child: Scrollbar(
            controller: _scrollController,
            thumbVisibility: true,
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Wrap(
                spacing: 8.w,
                runSpacing: 8.h,
                children: widget.values.map((value) {
                  final isSelected = widget.selectedValues.contains(value);
                  return _buildFilterChip(
                    value,
                    isSelected,
                    () => widget.onToggle(value),
                  );
                }).toList(),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(String title) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 6.h),
      decoration: BoxDecoration(
        color: AppColorsManager.secondaryColor.withOpacity(0.6),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Text(
        title,
        style: AppTextStyles.font16BlackSemiBold.copyWith(
          color: AppColorsManager.mainDarkBlue,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: isSelected
                ? AppColorsManager.mainDarkBlue
                : Colors.grey.shade300,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isSelected) ...[
              Icon(Icons.check,
                  size: 14.sp, color: AppColorsManager.mainDarkBlue),
              horizontalSpacing(4),
            ],
            Flexible(
              child: Text(
                label,
                style: AppTextStyles.font14BlackMedium.copyWith(
                  fontSize: 12.sp,
                  color:
                      isSelected ? AppColorsManager.mainDarkBlue : Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
