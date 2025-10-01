import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_care/core/di/dependency_injection.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/user_selection_container_shared_widget.dart';
import 'package:we_care/features/allergy/allergy_data_entry_view/logic/cubit/allergy_data_entry_cubit.dart';
import 'package:we_care/features/medicine/medicines_data_entry/Presentation/views/widgets/medicine_name_scanner_container.dart';
import 'package:we_care/features/medicine/medicines_data_entry/logic/cubit/medicines_data_entry_cubit.dart';
import 'package:we_care/features/medicine/medicines_data_entry/logic/cubit/medicines_data_entry_state.dart';

class MedicineNameSelectorSection extends StatelessWidget {
  const MedicineNameSelectorSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<MedicinesDataEntryCubit>(
      create: (_) => getIt<MedicinesDataEntryCubit>()..emitAllMedicinesNames(),
      child: BlocBuilder<MedicinesDataEntryCubit, MedicinesDataEntryState>(
        builder: (context, state) {
          return Column(
            children: [
              UserSelectionContainer(
                categoryLabel: "اسم الدواء",
                containerHintText:
                    state.selectedMedicineName ?? "اختر اسم الدواء",
                options: state.medicinesNames,
                onOptionSelected: (value) async {
                  await context
                      .read<MedicinesDataEntryCubit>()
                      .updateSelectedMedicineName(value);
                  if (!context.mounted) return;
                  context
                      .read<AllergyDataEntryCubit>()
                      .updateSelectedMedicineName(value);
                },
                bottomSheetTitle: "اختر اسم الدواء",
                searchHintText: "ابحث عن اسم الدواء",
                allowManualEntry: true,
                loadingState: state.medicinesNamesOptionsLoadingState,
                onRetryPressed: () async {
                  await context
                      .read<MedicinesDataEntryCubit>()
                      .emitAllMedicinesNames();
                },
              ),
              verticalSpacing(16),
              MedicneNameScannerContainer(state: state),
            ],
          );
        },
      ),
    );
  }
}
