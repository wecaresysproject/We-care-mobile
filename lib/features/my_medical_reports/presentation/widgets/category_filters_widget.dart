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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: filters.map((filter) {
          final String title = filter['title'] ?? "";
          final List<String> values = List<String>.from(filter['values'] ?? []);
          final bool isLast = filters.last == filter;

          return Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: isLast ? 0 : 12.w),
              child: Column(
                children: [
                  _buildHeader(title),
                  verticalSpacing(8),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: values.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: title == "السنة" ? 3 : 2,
                      mainAxisSpacing: 8.h,
                      crossAxisSpacing: 8.w,
                      childAspectRatio: title == "السنة" ? 1.8 : 2.2,
                    ),
                    itemBuilder: (context, index) {
                      final value = values[index];
                      final isSelected =
                          (selectedFilters[title] ?? {}).contains(value);
                      return _buildFilterChip(
                          value, isSelected, () => onFilterToggle(title, value));
                    },
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
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
            Text(
              label,
              style: AppTextStyles.font14BlackMedium.copyWith(
                fontSize: 12.sp,
                color:
                    isSelected ? AppColorsManager.mainDarkBlue : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
