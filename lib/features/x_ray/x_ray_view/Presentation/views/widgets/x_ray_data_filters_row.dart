import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/x_ray/x_ray_view/Presentation/views/widgets/search_filter_widget.dart';

class DataViewFiltersRow extends StatefulWidget {
  final List<FilterConfig> filters;
  final Function(dynamic) onApply;

  const DataViewFiltersRow({
    super.key,
    required this.filters,
    required this.onApply,
  });

  @override
  DataViewFiltersRowState createState() => DataViewFiltersRowState();
}

class DataViewFiltersRowState extends State<DataViewFiltersRow> {
  final Map<String, dynamic> selectedFilters = {};

  void onFilterSelected(String filterTitle, dynamic selectedValue) {
    setState(() {
      selectedFilters[filterTitle] = selectedValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var filter in widget.filters) ...[
          SearchFilterWidget(
            filterTitle: filter.title,
            filterList: filter.options,
            isYearFilter: filter.isYearFilter,
            onFilterSelected: onFilterSelected,
            isMedicineFilter: filter.isMedicineFilter,
          ),
          if (filter != widget.filters.last) Spacer(flex: 1),
        ],
        Spacer(flex: 4),
        FilterButton(
          title: 'عرض',
          onTap: (selectedFilters) => widget.onApply(selectedFilters),
          selectedFilters: selectedFilters,
        ),
      ],
    );
  }
}

class FilterConfig {
  final String title;
  final List<dynamic> options;
  final bool isYearFilter;
  final bool isMedicineFilter;

  FilterConfig({
    required this.title,
    required this.options,
    this.isYearFilter = false,
    this.isMedicineFilter = false,
  });
}

class FilterButton extends StatelessWidget {
  final String title;
  final Function(dynamic) onTap;
  final Map<String, dynamic> selectedFilters;

  const FilterButton(
      {super.key,
      required this.title,
      required this.onTap,
      required this.selectedFilters});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(selectedFilters),
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
