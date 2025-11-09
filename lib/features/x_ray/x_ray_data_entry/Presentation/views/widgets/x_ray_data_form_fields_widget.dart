import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/app_toasts.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/app_custom_button.dart';
import 'package:we_care/core/global/SharedWidgets/date_time_picker_widget.dart';
import 'package:we_care/core/global/SharedWidgets/word_limit_text_field_widget.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/x_ray/x_ray_data_entry/Presentation/views/widgets/x_ray_image_upload_section_widget.dart';
import 'package:we_care/features/x_ray/x_ray_data_entry/Presentation/views/widgets/xray_report_section_widget.dart';
import 'package:we_care/features/x_ray/x_ray_data_entry/logic/cubit/x_ray_data_entry_cubit.dart';
import 'package:we_care/generated/l10n.dart';

import '../../../../../../core/global/SharedWidgets/user_selection_container_shared_widget.dart';

class XRayDataEntryFormFields extends StatefulWidget {
  const XRayDataEntryFormFields({super.key});

  @override
  State<XRayDataEntryFormFields> createState() =>
      _XRayDataEntryFormFieldsState();
}

class _XRayDataEntryFormFieldsState extends State<XRayDataEntryFormFields> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<XRayDataEntryCubit, XRayDataEntryState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "تاريخ الأشعة",
              style: AppTextStyles.font18blackWight500,
            ),
            verticalSpacing(10),

            DateTimePickerContainer(
              containerBorderColor: state.xRayDateSelection == null
                  ? AppColorsManager.warningColor
                  : AppColorsManager.textfieldOutsideBorderColor,
              placeholderText: state.xRayDateSelection ??
                  (isArabic() ? "يوم / شهر / سنة" : "Day / Month / Year"),
              onDateSelected: (pickedDate) {
                context.read<XRayDataEntryCubit>().updateXRayDate(pickedDate);
                log("xxx: pickedDate: $pickedDate"); //! 2024-02-14
              },
            ),

            /// size between each categogry
            verticalSpacing(16),

            UserSelectionContainer(
              containerBorderColor: state.xRayBodyPartSelection == null
                  ? AppColorsManager.warningColor
                  : AppColorsManager.textfieldOutsideBorderColor,
              categoryLabel: "منطقة الأشعة",
              containerHintText:
                  state.xRayBodyPartSelection ?? "اختر العضو الخاص بالأشعة",
              isEditMode: state.isEditMode,
              options: state.bodyPartNames,
              onOptionSelected: (selectedbodyPartName) async {
                await context
                    .read<XRayDataEntryCubit>()
                    .updateXRayBodyPart(selectedbodyPartName);
              },
              bottomSheetTitle: 'اختر العضو الخاص بالأشعة',
              searchHintText: "ابحث عن العضو الخاص بالأشعة",
            ),

            verticalSpacing(16),
            UserSelectionContainer(
              containerBorderColor: state.xRayTypeSelection == null
                  ? AppColorsManager.warningColor
                  : AppColorsManager.textfieldOutsideBorderColor,
              categoryLabel: "النوع",
              isEditMode: state.isEditMode,
              containerHintText: state.xRayTypeSelection ?? "اختر نوع الأشعة",
              options: state.radiologyTypesBasedOnBodyPartNameSelected,
              onOptionSelected: (value) async {
                context.read<XRayDataEntryCubit>().updateXRayType(value);
              },
              bottomSheetTitle: 'اختر نوع الأشعة',
              searchHintText: "ابحث عن نوع الأشعة",
            ),

            verticalSpacing(16),
            UserSelectionContainer(
              categoryLabel:
                  "نوعية الاحتياج للأشعة", // Another Dropdown Example
              containerHintText:
                  state.selectedPupose ?? "اختر نوعية احتياجك للأشعة",
              options: state.puposesOfSelectedXRayType,
              isEditMode: state.isEditMode,
              onOptionSelected: (selectedPupose) {
                log("xxx:Selected: $selectedPupose");
                context
                    .read<XRayDataEntryCubit>()
                    .updateXRaySelectedPupose(selectedPupose);
              },
              bottomSheetTitle: "اختر نوعية احتياجك للأشعة",
              searchHintText: "ابحث عن نوعية احتياجك للأشعة",
            ),

            verticalSpacing(16),

            XRayImageUploadSection(),

            verticalSpacing(16),

            XRayReportSection(),

            verticalSpacing(16),

            // //! الأعراض المستدعية للاجراء"

            UserSelectionContainer(
              allowManualEntry: true,
              options: [
                "فحص الدم",
                "فحص البول",
                "فحص القلب",
                "أشعة سينية",
              ],
              categoryLabel: "الأعراض المستدعية للاجراء",
              bottomSheetTitle: "اختر الأعراض المستدعية",
              onOptionSelected: (value) {
                log("xxx:Selected: $value");
              },
              containerHintText: "اختر الأعراض المستدعية",
              searchHintText: "ابحث عن الأعراض المستدعية",
            ),

            verticalSpacing(16),

            /// طبيب الأشعة

            UserSelectionContainer(
              allowManualEntry: true,
              categoryLabel: "طبيب الأشعة",
              containerHintText:
                  state.selectedRadiologistDoctorName ?? "اختر اسم طبيب الأشعة",
              options: state.doctorNames,
              onOptionSelected: (value) {
                context
                    .read<XRayDataEntryCubit>()
                    .updateSelectedRadiologistDoctor(value);
              },
              bottomSheetTitle: 'اختر اسم طبيب الأشعة',
              searchHintText: "ابحث عن اسم طبيب الأشعة",
            ),

            verticalSpacing(16),
            UserSelectionContainer(
              allowManualEntry: true,
              categoryLabel: "مركز الأشعة",
              containerHintText:
                  state.selectedRadiologyCenter ?? "اختر اسم المركز",
              options: state.radilogyCenters,
              onOptionSelected: (value) {
                log("xxx:Selected: $value");
                context
                    .read<XRayDataEntryCubit>()
                    .updateSelectedRadiologyCenter(value);
              },
              bottomSheetTitle: 'اختر اسم المركز',
              searchHintText: "ابحث عن اسم المركز",
            ),

            verticalSpacing(16),

            ///المستشفى
            //   //! write by ur hand
            UserSelectionContainer(
              allowManualEntry: true,
              categoryLabel: "المستشفى",
              containerHintText:
                  state.selectedHospitalName ?? "اختر اسم المستشفى",
              options: state.hospitalNames,
              onOptionSelected: (value) {
                log("xxx:Selected: $value");
                context
                    .read<XRayDataEntryCubit>()
                    .updateSelectedHospitalName(value);
              },
              bottomSheetTitle: 'اختر اسم المستشفى',
              searchHintText: "ابحث عن اسم المستشفى",
            ),

            verticalSpacing(16),

            /// الطبيب المعالج

            UserSelectionContainer(
              allowManualEntry: true,
              options: state.doctorNames,
              categoryLabel: "الطبيب المعالج",
              bottomSheetTitle: "اختر اسم الطبيب المعالج ",
              onOptionSelected: (value) {
                context
                    .read<XRayDataEntryCubit>()
                    .updateSelectedTreatedDoctor(value);
              },
              containerHintText: state.selectedTreatedDoctor ??
                  "اختر اسم الطبيب المعالج (جراح/باطنة)",
              searchHintText: "ابحث عن اسم الطبيب المعالج",
            ),

            verticalSpacing(16),

            ///الدولة
            UserSelectionContainer(
              options: state.countriesNames,
              categoryLabel: "الدولة",
              bottomSheetTitle: "اختر اسم الدولة",
              onOptionSelected: (selectedCountry) {
                context
                    .read<XRayDataEntryCubit>()
                    .updateSelectedCountry(selectedCountry);
              },
              containerHintText: "اختر اسم الدولة",
              searchHintText: "ابحث عن اسم الدولة",
            ),

            verticalSpacing(16),
            Text(
              "ملاحظات شخصية",
              style: AppTextStyles.font18blackWight500,
            ),
            verticalSpacing(10),

            WordLimitTextField(
              controller:
                  context.read<XRayDataEntryCubit>().personalNotesController,
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
    return BlocConsumer<XRayDataEntryCubit, XRayDataEntryState>(
      listenWhen: (prev, curr) =>
          curr.xRayDataEntryStatus == RequestStatus.failure ||
          curr.xRayDataEntryStatus == RequestStatus.success,
      buildWhen: (prev, curr) =>
          prev.isFormValidated != curr.isFormValidated ||
          prev.xRayDataEntryStatus != curr.xRayDataEntryStatus,
      listener: (context, state) async {
        if (state.xRayDataEntryStatus == RequestStatus.success) {
          await showSuccess(state.message);
          if (!context.mounted) return;
          //* in order to catch it again to rebuild details view
          context.pop(result: true);
        } else {
          await showError(state.message);
        }
      },
      builder: (context, state) {
        return AppCustomButton(
          isLoading: state.xRayDataEntryStatus == RequestStatus.loading,
          title: context.translate.send,
          onPressed: () async {
            if (state.isFormValidated) {
              if (state.isEditMode) {
                await context
                    .read<XRayDataEntryCubit>()
                    .submitEditsOnXRayDocument(S.of(context));
              } else {
                await context.read<XRayDataEntryCubit>().postRadiologyDataEntry(
                      context.translate,
                    );
              }
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
