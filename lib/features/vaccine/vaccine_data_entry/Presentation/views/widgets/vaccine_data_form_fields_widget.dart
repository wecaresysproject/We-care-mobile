import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_care/core/di/dependency_injection.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/app_toasts.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/Helpers/image_quality_detector.dart';
import 'package:we_care/core/global/SharedWidgets/app_custom_button.dart';
import 'package:we_care/core/global/SharedWidgets/date_time_picker_widget.dart';
import 'package:we_care/core/global/SharedWidgets/show_image_picker_selection_widget.dart';
import 'package:we_care/core/global/SharedWidgets/word_limit_text_field_widget.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/test_laboratory/test_analysis_data_entry/Presentation/views/widgets/select_image_container_widget.dart';
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
            Text(
              "تاريخ الأشعة",
              style: AppTextStyles.font18blackWight500,
            ),
            verticalSpacing(10),

            DateTimePickerContainer(
              containerBorderColor: state.xRayDateSelection == null
                  ? AppColorsManager.warningColor
                  : AppColorsManager.textfieldOutsideBorderColor,
              placeholderText:
                  isArabic() ? "يوم / شهر / سنة" : "Date / Month / Year",
              onDateSelected: (pickedDate) {
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
              containerHintText: "اختر العضو الخاص بالأشعة",
              options: [],
              onOptionSelected: (selectedbodyPartName) async {
                // await context
                //     .read<VaccineDataEntryCubit>()
                //     .updateXRayBodyPart(selectedbodyPartName);
              },
              bottomSheetTitle: 'اختر العضو الخاص بالأشعة',
            ),

            verticalSpacing(16),
            UserSelectionContainer(
              containerBorderColor: state.xRayTypeSelection == null
                  ? AppColorsManager.warningColor
                  : AppColorsManager.textfieldOutsideBorderColor,
              categoryLabel: "النوع",
              containerHintText: "اختر نوع الأشعة",
              options: [],
              onOptionSelected: (value) async {
                // context.read<XRayDataEntryCubit>().updateXRayType(value);
              },
              bottomSheetTitle: 'اختر نوع الأشعة',
            ),

            verticalSpacing(16),
            UserSelectionContainer(
              categoryLabel:
                  "نوعية الاحتياج للأشعة", // Another Dropdown Example
              containerHintText: "اختر نوعية احتياجك للأشعة",
              options: [],
              onOptionSelected: (selectedPupose) {
                log("xxx:Selected: $selectedPupose");
                // context
                //     .read<XRayDataEntryCubit>()
                //     .updateXRaySelectedPupose(selectedPupose);
              },
              bottomSheetTitle: "اختر نوعية احتياجك للأشعة",
            ),

            verticalSpacing(16),
            Text(
              "الصورة",
              style: AppTextStyles.font18blackWight500,
            ),
            verticalSpacing(10),
            BlocListener<VaccineDataEntryCubit, VaccineDataEntryState>(
              listenWhen: (prev, curr) =>
                  prev.xRayImageRequestStatus != curr.xRayImageRequestStatus,
              listener: (context, state) async {
                if (state.xRayImageRequestStatus ==
                    UploadImageRequestStatus.success) {
                  await showSuccess(state.message);
                }
                if (state.xRayImageRequestStatus ==
                    UploadImageRequestStatus.failure) {
                  await showError(state.message);
                }
              },
              child: SelectImageContainer(
                containerBorderColor: (state.isXRayPictureSelected == null) ||
                        (state.isXRayPictureSelected == false)
                    ? AppColorsManager.warningColor
                    : AppColorsManager.textfieldOutsideBorderColor,
                imagePath: "assets/images/photo_icon.png",
                label: "ارفق صورة",
                onTap: () async {
                  await showImagePicker(
                    context,
                    onImagePicked: (isImagePicked) async {
                      final picker = getIt.get<ImagePickerService>();
                      if (isImagePicked && picker.isImagePickedAccepted) {
                        // context
                        //     .read<VaccineDataEntryCubit>()
                        //     .updateXRayPicture(isImagePicked);

                        // await context
                        //     .read<VaccineDataEntryCubit>()
                        //     .uploadXrayImagePicked(
                        //       imagePath: picker.pickedImage!.path,
                        //     );
                      }
                    },
                  );
                },
              ),
            ),

            verticalSpacing(16),
            Text(
              "التقرير الطبي",
              style: AppTextStyles.font18blackWight500,
            ),
            verticalSpacing(10),
            SelectImageContainer(
              imagePath: "assets/images/t_shape_icon.png",
              label: "اكتب التقرير",
              onTap: () {},
            ),

            verticalSpacing(8),
            BlocListener<VaccineDataEntryCubit, VaccineDataEntryState>(
              listenWhen: (prev, curr) =>
                  prev.xRayReportRequestStatus != curr.xRayReportRequestStatus,
              listener: (context, state) async {
                if (state.xRayReportRequestStatus ==
                    UploadReportRequestStatus.success) {
                  await showSuccess(state.message);
                }
                if (state.xRayReportRequestStatus ==
                    UploadReportRequestStatus.failure) {
                  await showError(state.message);
                }
              },
              child: SelectImageContainer(
                imagePath: "assets/images/photo_icon.png",
                label: " ارفق صورة للتقرير",
                onTap: () async {
                  await showImagePicker(
                    context,
                    onImagePicked: (isImagePicked) async {
                      final picker = getIt.get<ImagePickerService>();
                      if (isImagePicked && picker.isImagePickedAccepted) {
                        // await context
                        //     .read<VaccineDataEntryCubit>()
                        //     .uploadXrayReportPicked(
                        //       imagePath: picker.pickedImage!.path,
                        //     );
                      }
                    },
                  );
                },
              ),
            ),
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
            ),

            verticalSpacing(16),

            /// طبيب الأشعة

            UserSelectionContainer(
              allowManualEntry: true,
              categoryLabel: "طبيب الأشعة",
              containerHintText: "اختر اسم طبيب الأشعة",
              options: [
                "د / محمد محمد",
                "د / كريم محمد",
                "د / رشا محمد",
                "د / رشا مصطفى",
              ],
              onOptionSelected: (value) {
                log("xxx:Selected: $value");
              },
              bottomSheetTitle: 'اختر اسم طبيب الأشعة',
            ),

            verticalSpacing(16),

            /// المركز / المستشفى
            //   //! write by ur hand
            UserSelectionContainer(
              allowManualEntry: true,
              categoryLabel: "المركز / المستشفى",
              containerHintText: "اختر اسم المستشفى/المركز",
              options: [
                "مستشفى القلب",
                "مستشفى العين الدولى",
                "مستشفى 57357",
              ],
              onOptionSelected: (value) {
                log("xxx:Selected: $value");
              },
              bottomSheetTitle: 'اختر اسم المستشفى/المركز',
            ),

            verticalSpacing(16),

            /// الطبيب المعالج

            UserSelectionContainer(
              allowManualEntry: true,
              options: [
                "د / محمد محمد",
                "د / كريم محمد",
                "د / رشا محمد",
                "د / رشا مصطفى",
              ],
              categoryLabel: "الطبيب المعالج",
              bottomSheetTitle: "اختر اسم الطبيب المعالج ",
              onOptionSelected: (value) {},
              containerHintText: "اختر اسم الطبيب المعالج (جراح/باطنة)",
            ),

            verticalSpacing(16),

            ///الدولة
            UserSelectionContainer(
              options: state.countriesNames,
              categoryLabel: "الدولة",
              bottomSheetTitle: "اختر اسم الدولة",
              onOptionSelected: (selectedCountry) {
                context
                    .read<VaccineDataEntryCubit>()
                    .updateSelectedCountry(selectedCountry);
              },
              containerHintText: "اختر اسم الدولة",
            ),

            verticalSpacing(16),
            Text(
              "ملاحظات شخصية",
              style: AppTextStyles.font18blackWight500,
            ),
            verticalSpacing(10),

            WordLimitTextField(
              controller:
                  context.read<VaccineDataEntryCubit>().personalNotesController,
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
              // await context.read<VaccineDataEntryCubit>().postRadiologyDataEntry(
              //       context.translate,
              //     );
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
