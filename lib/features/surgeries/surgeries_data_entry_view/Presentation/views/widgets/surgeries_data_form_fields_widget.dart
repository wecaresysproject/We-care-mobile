import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_care/core/di/dependency_injection.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/app_toasts.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/Helpers/image_quality_detector.dart';
import 'package:we_care/core/global/SharedWidgets/app_custom_button.dart';
import 'package:we_care/core/global/SharedWidgets/date_time_picker_widget.dart';
import 'package:we_care/core/global/SharedWidgets/show_image_picker_selection_widget.dart';
import 'package:we_care/core/global/SharedWidgets/word_limit_text_field_widget.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/surgeries/surgeries_data_entry_view/logic/cubit/surgery_data_entry_cubit.dart';

import 'select_image_container_widget.dart';
import 'user_selection_container_widget.dart';

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
              placeholderText:
                  isArabic() ? "يوم / شهر / سنة" : "Date / Month / Year",
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
              containerHintText: "اختر منطقة العمليه",
              options: state.bodyParts,
              onOptionSelected: (value) {
                log("xxx:Selected: $value");
                context
                    .read<SurgeryDataEntryCubit>()
                    .updateSurgeryBodyPart(value);
              },
              bottomSheetTitle: state.surgeryBodyPartSelection ??
                  'اختر المنطقة الخاصة بالعمليه',
            ),

            verticalSpacing(16),
            UserSelectionContainer(
              categoryLabel: "منطقة العملية الفرعية",
              containerHintText: "اختر المنطقة التى تمت بها العملية",
              options: [
                "القلب",
                "القدم",
                "الظهر",
                "الصدر",
              ],
              onOptionSelected: (value) {
                // context.read<SurgeryDataEntryCubit>().updateXRayType(value);

                log("xxx:Selected: $value");
              },
              bottomSheetTitle: 'اختر المنطقة التى تمت بها العملية',
            ),

            verticalSpacing(16),
            UserSelectionContainer(
              allowManualEntry: true,
              containerBorderColor: state.surgeryNameSelection == null
                  ? AppColorsManager.warningColor
                  : AppColorsManager.textfieldOutsideBorderColor,
              categoryLabel: "اسم العملية", // Another Dropdown Example
              containerHintText: "اختر اسم العملية",
              options: [
                "1اسم العملية",
                "2اسم العملية",
                "3اسم العملية",
              ],
              onOptionSelected: (value) {
                context.read<SurgeryDataEntryCubit>().updateSurgeryName(value);
                log("xxx:Selected: $value");
              },
              bottomSheetTitle: "اختر اسم العملية",
            ),

            verticalSpacing(16),
            UserSelectionContainer(
              categoryLabel: "الهدف من الاجراء", // Another Dropdown Example
              containerHintText: "اختر الهدف من العملية",
              options: [
                "1الهدف من الاجراء",
                "2الهدف من الاجراء",
                "3الهدف من الاجراء",
              ],
              onOptionSelected: (value) {
                context.read<SurgeryDataEntryCubit>().updateSurgeryName(value);
                log("xxx:Selected: $value");
              },
              bottomSheetTitle: "اختر الهدف من العملية",
            ),
            verticalSpacing(16),
            UserSelectionContainer(
              categoryLabel: "التقنية المستخدمة", // Another Dropdown Example
              containerHintText: "اختر التقنية المستخدمة",
              options: [
                "1التقنية المستخدمة",
                "2التقنية المستخدمة",
                "3التقنية المستخدمة",
              ],
              onOptionSelected: (value) {
                context.read<SurgeryDataEntryCubit>().updateSurgeryName(value);
                log("xxx:Selected: $value");
              },
              bottomSheetTitle: "اختر التقنية المستخدمة",
            ),
            verticalSpacing(16),
            // TODO: use shared custom field instead
            UserSelectionContainer(
              categoryLabel: "توصيف العملية", // Another Dropdown Example
              containerHintText: "اكتب وصف للعملية",
              options: [
                "1التقنية المستخدمة",
                "2التقنية المستخدمة",
                "3التقنية المستخدمة",
              ],
              onOptionSelected: (value) {
                context.read<SurgeryDataEntryCubit>().updateSurgeryName(value);
                log("xxx:Selected: $value");
              },
              bottomSheetTitle: "اختر التقنية المستخدمة",
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
            BlocListener<SurgeryDataEntryCubit, SurgeryDataEntryState>(
              listenWhen: (prev, curr) =>
                  prev.surgeryUploadReportStatus !=
                  curr.surgeryUploadReportStatus,
              listener: (context, state) async {
                if (state.surgeryUploadReportStatus ==
                    UploadReportRequestStatus.success) {
                  await showSuccess(state.message);
                }
                if (state.surgeryUploadReportStatus ==
                    UploadReportRequestStatus.failure) {
                  await showError(state.message);
                }
              },
              child: SelectImageContainer(
                imagePath: "assets/images/photo_icon.png",
                label: "ارفق صورة",
                onTap: () async {
                  await showImagePicker(
                    context,
                    onImagePicked: (isImagePicked) async {
                      final picker = getIt.get<ImagePickerService>();
                      if (isImagePicked && picker.isImagePickedAccepted) {
                        await context
                            .read<SurgeryDataEntryCubit>()
                            .uploadReportImagePicked(
                              imagePath: picker.pickedImage!.path,
                            );
                      }
                    },
                  );
                },
              ),
            ),
            verticalSpacing(16),

            // //! حالة العمليه"

            UserSelectionContainer(
              categoryLabel: "حالة العملية",
              options: [
                "1حالة العملية",
                "2حالة العملية",
                "3حالة العملية",
              ],
              bottomSheetTitle: "اختر حالة العملية",
              onOptionSelected: (value) {
                log("xxx:Selected: $value");
              },
              containerHintText: "اختر حالة العملية",
            ),

            verticalSpacing(16),

            /// "المستشفى / المركز"

            UserSelectionContainer(
              categoryLabel: "المستشفى / المركز",
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

            ///"اسم الجراح"
            //   //! write by ur hand
            UserSelectionContainer(
              allowManualEntry: true,
              categoryLabel: "اسم الجراح",
              containerHintText: "اختر اسم الطبيب الجراح",
              options: [
                "دكتور محمد محمد",
                "دكتور كريم محمد",
                "دكتور رشا محمد",
              ],
              onOptionSelected: (value) {
                log("xxx:Selected: $value");
              },
              bottomSheetTitle: "اختر اسم الطبيب الجراح",
            ),

            verticalSpacing(16),

            /// "اسم طبيب الباطنة"

            UserSelectionContainer(
              options: [
                "د / محمد محمد",
                "د / كريم محمد",
                "د / رشا محمد",
                "د / رشا مصطفى",
              ],
              categoryLabel: "اسم طبيب الباطنة",
              bottomSheetTitle: "اختر اسم طبيب الباطنة",
              onOptionSelected: (value) {},
              containerHintText: "اختر اسم طبيب الباطنة",
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
                  context.read<SurgeryDataEntryCubit>().personalNotesController,
            ),

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
            AppCustomButton(
              title: "ارسال",
              onPressed: () {
                if (state.isFormValidated) {
                  // context.read<XRayDataEntryCubit>().sendForm;
                  log("xxx:Save Data Entry");
                } else {
                  log("form not validated");
                }
              },
              isEnabled: state.isFormValidated ? true : false,
            ),
            verticalSpacing(71),
          ],
        );
      },
    );
  }
}
