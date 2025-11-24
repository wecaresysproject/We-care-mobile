import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/app_toasts.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/app_custom_button.dart';
import 'package:we_care/core/global/SharedWidgets/date_time_picker_widget.dart';
import 'package:we_care/core/global/SharedWidgets/details_view_info_tile.dart';
import 'package:we_care/core/global/SharedWidgets/report_uploader_section_widget.dart';
import 'package:we_care/core/global/SharedWidgets/word_limit_text_field_widget.dart';
import 'package:we_care/core/global/SharedWidgets/write_report_screen.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/surgeries/surgeries_data_entry_view/logic/cubit/surgery_data_entry_cubit.dart';

import '../../../../../../core/global/SharedWidgets/select_image_container_shared_widget.dart';
import '../../../../../../core/global/SharedWidgets/user_selection_container_shared_widget.dart';

class SuergeriesDataEntryFormFields extends StatefulWidget {
  const SuergeriesDataEntryFormFields({super.key});

  @override
  State<SuergeriesDataEntryFormFields> createState() =>
      _SuergeriesDataEntryFormFieldsState();
}

class _SuergeriesDataEntryFormFieldsState
    extends State<SuergeriesDataEntryFormFields> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SurgeryDataEntryCubit, SurgeryDataEntryState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "تاريخ العمليه",
              style: AppTextStyles.font18blackWight500,
            ),
            verticalSpacing(10),

            DateTimePickerContainer(
              containerBorderColor: state.surgeryDateSelection == null
                  ? AppColorsManager.warningColor
                  : AppColorsManager.textfieldOutsideBorderColor,
              placeholderText: state.surgeryDateSelection == null
                  ? isArabic()
                      ? "يوم / شهر / سنة"
                      : "Date / Month / Year"
                  : state.surgeryDateSelection!,
              onDateSelected: (pickedDate) {
                context
                    .read<SurgeryDataEntryCubit>()
                    .updateSurgeryDate(pickedDate);
                log("xxx: pickedDate: $pickedDate"); //! 2024-02-14
              },
            ),

            /// size between each categogry
            verticalSpacing(16),

            UserSelectionContainer(
              containerBorderColor: state.surgeryBodyPartSelection == null
                  ? AppColorsManager.warningColor
                  : AppColorsManager.textfieldOutsideBorderColor,
              categoryLabel: "العضو",
              containerHintText:
                  state.surgeryBodyPartSelection ?? "اختر منطقة العمليه",
              options: state.bodyParts,
              onOptionSelected: (value) {
                log("xxx:Selected: $value");
                context
                    .read<SurgeryDataEntryCubit>()
                    .updateSurgeryBodyPart(value);
              },
              bottomSheetTitle: state.surgeryBodyPartSelection ??
                  'اختر المنطقة الخاصة بالعمليه',
              searchHintText: "ابحث عن المنطقة",
            ),

            verticalSpacing(16),
            UserSelectionContainer(
              containerBorderColor: state.selectedSubSurgery == null
                  ? AppColorsManager.warningColor
                  : AppColorsManager.textfieldOutsideBorderColor,
              categoryLabel: "منطقة العملية الفرعية",
              containerHintText: state.selectedSubSurgery ??
                  "اختر المنطقة التى تمت بها العملية",
              options: state.subSurgeryRegions,
              onOptionSelected: (value) async {
                await context
                    .read<SurgeryDataEntryCubit>()
                    .updateSelectedSubSurgery(value);

                log("xxx:Selected: $value");
              },
              bottomSheetTitle: 'اختر المنطقة التى تمت بها العملية',
              searchHintText: "ابحث عن المنطقة",
            ),

            verticalSpacing(16),
            UserSelectionContainer(
              allowManualEntry: true,
              containerBorderColor: state.surgeryNameSelection == null
                  ? AppColorsManager.warningColor
                  : AppColorsManager.textfieldOutsideBorderColor,
              categoryLabel: "اسم العملية", // Another Dropdown Example
              containerHintText:
                  state.surgeryNameSelection ?? "اختر اسم العملية",
              options: state.surgeryNames,
              onOptionSelected: (value) async {
                await context
                    .read<SurgeryDataEntryCubit>()
                    .updateSurgeryName(value);
                log("xxx:Selected: $value");
              },
              bottomSheetTitle: "اختر اسم العملية",
              searchHintText: "ابحث عن اسم العملية",
            ),
            verticalSpacing(16),
            UserSelectionContainer(
              containerBorderColor: state.selectedTechUsed == null
                  ? AppColorsManager.warningColor
                  : AppColorsManager.textfieldOutsideBorderColor,
              categoryLabel: "التقنية المستخدمة", // Another Dropdown Example
              containerHintText:
                  state.selectedTechUsed ?? "اختر التقنية المستخدمة",
              options: state.allTechUsed,
              onOptionSelected: (value) {
                context
                    .read<SurgeryDataEntryCubit>()
                    .updateSelectedTechUsed(value);
                log("xxx:Selected: $value");
              },
              bottomSheetTitle: "اختر التقنية المستخدمة",
              searchHintText: "ابحث عن التقنية المستخدمة",
            ),
            verticalSpacing(16),
            Text(
              "الهدف من الاجراء",
              style: AppTextStyles.font18blackWight500,
            ),
            verticalSpacing(10),
            CustomContainer(
              value: state.surgeryPurpose ?? "الهدف من الاجراء",
              isExpanded: true,
            ),
            verticalSpacing(16),

            Text(
              "وصف اضافي للعملية",
              style: AppTextStyles.font18blackWight500,
            ),
            verticalSpacing(10),
            WordLimitTextField(
              hintText: "اكتب وصف العملية",
              controller: context
                  .read<SurgeryDataEntryCubit>()
                  .suergeryDescriptionController,
            ),

            verticalSpacing(16),

            Text(
              "التقرير الطبي (${state.reportsImageUploadedUrls.length}/8)",
              style: AppTextStyles.font18blackWight500,
            ),
            verticalSpacing(10),
            SelectImageContainer(
              imagePath: "assets/images/t_shape_icon.png",
              label: context
                      .read<SurgeryDataEntryCubit>()
                      .reportTextController
                      .text
                      .isEmpty
                  ? "اكتب التقرير"
                  : "تعديل التقرير",
              onTap: () async {
                // ✅ اقرا الـ cubit من الـ context الحالي
                final cubit = context.read<SurgeryDataEntryCubit>();
                final isFirstTime =
                    cubit.reportTextController.text.isEmpty == true;
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WriteReportScreenSharedWidget(
                      reportController: cubit.reportTextController,
                      screenTitle:
                          isFirstTime ? "اكتب التقرير" : "تعديل التقرير",
                      saveButtonText:
                          isFirstTime ? "حفظ التقرير" : "حفظ التعديلات",
                    ),
                  ),
                );
              },
            ),

            verticalSpacing(8),
            // BlocListener<SurgeryDataEntryCubit, SurgeryDataEntryState>(
            //   listenWhen: (previous, current) =>
            //       previous.surgeryUploadReportStatus !=
            //       current.surgeryUploadReportStatus,
            //   listener: (context, state) async {
            //     if (state.surgeryUploadReportStatus ==
            //         UploadReportRequestStatus.success) {
            //       await showSuccess(state.message);
            //     }
            //     if (state.surgeryUploadReportStatus ==
            //         UploadReportRequestStatus.failure) {
            //       await showError(state.message);
            //     }
            //   },
            //   child: SelectImageContainer(
            //     imagePath: "assets/images/photo_icon.png",
            //     label: "ارفق صورة",
            //     onTap: () async {
            //       await showImagePicker(
            //         context,
            //         onImagePicked: (isImagePicked) async {
            //           final picker = getIt.get<ImagePickerService>();
            //           if (isImagePicked && picker.isImagePickedAccepted) {
            //             await context
            //                 .read<SurgeryDataEntryCubit>()
            //                 .uploadReportImagePicked(
            //                   imagePath: picker.pickedImage!.path,
            //                 );
            //           }
            //         },
            //       );
            //     },
            //   ),
            // ),

            ReportUploaderSection<SurgeryDataEntryCubit, SurgeryDataEntryState>(
              statusSelector: (state) => state.surgeryUploadReportStatus,
              uploadedSelector: (state) => state.reportsImageUploadedUrls,
              resultMessage: state.message,
              onRemove: (imagePath) {
                context
                    .read<SurgeryDataEntryCubit>()
                    .removeUploadedReport(imagePath);
              },
              onUpload: (path) async {
                await context
                    .read<SurgeryDataEntryCubit>()
                    .uploadReportImagePicked(
                      imagePath: path,
                    );
              },
            ),
            verticalSpacing(16),

            // //! حالة العمليه"

            UserSelectionContainer(
              categoryLabel: "حالة العملية",
              options: [
                "تمت بنجاح",
                "تمت بمضاعفات",
                "في مرحلة التعافي",
                "لم تنجح",
                "إعادة العملية",
                "نجاح جزئي",
                "النتيجة غير واضحه",
              ],
              bottomSheetTitle: "اختر حالة العملية",
              onOptionSelected: (value) {
                log("xxx:Selected: $value");
                context
                    .read<SurgeryDataEntryCubit>()
                    .updateSurgeryStatus(value);
              },
              containerHintText:
                  state.selectedSurgeryStatus ?? "اختر حالة العملية",
              searchHintText: "ابحث عن حالة العملية",
            ),

            verticalSpacing(16),

            /// "المستشفى / المركز"

            UserSelectionContainer(
              allowManualEntry: true,
              categoryLabel: "المستشفى / المركز",
              containerHintText:
                  state.selectedHospitalCenter ?? "اختر اسم المستشفى/المركز",
              options: state.hospitals,
              onOptionSelected: (value) {
                context
                    .read<SurgeryDataEntryCubit>()
                    .updateSelectedHospitalCenter(value);
              },
              bottomSheetTitle: 'اختر اسم المستشفى/المركز',
              searchHintText: "ابحث عن المستشفى/المركز",
            ),

            verticalSpacing(16),

            ///"اسم الجراح"
            //   //! write by ur hand
            UserSelectionContainer(
              allowManualEntry: true,
              categoryLabel: "اسم الجراح",
              containerHintText: state.surgeonName ?? "اختر اسم الطبيب الجراح",
              options: state.doctorNames,
              onOptionSelected: (value) {
                context
                    .read<SurgeryDataEntryCubit>()
                    .updateSelectedSurgeonName(value);
              },
              bottomSheetTitle: "اختر اسم الطبيب الجراح",
              searchHintText: "ابحث عن اسم الطبيب الجراح",
            ),

            verticalSpacing(16),

            /// "اسم طبيب الباطنة"

            UserSelectionContainer(
              allowManualEntry: true,
              options: state.doctorNames,
              categoryLabel: "اسم طبيب الباطنة",
              bottomSheetTitle: "اختر اسم طبيب الباطنة",
              onOptionSelected: (value) {
                context
                    .read<SurgeryDataEntryCubit>()
                    .updateSelectedInternist(value);
              },
              containerHintText: state.internistName ?? "اختر اسم طبيب الباطنة",
              searchHintText: "ابحث عن اسم طبيب الباطنة",
            ),

            verticalSpacing(16),
            Text(
              "تعليمات بعد العملية",
              style: AppTextStyles.font18blackWight500,
            ),
            verticalSpacing(10),

            WordLimitTextField(
              hintText: "اكتب باختصار أى تعليمات طبية",
              controller:
                  context.read<SurgeryDataEntryCubit>().postSurgeryInstructions,
            ),
            verticalSpacing(10),

            ///الدولة
            UserSelectionContainer(
              options: state.countriesNames,
              categoryLabel: "الدولة",
              bottomSheetTitle: "اختر اسم الدولة",
              onOptionSelected: (value) {
                context
                    .read<SurgeryDataEntryCubit>()
                    .updateSelectedCountry(value);
              },
              containerHintText: state.selectedCountryName ?? "اختر اسم الدولة",
              searchHintText: "ابحث عن اسم الدولة",
            ),

            verticalSpacing(16),
            Text(
              "ملاحظات اضافية",
              style: AppTextStyles.font18blackWight500,
            ),
            verticalSpacing(10),

            WordLimitTextField(
              hintText: "اكتب باختصار أى معلومات مهمة أخرى",
              controller:
                  context.read<SurgeryDataEntryCubit>().personalNotesController,
            ),

            ///TODO: handle this button in main view and remove it from here
            /// final section
            verticalSpacing(32),
            submitSurgeryEntryButtonBlocConsumer(),
            verticalSpacing(71),
          ],
        );
      },
    );
  }

  Widget submitSurgeryEntryButtonBlocConsumer() {
    return BlocConsumer<SurgeryDataEntryCubit, SurgeryDataEntryState>(
      listenWhen: (prev, curr) =>
          curr.surgeriesDataEntryStatus == RequestStatus.failure ||
          curr.surgeriesDataEntryStatus == RequestStatus.success,
      buildWhen: (prev, curr) =>
          prev.isFormValidated != curr.isFormValidated ||
          prev.surgeriesDataEntryStatus != curr.surgeriesDataEntryStatus,
      listener: (context, state) async {
        if (state.surgeriesDataEntryStatus == RequestStatus.success) {
          await showSuccess(state.message);
          if (!context.mounted) return;
          context.pop(
            result:
                true, //! send true back to test analysis details view inn order to check if its updated , then reload the view
          );
        } else {
          await showError(state.message);
        }
      },
      builder: (context, state) {
        return AppCustomButton(
          isLoading: state.surgeriesDataEntryStatus == RequestStatus.loading,
          title: context.translate.send,
          onPressed: () async {
            if (state.isFormValidated) {
              state.isEditMode
                  ? await context
                      .read<SurgeryDataEntryCubit>()
                      .submitUpdatedSurgery()
                  : await context.read<SurgeryDataEntryCubit>().postModuleData(
                        context.translate,
                      );
              log("xxx:Save Data Entry");
            }
          },
          isEnabled: state.isFormValidated ? true : false,
        );
      },
    );
  }
}
