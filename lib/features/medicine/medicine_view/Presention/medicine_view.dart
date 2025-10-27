import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_care/core/di/dependency_injection.dart';
import 'package:we_care/core/global/Helpers/app_logger.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/features/medicine/medicine_view/logic/medicine_view_cubit.dart';
import 'package:we_care/features/medicine/medicine_view/logic/medicine_view_state.dart';
import 'package:we_care/features/medicine/medicine_view/widgets/medicine_table.dart';
import 'package:we_care/features/medicine/medicine_view/widgets/medicine_view_footer_row.dart';
import 'package:we_care/features/x_ray/x_ray_view/Presentation/views/widgets/x_ray_data_filters_row.dart';
import 'package:we_care/features/x_ray/x_ray_view/Presentation/views/widgets/x_ray_data_view_app_bar.dart';

class MedicinesView extends StatelessWidget {
  const MedicinesView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<MedicineViewCubit>(
      create: (context) => getIt<MedicineViewCubit>()..init(),
      child: RefreshIndicator(
        onRefresh: () async {
          BlocProvider.of<MedicineViewCubit>(context).init();
        },
        triggerMode: RefreshIndicatorTriggerMode.anywhere,
        child: Scaffold(
          appBar: AppBar(
            toolbarHeight: 0,
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              children: [
                ViewAppBar(),
                BlocBuilder<MedicineViewCubit, MedicineViewState>(
                  buildWhen: (previous, current) =>
                      previous.yearsFilter != current.yearsFilter ||
                      previous.medicineNameFilter != current.medicineNameFilter,
                  builder: (context, state) {
                    return DataViewFiltersRow(
                      filters: [
                        FilterConfig(
                            title: 'السنة',
                            options: state.yearsFilter,
                            isYearFilter: true),
                        FilterConfig(
                            title: 'اسم الدواء',
                            options: state.medicineNameFilter,
                            isMedicineFilter: true),
                      ],
                      onApply: (selectedFilters) {
                        AppLogger.debug("Selected Filters: $selectedFilters");
                        BlocProvider.of<MedicineViewCubit>(context)
                            .getFilteredMedicinesList(
                                year: selectedFilters['السنة'],
                                medicineName:
                                    selectedFilters['اسم الدواء'].toString());
                      },
                    );
                  },
                ),
                verticalSpacing(24),
                Text(
                  "“اضغط على اسم الدواء لعرض تفاصيله”",
                  style: AppTextStyles.customTextStyle,
                  textAlign: TextAlign.center,
                ),
                verticalSpacing(16),
                Text(
              "“اضغط على التاريخ لعرض جميع الادوية في ذلك التاريخ”",
                  style: AppTextStyles.customTextStyle,
                  textAlign: TextAlign.center,
                ),
                verticalSpacing(16),
                Expanded(flex: 9, child: MedicineTable()),
                verticalSpacing(16),
                MedicineViewFooterRow(),
                Spacer(
                  flex: 1,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
