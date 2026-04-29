import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/app_toasts.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/app_custom_button.dart';
import 'package:we_care/core/global/SharedWidgets/custom_textfield.dart';
import 'package:we_care/core/global/SharedWidgets/date_time_picker_widget.dart';
import 'package:we_care/core/global/SharedWidgets/word_limit_text_field_widget.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/vaccine/vaccine_data_entry/logic/cubit/vaccine_data_entry_cubit.dart';
import 'package:we_care/features/vaccine/vaccine_data_entry/logic/cubit/vaccine_data_entry_state.dart';
import 'package:we_care/generated/l10n.dart';

import '../../../../../../core/global/SharedWidgets/user_selection_container_shared_widget.dart';

class VaccineDataEntryFormFields extends StatefulWidget {
  const VaccineDataEntryFormFields({super.key});

  @override
  State<VaccineDataEntryFormFields> createState() =>
      _VaccineDataEntryFormFieldsState();
}

class _VaccineDataEntryFormFieldsState
    extends State<VaccineDataEntryFormFields> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VaccineDataEntryCubit, VaccineDataEntryState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildVaccineDateSection(state),
            verticalSpacing(16),
            _buildVaccineFiltersSection(context, state),
            verticalSpacing(16),
            _buildVaccineDetailsContainer(state),
            verticalSpacing(16),
            _buildAdditionalInfoSection(context, state),
            verticalSpacing(24),
            submitVaccineDataEntryButtonBlocConsumer(),
            verticalSpacing(32),
          ],
        );
      },
    );
  }

  Widget _buildVaccineDateSection(VaccineDataEntryState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "تاريخ التطعيم",
          style: AppTextStyles.font18blackWight500,
        ),
        verticalSpacing(10),
        DateTimePickerContainer(
          containerBorderColor: state.vaccineDateSelection == null
              ? AppColorsManager.warningColor
              : AppColorsManager.textfieldOutsideBorderColor,
          placeholderText: state.vaccineDateSelection ?? "يوم / شهر / سنة",
          onDateSelected: (pickedDate) {
            context.read<VaccineDataEntryCubit>().updateVaccineDate(pickedDate);
          },
        ),
      ],
    );
  }

  Widget _buildVaccineFiltersSection(
      BuildContext context, VaccineDataEntryState state) {
    final cubit = context.read<VaccineDataEntryCubit>();
    return Column(
      children: [
        UserSelectionContainer(
          containerBorderColor: state.selectedBirthGeneration == null
              ? AppColorsManager.warningColor
              : AppColorsManager.textfieldOutsideBorderColor,
          categoryLabel: "الجيل/ حقبة الميلاد",
          containerHintText:
              state.selectedBirthGeneration ?? "اختر الجيل/ حقبة الميلاد",
          options: state.birthGenerations,
          onOptionSelected: (value) => cubit.updateBirthGeneration(value),
          bottomSheetTitle: "اختر الجيل/ حقبة الميلاد",
          searchHintText: "ابحث عن الجيل/ حقبة الميلاد",
        ),
        verticalSpacing(16),
        UserSelectionContainer(
          containerBorderColor: state.selectedTargetGroup == null
              ? AppColorsManager.warningColor
              : AppColorsManager.textfieldOutsideBorderColor,
          categoryLabel: "الفئة المستهدفة",
          containerHintText:
              state.selectedTargetGroup ?? "اختر الفئة المستهدفة",
          options: state.targetGroups,
          onOptionSelected: (value) => cubit.updateTargetGroup(value),
          bottomSheetTitle: "اختر الفئة المستهدفة",
          searchHintText: "ابحث عن الفئة المستهدفة",
        ),
        verticalSpacing(16),
        UserSelectionContainer(
          containerBorderColor: state.selectedVaccineName == null
              ? AppColorsManager.warningColor
              : AppColorsManager.textfieldOutsideBorderColor,
          categoryLabel: "اسم اللقاح",
          containerHintText: state.selectedVaccineName ?? "اختر اسم اللقاح",
          options: state.vaccinesNames,
          onOptionSelected: (value) => cubit.updateVaccineeName(value),
          bottomSheetTitle: "اختر اسم اللقاح",
          searchHintText: "ابحث عن اسم اللقاح",
        ),
      ],
    );
  }

  Widget _buildVaccineDetailsContainer(VaccineDataEntryState state) {
    if (state.selectedVaccineName == null) return const SizedBox.shrink();

    if (state.vaccineDetailsStatus == RequestStatus.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.vaccineDetailsStatus == RequestStatus.failure) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "حدث خطأ في تحميل تفاصيل اللقاح",
              style: AppTextStyles.font10blueWeight400.copyWith(
                color: AppColorsManager.criticalRisk,
              ),
            ),
            verticalSpacing(10),
            AppCustomButton(
              onPressed: () {
                context.read<VaccineDataEntryCubit>().emitVaccineDetails();
              },
              title: 'حاول مرة أخرى',
            ),
          ],
        ),
      );
    }

    if (state.vaccineDetails == null) return const SizedBox.shrink();

    final details = state.vaccineDetails!;
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColorsManager.textfieldInsideColor,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColorsManager.textfieldOutsideBorderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDetailRow("فئة اللقاح", details.vaccineCategory),
          _buildDetailRow("العمر النموذي", details.recommendedAge),
          _buildDetailRow("الرمز المختصر", details.shortCode),
          _buildDetailRow("وصف عمل اللقاح", details.description),
          _buildDetailRow("إلزامي / اختياري", details.priorityTake),
          _buildDetailRow("المرض المستهدف", details.targetDose),
          _buildDetailRow("الجرعة", details.dose),
          _buildDetailRow("طريقة التطعيم", details.administrationMethod),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String? value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              "$label:",
              style: AppTextStyles.font14blackWeight400.copyWith(
                color: AppColorsManager.placeHolderColor,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value ?? "غير متوفر",
              style: AppTextStyles.font14BlueWeight700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdditionalInfoSection(
      BuildContext context, VaccineDataEntryState state) {
    final cubit = context.read<VaccineDataEntryCubit>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "جهة تلقي التطعيم",
          style: AppTextStyles.font18blackWight500,
        ),
        verticalSpacing(10),
        CustomTextField(
          validator: (p0) => null,
          controller: cubit.vaccinationLocationController,
          hintText: "من فضلك ادخل جهة تلقي التطعيم",
          onChanged: (text) {},
        ),
        verticalSpacing(16),
        UserSelectionContainer(
          categoryLabel: "الدولة",
          containerHintText:
              state.selectedCountryName ?? "اختر الدولة التى تم فيها التطعيم",
          options: state.countriesNames,
          onOptionSelected: (selectedCountry) =>
              cubit.updateSelectedCountry(selectedCountry),
          bottomSheetTitle: "اختر الدولة التى تم فيها التطعيم",
          searchHintText: "ابحث عن الدولة",
        ),
        verticalSpacing(16),
        Text(
          "معلومات اضافية",
          style: AppTextStyles.font18blackWight500,
        ),
        verticalSpacing(10),
        WordLimitTextField(
          controller: cubit.personalNotesController,
          hintText: "اكتب باختصار أى معلومات اضافية مهمة",
        ),
      ],
    );
  }

  Widget submitVaccineDataEntryButtonBlocConsumer() {
    return BlocConsumer<VaccineDataEntryCubit, VaccineDataEntryState>(
      listenWhen: (prev, curr) =>
          curr.vaccineDataEntryStatus == RequestStatus.failure ||
          curr.vaccineDataEntryStatus == RequestStatus.success,
      buildWhen: (prev, curr) =>
          prev.isFormValidated != curr.isFormValidated ||
          prev.vaccineDataEntryStatus != curr.vaccineDataEntryStatus,
      listener: (context, state) async {
        if (state.vaccineDataEntryStatus == RequestStatus.success) {
          await showSuccess(state.message);
          if (!context.mounted) return;
          context.pop(result: true);
        } else {
          await showError(state.message);
        }
      },
      builder: (context, state) {
        return AppCustomButton(
          isLoading: state.vaccineDataEntryStatus == RequestStatus.loading,
          title: context.translate.send,
          onPressed: () async {
            if (state.isFormValidated) {
              state.isEditMode
                  ? await context
                      .read<VaccineDataEntryCubit>()
                      .submitEditVaccineData(S.of(context))
                  : await context
                      .read<VaccineDataEntryCubit>()
                      .postVaccineDataEntry(
                        S.of(context),
                      );
            }
          },
          isEnabled: state.isFormValidated ? true : false,
        );
      },
    );
  }
}
