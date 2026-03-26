import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/app_toasts.dart';
import 'package:we_care/core/global/SharedWidgets/app_custom_button.dart';
import 'package:we_care/features/medication_compatibility/presentation/views/widgets/simulated_medical_modules_checklist_loader.dart';
import 'package:we_care/features/medicine/medicines_data_entry/logic/cubit/medicines_data_entry_cubit.dart';
import 'package:we_care/features/medicine/medicines_data_entry/logic/cubit/medicines_data_entry_state.dart';

class NewMedicalCompitabilityTestActionButton extends StatelessWidget {
  const NewMedicalCompitabilityTestActionButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MedicinesDataEntryCubit, MedicinesDataEntryState>(
      listenWhen: (prev, curr) =>
          prev.analyzeMedicalCompatibilityStatus !=
          curr.analyzeMedicalCompatibilityStatus,
      buildWhen: (prev, curr) =>
          prev.isMedicationCompatibilityFormValidated !=
              curr.isMedicationCompatibilityFormValidated ||
          prev.analyzeMedicalCompatibilityStatus !=
              curr.analyzeMedicalCompatibilityStatus ||
          prev.medicalHistoryStatus != curr.medicalHistoryStatus,
      listener: (context, state) async {
        if (state.analyzeMedicalCompatibilityStatus == RequestStatus.success) {
          if (!context.mounted) return;
          final cubit = context.read<MedicinesDataEntryCubit>();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => BlocProvider.value(
                value: cubit,
                child: const SimulatedMedicalModulesChecklistLoader(),
              ),
            ),
          );
        } else if (state.analyzeMedicalCompatibilityStatus ==
            RequestStatus.failure) {
          await showError(state.message);
        }
      },
      builder: (context, state) {
        return AppCustomButton(
          isLoading:
              state.analyzeMedicalCompatibilityStatus == RequestStatus.loading,
          title: "تحليل التوافق",
          onPressed: (state.medicalHistoryStatus == RequestStatus.success &&
                  state.isMedicationCompatibilityFormValidated)
              ? () async {
                  await context
                      .read<MedicinesDataEntryCubit>()
                      .analyzeMedicalCompatibility();
                }
              : null,
          isEnabled: state.medicalHistoryStatus == RequestStatus.success &&
              state.isMedicationCompatibilityFormValidated,
        );
      },
    );
  }
}
