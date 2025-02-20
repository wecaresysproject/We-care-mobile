import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/di/dependency_injection.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/Helpers/image_quality_detector.dart';
import 'package:we_care/core/global/SharedWidgets/app_custom_button.dart';
import 'package:we_care/core/global/SharedWidgets/show_image_picker_selection_widget.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/show_data_entry_types/data_entry_types_features/test_analysis_data_entry/logic/cubit/test_analysis_data_entry_cubit.dart';
import 'package:we_care/features/show_data_entry_types/data_entry_types_features/x_ray_data_entry/Presentation/views/widgets/date_time_picker_widget.dart';
import 'package:we_care/features/show_data_entry_types/data_entry_types_features/x_ray_data_entry/Presentation/views/widgets/select_image_container_widget.dart';
import 'package:we_care/features/show_data_entry_types/data_entry_types_features/x_ray_data_entry/Presentation/views/widgets/user_selection_container_widget.dart';

class TestAnalysisDataEntryFormFields extends StatefulWidget {
  const TestAnalysisDataEntryFormFields({super.key});

  @override
  State<TestAnalysisDataEntryFormFields> createState() =>
      _TestAnalysisDataEntryFormFieldsState();
}

class _TestAnalysisDataEntryFormFieldsState
    extends State<TestAnalysisDataEntryFormFields> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TestAnalysisDataEntryCubit, TestAnalysisDataEntryState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "تاريخ التحاليل",
              style: AppTextStyles.font18blackWight500,
            ),
            verticalSpacing(10),

            DateTimePickerContainer(
              // containerBorderColor: state.xRayDateSelection == null
              //     ? AppColorsManager.warningColor
              //     : AppColorsManager.textfieldOutsideBorderColor,
              placeholderText:
                  isArabic() ? "يوم / شهر / سنة" : "Date / Month / Year",
              onDateSelected: (pickedDate) {
                // context.read<XRayDataEntryCubit>().updateXRayDate(pickedDate);
                log("xxx: pickedDate: $pickedDate"); //! 2024-02-14
              },
            ),

            /// size between each categogry
            verticalSpacing(16),
            TypeOfTestAndAnnotationWidget(),
            verticalSpacing(16),
            Text(
              "الصورة",
              style: AppTextStyles.font18blackWight500,
            ),
            verticalSpacing(10),
            SelectImageContainer(
              // containerBorderColor: (state.isXRayPictureSelected == null) ||
              //         (state.isXRayPictureSelected == false)
              //     ? AppColorsManager.warningColor
              //     : AppColorsManager.textfieldOutsideBorderColor,
              imagePath: "assets/images/photo_icon.png",
              label: "ارفق صورة",
              onTap: () async {
                await showImagePicker(
                  context,
                  onImagePicked: (isImagePicked) {
                    // context
                    //     .read<XRayDataEntryCubit>()
                    //     .updateXRayPicture(isImagePicked);

                    final picker = getIt.get<ImagePickerService>();
                    if (isImagePicked && picker.isImagePickedAccepted) {
                      log("xxx: image path: ${picker.pickedImage?.path}");
                    }
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
                await showImagePicker(
                  context,
                  onImagePicked: (isImagePicked) {
                    final picker = getIt.get<ImagePickerService>();
                    if (isImagePicked && picker.isImagePickedAccepted) {
                      log("xxx: image path: ${picker.pickedImage?.path}");
                    }
                  },
                );
              },
            ),
            verticalSpacing(16),

            UserSelectionContainer(
              allowManualEntry: true,
              options: [
                "فحص الدم",
                "فحص البول",
                "فحص القلب",
                "أشعة سينية",
              ],
              categoryLabel: "نوعية الاحتياج للتحليل",
              bottomSheetTitle: "اختر الأعراض المستدعية",
              onOptionSelected: (value) {
                log("xxx:Selected: $value");
              },
              containerHintText: "اختر نوعية احتياجك للتحليل",
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

            /// المركز / المستشفى
            //   //! write by ur hand
            UserSelectionContainer(
              allowManualEntry: true,
              categoryLabel: "المعمل / المستشفى",
              containerHintText: "اختر اسم المعمل / المستشفى",
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
              containerHintText: "اختر اسم الطبيب المعالج ",
            ),

            verticalSpacing(16),

            ///الدولة
            UserSelectionContainer(
              allowManualEntry: false,
              options: [
                "مصر",
                "الامارات",
                "السعوديه",
                "الكويت",
                "العراق",
              ],
              categoryLabel: "الدولة",
              bottomSheetTitle: "اختر اسم الدولة",
              onOptionSelected: (value) {},
              containerHintText: "اختر اسم الدولة",
            ),

            ///TODO: handle this button in main view and remove it from here
            /// final section
            verticalSpacing(32),
            AppCustomButton(
              title: "ارسال",
              onPressed: () {
                // if (state.isFormValidated) {
                //   // context.read<XRayDataEntryCubit>().sendForm;
                //   log("xxx:Save Data Entry");
                // } else {
                //   log("");
                // }
              },
              // isEnabled: state.isFormValidated ? true : false,
            ),
            verticalSpacing(71),
          ],
        );
      },
    );
  }
}

class TypeOfTestAndAnnotationWidget extends StatelessWidget {
  const TypeOfTestAndAnnotationWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              flex: 3,
              child: UserSelectionContainer(
                // containerBorderColor: state.xRayBodyPartSelection == null
                //     ? AppColorsManager.warningColor
                //     : AppColorsManager.textfieldOutsideBorderColor,
                categoryLabel: "نوع التحليل",
                containerHintText: "اختر نوع التحليل",
                options: [
                  "تحليل الدم",
                  "تحليل البول",
                  "تحليل صورة دم كامله",
                ],
                onOptionSelected: (value) {
                  log("xxx:Selected: $value");
                  // context.read<XRayDataEntryCubit>().updateXRayBodyPart(value);
                },
                bottomSheetTitle: 'اختر نوع التحليل',
              ),
            ),
            horizontalSpacing(16),
            Expanded(
              flex: 2,
              child: UserSelectionContainer(
                // containerBorderColor: state.xRayTypeSelection == null
                //     ? AppColorsManager.warningColor
                //     : AppColorsManager.textfieldOutsideBorderColor,
                categoryLabel: "الرمز",
                containerHintText: "اختر الرمز ",
                options: [
                  "CBC",
                  "RBC",
                  "WBC",
                  "HGB",
                  "HCT",
                  "MCV",
                ],
                onOptionSelected: (value) {
                  // context.read<XRayDataEntryCubit>().updateXRayType(value);

                  log("xxx:Selected: $value");
                },
                bottomSheetTitle: 'اختر نوع الأشعة',
              ),
            ),
          ],
        ),
        if (true) buildTable().paddingTop(16),
      ],
    );
  }
}

Widget buildTable() {
  return DataTable(
    clipBehavior: Clip.antiAliasWithSaveLayer,
    headingRowColor: WidgetStateProperty.all(
      AppColorsManager.mainDarkBlue,
    ),
    columnSpacing: 12.w,
    border: TableBorder.all(
      style: BorderStyle.solid,
      borderRadius: BorderRadius.circular(8.r),
      color: Color(0xff909090),
      width: .15.w,
    ),
    columns: [
      DataColumn(
        label: Text(
          "الاسم",
          style: AppTextStyles.font16DarkGreyWeight400.copyWith(
            color: AppColorsManager.backGroundColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        headingRowAlignment: MainAxisAlignment.center,
      ),
      DataColumn(
        label: Text(
          "الرمز",
          style: AppTextStyles.font16DarkGreyWeight400.copyWith(
            color: AppColorsManager.backGroundColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        headingRowAlignment: MainAxisAlignment.center,
      ),
      DataColumn(
        label: Text(
          "المعيار",
          style: AppTextStyles.font16DarkGreyWeight400.copyWith(
            color: AppColorsManager.backGroundColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        headingRowAlignment: MainAxisAlignment.center,
        numeric: true,
      ),
      DataColumn(
        label: Text(
          "النتيجة",
          style: AppTextStyles.font16DarkGreyWeight400.copyWith(
            color: AppColorsManager.backGroundColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        headingRowAlignment: MainAxisAlignment.center,
      ),
    ],
    rows: [
      DataRow(
        cells: [
          DataCell(
            Text(
              "كرات الدم البيضاء",
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.font14blackWeight400.copyWith(
                fontWeight: FontWeight.w700,
                fontSize: 12.sp,
              ),
            ),
          ),
          DataCell(
            Text(
              "H.Pylori",
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.font12blackWeight400.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 12.sp,
              ),
            ),
          ),
          DataCell(
            Text(
              "55520:100200",
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: AppTextStyles.font12blackWeight400.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 12.7.sp,
              ),
            ),
          ),
          DataCell(
            buildStyledTextField(),
          ),
        ],
      ),
      DataRow(
        cells: [
          DataCell(
            Text(
              "كرات الدم الحمراء",
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.font14blackWeight400.copyWith(
                fontWeight: FontWeight.w700,
                fontSize: 12.sp,
              ),
            ),
          ),
          DataCell(
            Text(
              "H.Pylori",
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.font12blackWeight400.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 12.sp,
              ),
            ),
          ),
          DataCell(
            Text(
              "55520:100200",
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: AppTextStyles.font12blackWeight400.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 12.7.sp,
              ),
            ),
          ),
          DataCell(
            buildStyledTextField(),
          ),
        ],
      ),
      DataRow(
        cells: [
          DataCell(
            Text(
              "الهيموجلوبين",
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.font14blackWeight400.copyWith(
                fontWeight: FontWeight.w700,
                fontSize: 12.sp,
              ),
            ),
          ),
          DataCell(
            Text(
              "H.Pylori",
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.font12blackWeight400.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 12.sp,
              ),
            ),
          ),
          DataCell(
            Text(
              "55520:100200",
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: AppTextStyles.font12blackWeight400.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 12.7.sp,
              ),
            ),
          ),
          DataCell(
            buildStyledTextField(),
          ),
        ],
      ),
      DataRow(
        cells: [
          DataCell(
            Text(
              "الصفائح الدموية",
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.font14blackWeight400.copyWith(
                fontWeight: FontWeight.w700,
                fontSize: 12.sp,
              ),
            ),
          ),
          DataCell(
            Text(
              "H.Pylori",
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.font12blackWeight400.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 12.sp,
              ),
            ),
          ),
          DataCell(
            Text(
              "55520:100200",
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: AppTextStyles.font12blackWeight400.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 12.7.sp,
              ),
            ),
          ),
          DataCell(
            buildStyledTextField(),
          ),
        ],
      ),
    ],
  );
}

Widget buildStyledTextField() {
  return TextField(
    textAlign: TextAlign.center,
    cursorColor: AppColorsManager.mainDarkBlue,
    decoration: InputDecoration(
      border: InputBorder.none,
      focusedBorder: InputBorder.none,
      enabledBorder: InputBorder.none,
      errorBorder: InputBorder.none,
      disabledBorder: InputBorder.none,
      hintText: "اكتب النسبة",
      contentPadding: EdgeInsets.symmetric(
        horizontal: 1.w,
      ), // Ensure text starts at center

      hintStyle: AppTextStyles.font12blackWeight400.copyWith(
        fontWeight: FontWeight.w700,
        color: AppColorsManager.placeHolderColor,
      ),
    ),
    keyboardType: TextInputType.number,
  ).paddingFrom(
    top: 2,
    left: 0,
  );
}
