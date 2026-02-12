import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/my_medical_reports/data/models/medical_category_model.dart';

class CategoryFiltersWidget extends StatelessWidget {
  final List<MedicalFilterSectionModel> filterSections;
  final Map<String, Set<String>> selectedFilters;
  final Function(int sectionIndex, String filterTitle, String value)
      onFilterToggle;

  const CategoryFiltersWidget({
    super.key,
    required this.filterSections,
    required this.selectedFilters,
    required this.onFilterToggle,
  });

  @override
  Widget build(BuildContext context) {
    if (filterSections.isEmpty) return const SizedBox.shrink();

    return Container(
      margin: EdgeInsets.only(top: 4.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppColorsManager.secondaryColor.withAlpha((0.3 * 255).toInt()),
        border: Border.all(
            color:
                AppColorsManager.mainDarkBlue.withAlpha((0.5 * 255).toInt())),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: filterSections.map((section) {
          final String? sectionTitle = section.title;
          final List<MedicalFilterModel> filters = section.filters;

          return Column(
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
              ...filters.map((filter) {
                final String title = filter.title;
                final String displayTitle = filter.displayTitle ?? title;
                final List<String> values = filter.values;
                final int sectionIndex = filterSections.indexOf(section);
                final bool isLast =
                    filterSections.last == section && filters.last == filter;

                return Padding(
                  padding: EdgeInsets.only(bottom: isLast ? 0 : 16.h),
                  child: _FilterSection(
                    title: displayTitle,
                    values: values,
                    selectedValues:
                        selectedFilters["${sectionIndex}_$title"] ?? {},
                    onToggle: (value) =>
                        onFilterToggle(sectionIndex, title, value),
                  ),
                );
              }),
            ],
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
  @override
  Widget build(BuildContext context) {
    final bool isAllSelected = widget.values.isNotEmpty &&
        widget.selectedValues.length == widget.values.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(widget.title, isAllSelected),
        verticalSpacing(8),
        Wrap(
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
      ],
    );
  }

  void _handleToggleAll(bool allSelected) {
    if (allSelected) {
      // Unselect all: toggle those that are currently selected
      // Use .toList() to avoid ConcurrentModificationError as we are modifying the set during iteration
      for (final value in widget.selectedValues.toList()) {
        widget.onToggle(value);
      }
    } else {
      // Select all: toggle those that are NOT currently selected
      for (final value in widget.values) {
        if (!widget.selectedValues.contains(value)) {
          widget.onToggle(value);
        }
      }
    }
  }

  Widget _buildHeader(String title, bool isAllSelected) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 12.w),
      decoration: BoxDecoration(
        color: AppColorsManager.secondaryColor.withAlpha((0.6 * 255).toInt()),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: AppTextStyles.font16BlackSemiBold.copyWith(
                color: AppColorsManager.mainDarkBlue,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          GestureDetector(
            onTap: () => _handleToggleAll(isAllSelected),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "الكل",
                  style: AppTextStyles.font14BlackMedium.copyWith(
                    color: AppColorsManager.mainDarkBlue,
                    fontSize: 12.sp,
                  ),
                ),
                horizontalSpacing(6),
                Container(
                  width: 20.w,
                  height: 20.h,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: isAllSelected
                          ? AppColorsManager.mainDarkBlue
                          : Colors.grey,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(4.r),
                    color: isAllSelected
                        ? AppColorsManager.mainDarkBlue
                        : Colors.white,
                  ),
                  child: isAllSelected
                      ? Icon(
                          Icons.check,
                          size: 14.sp,
                          color: Colors.white,
                        )
                      : null,
                ),
              ],
            ),
          ),
        ],
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
