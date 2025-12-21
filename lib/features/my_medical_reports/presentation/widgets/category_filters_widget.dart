import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';

class CategoryFiltersWidget extends StatelessWidget {
  final List<Map<String, dynamic>> filters;
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
          final String title = filter['title'] ?? "";
          final List<String> values = List<String>.from(filter['values'] ?? []);
          final bool isLast = filters.last == filter;

          return Padding(
            padding: EdgeInsets.only(bottom: isLast ? 0 : 16.h),
            child: _FilterSection(
              title: title,
              values: values,
              selectedValues: selectedFilters[title] ?? {},
              onToggle: (value) => onFilterToggle(title, value),
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
            child: GridView.builder(
              controller: _scrollController,
              shrinkWrap: true,
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: widget.values.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 8.h,
                crossAxisSpacing: 8.w,
                childAspectRatio: 2.5,
              ),
              itemBuilder: (context, index) {
                final value = widget.values[index];
                final isSelected = widget.selectedValues.contains(value);
                return _buildFilterChip(
                  value,
                  isSelected,
                  () => widget.onToggle(value),
                );
              },
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
        alignment: Alignment.center,
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isSelected) ...[
              Icon(Icons.check,
                  size: 14.sp, color: AppColorsManager.mainDarkBlue),
              horizontalSpacing(4),
            ],
            Expanded(
              child: Text(
                label,
                style: AppTextStyles.font14BlackMedium.copyWith(
                  fontSize: 12.sp,
                  color:
                      isSelected ? AppColorsManager.mainDarkBlue : Colors.black,
                ),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
