import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/Helpers/app_toasts.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/app_custom_button.dart';
import 'package:we_care/core/global/SharedWidgets/custom_textfield.dart';
import 'package:we_care/core/global/SharedWidgets/user_selection_container_shared_widget.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/features/doctor/medical_specialty/logic/cubit/medical_specialty_cubit.dart';
import 'package:we_care/generated/l10n.dart';

class MedicalSpecialtyFormFields extends StatelessWidget {
  const MedicalSpecialtyFormFields({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MedicalSpecialtyCubit, MedicalSpecialtyState>(
      builder: (context, state) {
        final cubit = context.read<MedicalSpecialtyCubit>();
        final localization = S.of(context);

        return Form(
          key: cubit.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                localization.medicalSpecialtyFormMainSpecialtyLabel,
                style: AppTextStyles.font18blackWight500,
              ),
              verticalSpacing(10),
              UserSelectionContainer(
                containerHintText: state.selectedMainSpecialty ??
                    localization.medicalSpecialtyFormChooseMainSpecialty,
                options: state.mainSpecialties,
                onOptionSelected: cubit.updateMainSpecialty,
                bottomSheetTitle:
                    localization.medicalSpecialtyFormChooseMainSpecialty,
                searchHintText:
                    localization.medicalSpecialtyFormChooseMainSpecialty,
              ),
              verticalSpacing(18),
              Text(
                localization.medicalSpecialtyFormSubSpecialtyLabel,
                style: AppTextStyles.font18blackWight500,
              ),
              verticalSpacing(10),
              CustomTextField(
                controller: cubit.subSpecialtyController,
                hintText: localization.medicalSpecialtyFormEnterSubSpecialty,
                validator: (_) => null,
              ),
              verticalSpacing(18),
              Text(
                localization.medicalSpecialtyFormInterestsLabel,
                style: AppTextStyles.font18blackWight500,
              ),
              verticalSpacing(10),
              CustomTextField(
                controller: cubit.clinicalInterestsController,
                hintText: localization.medicalSpecialtyFormEnterInterests,
                validator: (_) => null,
              ),
              verticalSpacing(28),
              _SubmitButton(),
              verticalSpacing(20),
            ],
          ),
        );
      },
    );
  }
}

class _SubmitButton extends StatelessWidget {
  const _SubmitButton();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MedicalSpecialtyCubit, MedicalSpecialtyState>(
      listenWhen: (prev, curr) =>
          curr.submissionStatus == RequestStatus.success ||
          curr.submissionStatus == RequestStatus.failure,
      buildWhen: (prev, curr) => prev.submissionStatus != curr.submissionStatus,
      listener: (context, state) async {
        if (state.submissionStatus == RequestStatus.success) {
          await showSuccess(state.message!);
          if (!context.mounted) return;
          context.pop(result: true);
        } else if (state.submissionStatus == RequestStatus.failure) {
          await showError(state.message!);
        }
      },
      builder: (context, state) {
        final cubit = context.read<MedicalSpecialtyCubit>();
        return AppCustomButton(
          title: S.of(context).basicDataFormSubmit,
          isEnabled: state.submissionStatus != RequestStatus.loading,
          isLoading: state.submissionStatus == RequestStatus.loading,
          onPressed: () {
            if (cubit.formKey.currentState?.validate() ?? false) {
              cubit.submitMedicalSpecialty();
            }
          },
        );
      },
    );
  }
}
