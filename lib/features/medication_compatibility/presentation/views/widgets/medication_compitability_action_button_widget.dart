import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/app_toasts.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/SharedWidgets/app_custom_button.dart';
import 'package:we_care/features/medicine/medicines_data_entry/logic/cubit/medicines_data_entry_cubit.dart';
import 'package:we_care/features/medicine/medicines_data_entry/logic/cubit/medicines_data_entry_state.dart';

class MedicationCompatibilityActionButton extends StatelessWidget {
  const MedicationCompatibilityActionButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MedicinesDataEntryCubit, MedicinesDataEntryState>(
      listenWhen: (prev, curr) =>
          curr.medicinesDataEntryStatus == RequestStatus.failure ||
          curr.medicinesDataEntryStatus == RequestStatus.success,
      buildWhen: (prev, curr) =>
          prev.isMedicationCompatibilityFormValidated !=
              curr.isMedicationCompatibilityFormValidated ||
          prev.medicinesDataEntryStatus != curr.medicinesDataEntryStatus,
      listener: (context, state) async {
        if (state.medicinesDataEntryStatus == RequestStatus.success) {
          await showSuccess(state.message);
          if (!context.mounted) return;
          // pop with result to force refresh parent
          context.pop(result: true);
        } else if (state.medicinesDataEntryStatus == RequestStatus.failure) {
          await showError(state.message);
        }
      },
      builder: (context, state) {
        return AppCustomButton(
          isLoading: state.medicinesDataEntryStatus == RequestStatus.loading,
          title: state.isEditMode ? "تحديث البيانات" : context.translate.send,
          onPressed: state.isMedicationCompatibilityFormValidated
              ? () async {
                  // trigger submit
                  // await context
                  //     .read<MedicinesDataEntryCubit>()
                  //     .submitMedicationCompatibilityData();
                }
              : null,
          isEnabled: state.isMedicationCompatibilityFormValidated,
        );
      },
    );
  }
}
