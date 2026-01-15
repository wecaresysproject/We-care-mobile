import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_care/core/global/Helpers/app_toasts.dart';
import 'package:we_care/features/physical_activaty/physical_activaty_view/logic/physical_activaty_view_cubit.dart';
import 'package:we_care/features/x_ray/x_ray_view/Presentation/views/widgets/x_ray_data_filters_row.dart';

class FiltersRowBlocBuilder extends StatelessWidget {
  const FiltersRowBlocBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PhysicalActivityViewCubit, PhysicalActivatyViewState>(
      buildWhen: (previous, current) =>
          previous.availableYears != current.availableYears ||
          previous.availableDates != current.availableDates,
      builder: (context, state) {
        return DataViewFiltersRow(
          onFilterSelected: (filterTitle, selectedVal) {
            if (filterTitle == "السنة") {
              context
                  .read<PhysicalActivityViewCubit>()
                  .getAvailableDatesBasedOnYear(selectedVal);
            }
          },
          filters: [
            FilterConfig(
              title: 'السنة',
              options: state.availableYears,
              isYearFilter: true,
            ),
            FilterConfig(
              title: 'التاريخ',
              options: state.availableDates,
              isYearFilter: false,
            ),
          ],
          onApply: (selectedOption) async {
            if (selectedOption.isNotEmpty &&
                selectedOption.containsKey("التاريخ") &&
                selectedOption.containsKey("السنة") &&
                selectedOption["التاريخ"].toString().isNotEmpty &&
                selectedOption["السنة"].toString().isNotEmpty) {
              await context
                  .read<PhysicalActivityViewCubit>()
                  .getFilterdDocuments(
                    date: selectedOption["التاريخ"].toString(),
                    year: selectedOption["السنة"].toString(),
                  );
            } else {
              await showError("اختر السنة والتاريخ اولا من فضلك");
            }
          },
        );
      },
    );
  }
}
