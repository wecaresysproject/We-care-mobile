import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/x_ray/x_ray_view/Presentation/views/widgets/search_filter_widget.dart';

class DataViewFiltersRow extends StatelessWidget {
  final List<FilterConfig> filters;
  final VoidCallback onApply;

  const DataViewFiltersRow({
    super.key,
    required this.filters,
    required this.onApply,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var filter in filters) ...[
          SearchFilterWidget(
            filterTitle: filter.title,
            filterList: filter.options,
            isYearFilter: filter.isYearFilter,
          ),
          if (filter != filters.last)
            Spacer(
              flex: 1,
            ),
        ],
        Spacer(
          flex: 4,
        ),
        FilterButton(title: 'عرض', onTap: onApply),
      ],
    );
  }
}

class FilterConfig {
  final String title;
  final List<String> options;
  final bool isYearFilter;

  FilterConfig({
    required this.title,
    required this.options,
    this.isYearFilter = false,
  });
}

class FilterButton extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const FilterButton({super.key, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        width: 58.w,
        height: 40.h,
        padding: EdgeInsets.only(top: 8.h, bottom: 10.h),
        decoration: BoxDecoration(
          color: AppColorsManager.mainDarkBlue,
          borderRadius: BorderRadius.circular(12.r),
        ),
        alignment: Alignment.center,
        child: Text(
          title,
          style: AppTextStyles.font22WhiteWeight600.copyWith(fontSize: 14),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
