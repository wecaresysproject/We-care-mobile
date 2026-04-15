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
            final String? selectedDate = selectedFilters['التاريخ'];
            context
                .read<QualityOfLifeCubit>()
                .fetchAnsweredQuestions(dateRange: selectedDate);
          },
          filters: [
            FilterConfig(
              title: 'التاريخ',
              options: state.userSubmissionDates,
              isYearFilter: false,
            ),
          ],
        );
      },
    );
  }
}
