import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/di/dependency_injection.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/app_toasts.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/Helpers/image_quality_detector.dart';
import 'package:we_care/core/global/SharedWidgets/app_custom_button.dart';
import 'package:we_care/core/global/SharedWidgets/date_time_picker_widget.dart';
import 'package:we_care/core/global/SharedWidgets/show_image_picker_selection_widget.dart';
import 'package:we_care/core/global/SharedWidgets/user_selection_container_shared_widget.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/test_laboratory/data/models/test_table_model.dart';
import 'package:we_care/features/test_laboratory/test_analysis_data_entry/Presentation/views/widgets/select_image_container_widget.dart';
import 'package:we_care/features/test_laboratory/test_analysis_data_entry/logic/cubit/test_analysis_data_entry_cubit.dart';

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
              containerBorderColor: state.selectedDate == null
                  ? AppColorsManager.warningColor
                  : AppColorsManager.textfieldOutsideBorderColor,
              placeholderText: state.selectedDate ?? "يوم / شهر / سنة",
              onDateSelected: (pickedDate) {
                context.read<TestAnalysisDataEntryCubit>().updateTestDate(
                      pickedDate,
                    );
                log("xxx: pickedDate: $pickedDate"); //! 2024-02-14
              },
            ),

            if (!state.isEditMode) ...[
              // /// size between each categogry
              verticalSpacing(16),
              TypeOfTestAndAnnotationWidget(),
              verticalSpacing(16),
            ],
            Text(
              "الصورة",
              style: AppTextStyles.font18blackWight500,
            ),
            verticalSpacing(10),
            BlocListener<TestAnalysisDataEntryCubit,
                TestAnalysisDataEntryState>(
              listener: (context, state) async {
                if (state.testImageRequestStatus ==
                    UploadImageRequestStatus.success) {
                  await showSuccess(state.message);
                }
                if (state.testImageRequestStatus ==
                    UploadImageRequestStatus.failure) {
                  await showError(state.message);
                }
              },
              child: SelectImageContainer(
                containerBorderColor: (state.isTestPictureSelected == null) ||
                        (state.isTestPictureSelected == false)
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
                        context
                            .read<TestAnalysisDataEntryCubit>()
                            .updateTestPicture(isImagePicked);
                        await context
                            .read<TestAnalysisDataEntryCubit>()
                            .uploadLaboratoryTestImagePicked(
                              imagePath: picker.pickedImage!.path,
                            );
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
            BlocListener<TestAnalysisDataEntryCubit,
                TestAnalysisDataEntryState>(
              listener: (context, state) async {
                if (state.testReportRequestStatus ==
                    UploadReportRequestStatus.success) {
                  await showSuccess(state.message);
                }
                if (state.testReportRequestStatus ==
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
                        await context
                            .read<TestAnalysisDataEntryCubit>()
                            .uploadLaboratoryTestReportPicked(
                              imagePath: picker.pickedImage!.path,
                            );
                      }
                    },
                  );
                },
              ),
            ),
            verticalSpacing(16),

            UserSelectionContainer(
              allowManualEntry: true,
              options: [
                "اسبوعية",
                "شهرية",
                "كل ثلاث شهور",
                "كل ست شهور",
                "كل عام",
              ],
              categoryLabel: "دورية التحليل",
              bottomSheetTitle: "اختر دورية التحليل",
              onOptionSelected: (value) {
                context
                    .read<TestAnalysisDataEntryCubit>()
                    .updateTimesTestPerformed(value);
                log("xxx:Selected: $value");
              },
              containerHintText:
                  state.selectedNoOftimesTestPerformed ?? "اختر دورية التحليل",
            ),

            verticalSpacing(16),
            // //! الأعراض المستدعية للاجراء"

            UserSelectionContainer(
              allowManualEntry: true,
              options: [
                "عرض واحد",
                "عرض اتنين",
                "عرض ثلاثة",
              ],
              categoryLabel: "الأعراض المستدعية للاجراء",
              bottomSheetTitle: "اختر الأعراض المستدعية",
              onOptionSelected: (value) {
                context
                    .read<TestAnalysisDataEntryCubit>()
                    .updateSelectedSymptom(value);
                log("xxx:Selected: $value");
              },
              containerHintText: state.selectedSymptomsForProcedure ??
                  "اختر الأعراض المستدعية",
            ),

            verticalSpacing(16),

            /// المركز / المستشفى
            //   //! write by ur hand
            UserSelectionContainer(
              allowManualEntry: true,
              categoryLabel: "المعمل / المستشفى",
              containerHintText:
                  state.selectedHospitalName ?? "اختر اسم المعمل / المستشفى",
              options: [
                "مستشفى القلب",
                "مستشفى العين الدولى",
                "مستشفى 57357",
              ],
              onOptionSelected: (value) {
                context
                    .read<TestAnalysisDataEntryCubit>()
                    .updateSelectedHospital(value);
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
              onOptionSelected: (value) {
                context
                    .read<TestAnalysisDataEntryCubit>()
                    .updateSelectedDoctorName(value);
                log("xxx:Selected: $value");
              },
              containerHintText:
                  state.selectedDoctorName ?? "اختر اسم الطبيب المعالج ",
            ),

            verticalSpacing(16),

            ///الدولة
            UserSelectionContainer(
              options: state.countriesNames,
              categoryLabel: "الدولة",
              bottomSheetTitle: "اختر اسم الدولة",
              onOptionSelected: (selectedCountry) {
                context
                    .read<TestAnalysisDataEntryCubit>()
                    .updateSelectedCountry(selectedCountry);
              },
              containerHintText: state.selectedCountryName ?? "اختر اسم الدولة",
            ),

            ///TODO: handle this button in main view and remove it from here
            /// final section
            verticalSpacing(32),

            submitTestAnalysisEntryButtonBlocConsumer(),
            verticalSpacing(71),
          ],
        );
      },
    );
  }

  Widget submitTestAnalysisEntryButtonBlocConsumer() {
    return BlocConsumer<TestAnalysisDataEntryCubit, TestAnalysisDataEntryState>(
      listenWhen: (prev, curr) =>
          curr.testAnalysisDataEntryStatus == RequestStatus.failure ||
          curr.testAnalysisDataEntryStatus == RequestStatus.success,
      buildWhen: (prev, curr) =>
          prev.isFormValidated != curr.isFormValidated ||
          prev.testAnalysisDataEntryStatus != curr.testAnalysisDataEntryStatus,
      listener: (context, state) async {
        if (state.testAnalysisDataEntryStatus == RequestStatus.success) {
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
          isLoading: state.testAnalysisDataEntryStatus == RequestStatus.loading,
          title: context.translate.send,
          onPressed: () async {
            if (state.isFormValidated) {
              state.isEditMode
                  ? await context
                      .read<TestAnalysisDataEntryCubit>()
                      .submitEditsOnTest()
                  : await context
                      .read<TestAnalysisDataEntryCubit>()
                      .postLaboratoryTestDataEntrered(
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

class TypeOfTestAndAnnotationWidget extends StatelessWidget {
  const TypeOfTestAndAnnotationWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TestAnalysisDataEntryCubit, TestAnalysisDataEntryState>(
      builder: (context, state) {
        bool showTable = !state.isTestNameSelected.isEmptyOrNull ||
            !state.isTestCodeSelected.isEmptyOrNull ||
            !state.isTestGroupNameSelected.isEmptyOrNull;
        return Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: !state.isTestCodeSelected.isEmptyOrNull ||
                          !state.isTestGroupNameSelected.isEmptyOrNull
                      ? UserSelectionContainer(
                          isDisabled: true,
                          containerBorderColor: AppColorsManager
                              .disAbledTextFieldOutsideBorderColor,
                          categoryLabel: "اسم التحليل",
                          containerHintText: "اختر الاسم",
                          options: state.testNames,
                          onOptionSelected: (value) {
                            log("xxx:Selected: $value");
                            context
                                .read<TestAnalysisDataEntryCubit>()
                                .updateTestName(value);
                          },
                          iconColor: AppColorsManager.disAbledIconColor,
                          bottomSheetTitle: 'اختر اسم التحليل',
                        )
                      : UserSelectionContainer(
                          isDisabled: false,
                          containerBorderColor: state
                                  .isTestNameSelected.isEmptyOrNull
                              ? AppColorsManager.warningColor
                              : AppColorsManager.textfieldOutsideBorderColor,
                          categoryLabel: "اسم التحليل",
                          containerHintText: "اختر نوع التحليل",
                          options: state.testNames,
                          onOptionSelected: (value) {
                            log("xxx:Selected: $value");
                            context
                                .read<TestAnalysisDataEntryCubit>()
                                .updateTestName(value);
                          },
                          iconColor: AppColorsManager.mainDarkBlue,
                          bottomSheetTitle: 'اختر اسم التحليل',
                        ),
                ),
                horizontalSpacing(16),
                Expanded(
                  child: !state.isTestNameSelected.isEmptyOrNull ||
                          !state.isTestCodeSelected.isEmptyOrNull
                      ? UserSelectionContainer(
                          containerBorderColor: AppColorsManager
                              .disAbledTextFieldOutsideBorderColor,
                          iconColor: AppColorsManager.disAbledIconColor,
                          isDisabled: true,
                          categoryLabel: "المجموعه",
                          containerHintText: "اختر المجموعه",
                          options: state.testGroupNames,
                          onOptionSelected: (value) {
                            context
                                .read<TestAnalysisDataEntryCubit>()
                                .updateGroupNameSelection(value);
                            log("xxx:Selected: $value");
                          },
                          bottomSheetTitle: 'اختر اسم المجموعة',
                        )
                      : UserSelectionContainer(
                          containerBorderColor: state
                                  .isTestGroupNameSelected.isEmptyOrNull
                              ? AppColorsManager.warningColor
                              : AppColorsManager.textfieldOutsideBorderColor,
                          categoryLabel: "المجموعه",
                          containerHintText: "اختر المجموعه",
                          options: state.testGroupNames,
                          onOptionSelected: (value) {
                            context
                                .read<TestAnalysisDataEntryCubit>()
                                .updateGroupNameSelection(value);
                          },
                          bottomSheetTitle: 'اختر اسم المجموعة',
                        ),
                ),
                horizontalSpacing(16),
                Expanded(
                  child: !state.isTestNameSelected.isEmptyOrNull ||
                          !state.isTestGroupNameSelected.isEmptyOrNull
                      ? UserSelectionContainer(
                          containerBorderColor: AppColorsManager
                              .disAbledTextFieldOutsideBorderColor,
                          iconColor: AppColorsManager.disAbledIconColor,
                          isDisabled: true,
                          categoryLabel: "الرمز",
                          containerHintText: "اختر الرمز",
                          options: state.testCodes,
                          onOptionSelected: (value) {
                            context
                                .read<TestAnalysisDataEntryCubit>()
                                .updateTestCodeSelection(value);
                            log("xxx:Selected: $value");
                          },
                          bottomSheetTitle: 'اختر الرمز',
                        )
                      : UserSelectionContainer(
                          containerBorderColor: state
                                  .isTestCodeSelected.isEmptyOrNull
                              ? AppColorsManager.warningColor
                              : AppColorsManager.textfieldOutsideBorderColor,
                          categoryLabel: "الرمز",
                          containerHintText: "اختر الرمز",
                          options: state.testCodes,
                          onOptionSelected: (value) {
                            context
                                .read<TestAnalysisDataEntryCubit>()
                                .updateTestCodeSelection(value);
                            log("xxx:Selected: $value");
                          },
                          bottomSheetTitle: 'اختر الرمز',
                        ),
                ),
              ],
            ),
            AnimatedSwitcher(
              duration: Duration(milliseconds: 1100),
              transitionBuilder: (child, animation) {
                return FadeTransition(
                  opacity: animation,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: Offset(0.0, 0.2), // Start slightly below
                      end: Offset.zero,
                    ).animate(animation),
                    child: child,
                  ),
                );
              },
              child: showTable
                  ? buildTable(state.testTableRowsData).paddingTop(16)
                  : SizedBox.shrink(), // Hide when not visible
            ),
          ],
        );
      },
    );
  }
}

Widget buildStyledTextField(List<TableRowReponseModel> tableRows,
    String testName, BuildContext context) {
  return Container(
    margin: EdgeInsets.only(
      bottom: 3,
    ),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(12.r),
      gradient: LinearGradient(
        end: Alignment.centerRight,
        begin: Alignment.centerLeft,
        colors: [
          Color(0xffECF5FF),
          Color(0xffFBFDFF),
        ],
      ),
    ),
    child: TextField(
      scrollPhysics: const BouncingScrollPhysics(),
      onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
      onChanged: (value) {
        //! try to handle it later, and make backend to make it have intial value with 0.0
        double percentValue =
            double.tryParse(value) ?? 0.0; // Ensure it's a double

        for (var element in tableRows) {
          if (element.testName == testName) {
            element.testWrittenPercent = percentValue;
            break;
          }
        }
        context
            .read<TestAnalysisDataEntryCubit>()
            .updateTestTableRowsData(tableRows);
      },
      textAlign: TextAlign.center,
      cursorHeight: 20.h,
      cursorColor: AppColorsManager.mainDarkBlue,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        hintText: "اكتب النسبة",
        contentPadding: EdgeInsets.symmetric(
          horizontal: 13.w,
          vertical: 8.5.h,
        ),
        hintStyle: AppTextStyles.font12blackWeight400.copyWith(
          fontWeight: FontWeight.w700,
          fontSize: 10.sp,
          color: AppColorsManager.placeHolderColor,
          overflow: TextOverflow.ellipsis,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(
            width: 0.5.w,
            color: AppColorsManager.textfieldOutsideBorderColor,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(
            width: 0.8.w,
            color: AppColorsManager.mainDarkBlue,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(
            width: 0.5.w,
            color: AppColorsManager.textfieldOutsideBorderColor,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(
            width: 0.5.w,
            color: AppColorsManager.warningColor,
          ),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(
            width: 0.5.w,
            color: Colors.grey,
          ),
        ),
      ),
    ).paddingFrom(
      top: 2,
    ),
  );
}

Widget buildTable(List<TableRowReponseModel> tableRows) {
  return LayoutBuilder(
    builder: (context, constraints) {
      double screenWidth = constraints.maxWidth;
      double columnSpacing = screenWidth * 0.02;

      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: screenWidth,
            maxWidth: screenWidth,
          ),
          child: FittedBox(
            alignment: Alignment.centerLeft,
            child: DataTable(
              clipBehavior: Clip.antiAliasWithSaveLayer,
              headingRowColor: WidgetStateProperty.all(
                AppColorsManager.mainDarkBlue,
              ),
              columnSpacing: columnSpacing,
              dataRowMaxHeight: 44.5.h,
              horizontalMargin: 7,
              dividerThickness: 0.83,
              headingTextStyle: AppTextStyles.font16DarkGreyWeight400.copyWith(
                color: AppColorsManager.backGroundColor,
                fontWeight: FontWeight.w600,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(0),
              ),
              showBottomBorder: true,
              border: TableBorder.all(
                style: BorderStyle.solid,
                borderRadius: BorderRadius.circular(8.r),
                color: const Color(0xff909090),
                width: 0.15.w,
              ),
              columns: _buildColumns(),
              rows: _buildRows(tableRows, context),
            ),
          ),
        ),
      );
    },
  );
}

List<DataColumn> _buildColumns() {
  return [
    _buildColumn("الاسم"),
    _buildColumn("الرمز"),
    _buildColumn("المعيار", isNumeric: true),
    _buildColumn("النتيجة"),
  ];
}

List<DataRow> _buildRows(
    List<TableRowReponseModel> tableRows, BuildContext context) {
  return tableRows.map(
    (data) {
      return DataRow(
        cells: [
          _buildCell(data.testName, isBold: true),
          _buildCell(data.testCode),
          _buildCell(data.standardRate),
          DataCell(
            buildStyledTextField(tableRows, data.testName, context),
          ),
        ],
      );
    },
  ).toList();
}

DataColumn _buildColumn(String label, {bool isNumeric = false}) {
  return DataColumn(
    label: Expanded(
      child: Center(
        child: Text(
          label,
          textAlign: TextAlign.center,
        ),
      ),
    ),
    numeric: isNumeric,
  );
}

DataCell _buildCell(String text, {bool isBold = false}) {
  return DataCell(
    Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Text(
        text,
        textAlign: TextAlign.center,
        overflow: TextOverflow.ellipsis,
        style: AppTextStyles.font12blackWeight400.copyWith(
          fontWeight: isBold ? FontWeight.w700 : FontWeight.w600,
          fontSize: 12.sp,
        ),
      ),
    ),
  );
}

// store all objects in a list to use it later, and if user try to choose one of drop down  again
// it will be removed from the list
// validate that as minumum one field is not empty to submit the form
