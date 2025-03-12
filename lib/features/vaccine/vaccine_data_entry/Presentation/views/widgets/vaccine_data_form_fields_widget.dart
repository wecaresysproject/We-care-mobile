import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/app_toasts.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/app_custom_button.dart';
import 'package:we_care/core/global/SharedWidgets/custom_radio_buttons_shared_container_widget.dart';
import 'package:we_care/core/global/SharedWidgets/date_time_picker_widget.dart';
import 'package:we_care/core/global/SharedWidgets/word_limit_text_field_widget.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/vaccine/vaccine_data_entry/logic/cubit/vaccine_data_entry_cubit.dart';
import 'package:we_care/features/vaccine/vaccine_data_entry/logic/cubit/vaccine_data_entry_state.dart';

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
            UserSelectionContainer(
              categoryLabel: "السن النموزجي للتطعيم",
              containerHintText: "اختر السن",
              options: [
                "الاسم الاول ١",
                "الاسم الاول ٢",
                "الاسم الاول٣١",
              ],
              onOptionSelected: (value) {
                context.read<VaccineDataEntryCubit>().updateVaccineeName(value);
              },
              bottomSheetTitle: " اختر السن النموزجي للتطعيم",
            ),
            verticalSpacing(16),
            UserSelectionContainer(
              containerBorderColor: state.selectedvaccineName == null
                  ? AppColorsManager.warningColor
                  : AppColorsManager.textfieldOutsideBorderColor,
              categoryLabel: "الطعم",
              containerHintText: "اختر الطعم",
              options: [
                "الاسم الاول ١",
                "الاسم الاول ٢",
                "الاسم الاول٣١",
              ],
              onOptionSelected: (value) {
                context.read<VaccineDataEntryCubit>().updateVaccineeName(value);
              },
              bottomSheetTitle: "اختر الطعم",
            ),

            verticalSpacing(16),
            Text(
              "تاريخ الجرعة",
              style: AppTextStyles.font18blackWight500,
            ),
            verticalSpacing(10),

            DateTimePickerContainer(
              containerBorderColor: state.vaccineDateSelection == null
                  ? AppColorsManager.warningColor
                  : AppColorsManager.textfieldOutsideBorderColor,
              placeholderText:
                  isArabic() ? "يوم / شهر / سنة" : "Date / Month / Year",
              onDateSelected: (pickedDate) {
                context
                    .read<VaccineDataEntryCubit>()
                    .updateVaccineDate(pickedDate);
                log("xxx: pickedDate: $pickedDate");
              },
            ),

            /// size between each categogry
            verticalSpacing(16),
            UserSelectionContainer(
              containerBorderColor: state.doseArrangement == null
                  ? AppColorsManager.warningColor
                  : AppColorsManager.textfieldOutsideBorderColor,
              categoryLabel: "ترتيب الجرعة", // Another Dropdown Example
              containerHintText: "اختر ترتيب الجرعة",
              options: [
                "ترتيب ١",
                "ترتيب 2",
                "ترتيب 3",
              ],
              onOptionSelected: (doseArrangment) {
                context
                    .read<VaccineDataEntryCubit>()
                    .updateDoseArrangement(doseArrangment);
              },
              bottomSheetTitle: "اختر ترتيب الجرعة",
            ),

            verticalSpacing(16),
            UserSelectionContainer(
              categoryLabel:
                  "الفئة العمرية المستهدفة", // Another Dropdown Example
              containerHintText: "اختر الفئة العمرية المستهدفة",
              options: [],
              onOptionSelected: (selectedPupose) {
                log("xxx:Selected: $selectedPupose");
                // context
                //     .read<XRayDataEntryCubit>()
                //     .updateXRaySelectedPupose(selectedPupose);
              },
              bottomSheetTitle: "اختر الفئة العمرية المستهدفة",
            ),
            verticalSpacing(16),
            CustomToggleRadioContainer(
              initialValue: "",
              title: "هل التطعيم الزامى أم اختيارى؟",
              option1: 'الزامي',
              option2: 'اختياري',
              onChanged: (String value) {},
            ),
            verticalSpacing(16),

            UserSelectionContainer(
              categoryLabel: "طريقة اعطاء التطعيم", // Another Dropdown Example
              containerHintText: "اختر الفئة العمرية المستهدفة",
              options: [],
              onOptionSelected: (selectedPupose) {
                log("xxx:Selected: $selectedPupose");
                // context
                //     .read<XRayDataEntryCubit>()
                //     .updateXRaySelectedPupose(selectedPupose);
              },
              bottomSheetTitle: "اختر طريقة أخذك للتطعيم",
            ),
            verticalSpacing(16),

            UserSelectionContainer(
              categoryLabel: "المرض المستهدف",
              containerHintText: "اختر المرض الذى يقى منه اللقاح",
              options: [],
              onOptionSelected: (selectedPupose) {
                log("xxx:Selected: $selectedPupose");
                // context
                //     .read<XRayDataEntryCubit>()
                //     .updateXRaySelectedPupose(selectedPupose);
              },
              bottomSheetTitle: "اختر المرض الذى يقى منه اللقاح",
            ),

            verticalSpacing(16),

            UserSelectionContainer(
              categoryLabel: "حجم الجرعة",
              containerHintText: "اختر حجم الجرعة",
              options: [],
              onOptionSelected: (selectedPupose) {
                log("xxx:Selected: $selectedPupose");
                // context
                //     .read<XRayDataEntryCubit>()
                //     .updateXRaySelectedPupose(selectedPupose);
              },
              bottomSheetTitle: "اختر حجم الجرعة",
            ),

            verticalSpacing(16),

            UserSelectionContainer(
              categoryLabel: "الأعراض المرضية - المنطقة",
              containerHintText: "اختر الأعراض المصاحبة",
              options: [],
              onOptionSelected: (selectedPupose) {
                log("xxx:Selected: $selectedPupose");
                // context
                //     .read<XRayDataEntryCubit>()
                //     .updateXRaySelectedPupose(selectedPupose);
              },
              bottomSheetTitle: "اختر الأعراض المصاحبة",
            ),
            verticalSpacing(16),

            /// الطبيب المعالج

            UserSelectionContainer(
              categoryLabel: "الأعراض المرضية - الشكوى",
              containerHintText: "اختر الأعراض المصاحبة",
              options: [],
              onOptionSelected: (selectedPupose) {
                log("xxx:Selected: $selectedPupose");
                // context
                //     .read<XRayDataEntryCubit>()
                //     .updateXRaySelectedPupose(selectedPupose);
              },
              bottomSheetTitle: "اختر الأعراض المصاحبة",
            ),

            verticalSpacing(16),

            UserSelectionContainer(
              categoryLabel: "جهة تلقى التطعيم",
              containerHintText: "اكتب اسم الجهة التى تم التطعيم منها",
              options: [],
              onOptionSelected: (selectedPupose) {
                log("xxx:Selected: $selectedPupose");
                // context
                //     .read<XRayDataEntryCubit>()
                //     .updateXRaySelectedPupose(selectedPupose);
              },
              bottomSheetTitle: "اكتب اسم الجهة التى تم التطعيم منها",
            ),

            verticalSpacing(16),
            UserSelectionContainer(
              categoryLabel: "الدولة",
              containerHintText: "اختر الدولة التى تم فيها التطعيم",
              options: [],
              onOptionSelected: (selectedPupose) {
                log("xxx:Selected: $selectedPupose");
                // context
                //     .read<XRayDataEntryCubit>()
                //     .updateXRaySelectedPupose(selectedPupose);
              },
              bottomSheetTitle: "اختر الدولة التى تم فيها التطعيم",
            ),

            verticalSpacing(16),
            Text(
              "معلومات اضافية",
              style: AppTextStyles.font18blackWight500,
            ),
            verticalSpacing(10),

            WordLimitTextField(
              controller:
                  context.read<VaccineDataEntryCubit>().personalNotesController,
              hintText: "اكتب باختصار أى معلومات اضافية مهمة",
            ),

            ///TODO: handle this button in main view and remove it from here
            /// send button
            verticalSpacing(32),
            submitXrayDataEntryButtonBlocConsumer(),
            verticalSpacing(71),
          ],
        );
      },
    );
  }

  Widget submitXrayDataEntryButtonBlocConsumer() {
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
          context.pop();
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
              // state.isEditMode?

              log("xxx:Save Data Entry");
            } else {
              log("form not validated");
            }
          },
          isEnabled: state.isFormValidated ? true : false,
        );
      },
    );
  }
}
