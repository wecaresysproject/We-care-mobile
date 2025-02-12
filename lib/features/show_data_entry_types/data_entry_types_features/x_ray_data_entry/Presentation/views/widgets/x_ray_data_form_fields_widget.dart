import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/app_custom_button.dart';
import 'package:we_care/core/global/SharedWidgets/custom_textfield.dart';
import 'package:we_care/core/global/SharedWidgets/show_image_picker_selection.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/show_data_entry_types/data_entry_types_features/x_ray_data_entry/Presentation/views/widgets/date_time_picker_widget.dart';
import 'package:we_care/features/show_data_entry_types/data_entry_types_features/x_ray_data_entry/Presentation/views/widgets/select_image_container_widget.dart';
import 'package:we_care/features/show_data_entry_types/data_entry_types_features/x_ray_data_entry/Presentation/views/widgets/user_selection_container_widget.dart';
import 'package:we_care/features/show_data_entry_types/data_entry_types_features/x_ray_data_entry/logic/cubit/x_ray_data_entry_cubit.dart';

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
              placeholderText:
                  isArabic() ? "يوم / شهر / سنة" : "Date / Month / Year",
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
              containerHintText: "اختر العضو الخاص بالأشعة",
              options: [
                "أشعة الصدر",
                "أشعة البطن",
                "أشعة اليد",
                "أشعة القدم",
                "أشعة العمود الفقري",
                "أشعة الأسنان",
              ],
              onOptionSelected: (value) {
                log("xxx:Selected: $value");
                context.read<XRayDataEntryCubit>().updateXRayBodyPart(value);
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
              options: [
                "فحص الدم",
                "فحص البول",
                "فحص القلب",
                "أشعة سينية",
              ],
              onOptionSelected: (value) {
                context.read<XRayDataEntryCubit>().updateXRayType(value);

                log("xxx:Selected: $value");
              },
              bottomSheetTitle: 'اختر نوع الأشعة',
            ),

            verticalSpacing(16),
            UserSelectionContainer(
              categoryLabel:
                  "نوعية الاحتياج للأشعة", // Another Dropdown Example
              containerHintText: "اختر نوعية احتياجك للأشعة",
              options: [
                "فحص الدم",
                "فحص البول",
                "فحص القلب",
                "أشعة سينية",
              ],
              onOptionSelected: (value) {
                log("xxx:Selected: $value");
              },
              bottomSheetTitle: 'اختر نوع الأشعة',
            ),

            verticalSpacing(16),
            Text(
              "الصورة",
              style: AppTextStyles.font18blackWight500,
            ),
            verticalSpacing(10),
            SelectImageContainer(
              containerBorderColor: (state.isXRayPictureSelected == null) ||
                      (state.isXRayPictureSelected == false)
                  ? AppColorsManager.warningColor
                  : AppColorsManager.textfieldOutsideBorderColor,
              imagePath: "assets/images/photo_icon.png",
              label: "ارفق صورة",
              onTap: () async {
                await showImagePicker(
                  context,
                  onImagePicked: (isImagePicked) {
                    context
                        .read<XRayDataEntryCubit>()
                        .updateXRayPicture(isImagePicked);
                  },
                );
              },
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
            SelectImageContainer(
              imagePath: "assets/images/photo_icon.png",
              label: " ارفق صورة للتقرير",
              onTap: () async {
                await showImagePicker(context);
              },
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
              allowManualEntry: true,
              options: ["مصر", "الامارات", "السعوديه", "الكويت", "العراق"],
              categoryLabel: "الدولة",
              bottomSheetTitle: "اختر اسم الدولة",
              onOptionSelected: (value) {},
              containerHintText: "اختر اسم الدولة",
            ),

            verticalSpacing(16),
            Text(
              "ملاحظات شخصية",
              style: AppTextStyles.font18blackWight500,
            ),
            verticalSpacing(10),
            CustomTextField(
              validator: (value) {},
              isPassword: false,
              showSuffixIcon: false,
              keyboardType: TextInputType.text,
              hintText: "اكتب باختصار أى معلومات مهمة أخرى",
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
                  log("");
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
