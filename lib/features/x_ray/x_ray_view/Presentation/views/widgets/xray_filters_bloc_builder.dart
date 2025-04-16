

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_care/features/x_ray/x_ray_view/Presentation/views/widgets/x_ray_data_filters_row.dart';
import 'package:we_care/features/x_ray/x_ray_view/logic/x_ray_view_cubit.dart';
import 'package:we_care/features/x_ray/x_ray_view/logic/x_ray_view_state.dart';

class XrayFiltersBlocBuilder extends StatelessWidget {
  const XrayFiltersBlocBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    return         BlocBuilder<XRayViewCubit, XRayViewState>(
                  buildWhen: (previous, current) => previous.xrayTypeFilter!=current.xrayTypeFilter||previous.yearsFilter!=current.yearsFilter||previous.bodyPartFilter!=current.bodyPartFilter,
                  builder: (context, state) {
                    return DataViewFiltersRow(
                      filters: [
                        FilterConfig(
                            title: 'السنة',
                            options: state.yearsFilter,
                            isYearFilter: true),
                        FilterConfig(
                            title: 'نوع الاشعة', options: state.xrayTypeFilter),
                        FilterConfig(
                            title: ' منطفة الاشعة',
                            options: state.bodyPartFilter),
                      ],
                      onApply: (selectedFilters) {
                        print(
                            "Selected Filters: $selectedFilters"); // Access selected filters
                        BlocProvider.of<XRayViewCubit>(context)
                            .emitFilteredData(
                                selectedFilters['السنة'].toString(),
                                selectedFilters['نوع الاشعة'],
                                selectedFilters[' منطفة الاشعة']);
                      },
                    );
                  },
                );
  }
}