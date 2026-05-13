import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_care/features/quality_of_life/logic/quality_of_life_cubit.dart';
import 'package:we_care/features/quality_of_life/logic/quality_of_life_state.dart';
import 'package:we_care/features/x_ray/x_ray_view/Presentation/views/widgets/x_ray_data_filters_row.dart';

class QualityOfLifeFiltersRow extends StatelessWidget {
  const QualityOfLifeFiltersRow({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QualityOfLifeCubit, QualityOfLifeState>(
      buildWhen: (previous, current) =>
          current.userSubmissionDates != previous.userSubmissionDates,
      builder: (context, state) {
        return DataViewFiltersRow(
          onApply: (selectedFilters) {
            final String? selectedDate = selectedFilters['التاريخ من'];
            final String? selectedDateTo = selectedFilters['التاريخ الى'];
            context.read<QualityOfLifeCubit>().fetchAnsweredQuestions(
                  dateFrom: selectedDate,
                  dateTo: selectedDateTo,
                );
          },
          filters: [
            FilterConfig(
              title: 'التاريخ من',
              options: state.userSubmissionDates,
              isYearFilter: false,
            ),
            FilterConfig(
              title: 'التاريخ الى',
              options: state.userSubmissionDates,
              isYearFilter: false,
            ),
          ],
        );
      },
    );
  }
}
