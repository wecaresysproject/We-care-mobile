import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/app_toasts.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/app_custom_button.dart';
import 'package:we_care/core/global/SharedWidgets/date_time_picker_widget.dart';
import 'package:we_care/core/global/SharedWidgets/searchable_user_selector_container.dart';
import 'package:we_care/core/global/SharedWidgets/user_selection_container_shared_widget.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/emergency_complaints/emergency_complaints_data_entry/logic/cubit/emergency_complaint_details_cubit.dart';
import 'package:we_care/features/test_laboratory/data/models/test_table_model.dart';
import 'package:we_care/features/test_laboratory/test_analysis_data_entry/Presentation/views/widgets/test_selection_bottom_sheet.dart';
import 'package:we_care/features/test_laboratory/test_analysis_data_entry/Presentation/views/widgets/uploaded_reports_section_widget.dart';
import 'package:we_care/features/test_laboratory/test_analysis_data_entry/Presentation/views/widgets/uploaded_test_images_section_widget.dart';
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
            UploadedTestImagesSection(),

            verticalSpacing(16),
            UploadedReportsSection(),

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
              searchHintText: "ابحث عن دورية التحليل",
            ),

            verticalSpacing(16),
            // //! الأعراض المستدعية للاجراء"

            SymptomsRequiringInterventionSelector(),
            verticalSpacing(16),

            UserSelectionContainer(
              initialValue: state.selectedLabCenter?.isEmptyOrNull == true
                  ? null
                  : state.selectedLabCenter,
              isDisabled: state.selectedHospitalName.isNotEmptyOrNull,
              allowManualEntry: true,
              onDismiss: () {
                context
                    .read<TestAnalysisDataEntryCubit>()
                    .updateSelectedLabCenter("");
              },
              categoryLabel: "مركز التحاليل",
              containerHintText: state.selectedHospitalName.isNotEmptyOrNull
                  ? "المستشفى محددة، لا يمكن الإختيار "
                  : (state.selectedLabCenter.isEmptyOrNull
                      ? "اختر اسم المركز"
                      : state.selectedLabCenter!),
              options: state.labCenters,
              onOptionSelected: (value) {
                context
                    .read<TestAnalysisDataEntryCubit>()
                    .updateSelectedLabCenter(value);
              },
              bottomSheetTitle: 'اختر اسم المركز',
              searchHintText: "ابحث عن اسم المركز",
            ),
            verticalSpacing(16),

            /// المركز / المستشفى
            //   //! write by ur hand
            UserSelectionContainer(
              initialValue: state.selectedHospitalName?.isEmptyOrNull == true
                  ? null
                  : state.selectedHospitalName,
              onDismiss: () {
                context
                    .read<TestAnalysisDataEntryCubit>()
                    .updateSelectedHospital("");
              },
              isDisabled: state.selectedLabCenter.isNotEmptyOrNull,
              allowManualEntry: true,
              categoryLabel: "المعمل / المستشفى",
              containerHintText: state.selectedLabCenter.isNotEmptyOrNull
                  ? "مركز التحاليل محدد، لا يمكن الإختيار "
                  : (state.selectedHospitalName.isEmptyOrNull
                      ? "اختر اسم المعمل / المستشفى"
                      : state.selectedHospitalName!),
              options: state.hospitalNames,
              onOptionSelected: (value) {
                context
                    .read<TestAnalysisDataEntryCubit>()
                    .updateSelectedHospital(value);
                log("xxx:Selected: $value");
              },
              bottomSheetTitle: 'اختر اسم المستشفى/المركز',
              searchHintText: "ابحث عن اسم المستشفى/المركز",
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
                    .read<TestAnalysisDataEntryCubit>()
                    .updateSelectedDoctorName(value);
                log("xxx:Selected: $value");
              },
              containerHintText:
                  state.selectedDoctorName ?? "اختر اسم الطبيب المعالج ",
              searchHintText: "ابحث عن اسم الطبيب المعالج ",
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
              searchHintText: "ابحث عن اسم الدولة",
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
                          searchHintText: "ابحث عن اسم التحليل",
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
                          searchHintText: "ابحث عن اسم التحليل",
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
                          searchHintText: "ابحث عن اسم المجموعة",
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
                          searchHintText: "ابحث عن اسم المجموعة",
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
                          searchHintText: "ابحث عن الرمز",
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
                          searchHintText: "ابحث عن الرمز",
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
          fontSize: 14.sp,
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
              dataRowMaxHeight: 100.h,
              horizontalMargin: 2,
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
    _buildColumn("وصفية"), // 👈 العمود الجديد
  ];
}

List<DataRow> _buildRows(
    List<TableRowReponseModel> tableRows, BuildContext context) {
  return tableRows.map(
    (data) {
      final bool hasPercentage = data.hasApercentage ?? false;
      final bool isSelected = (data.selectedChoice?.isNotEmpty ?? false);

      return DataRow(
        cells: [
          _buildCell(
            data.testName,
            isNameColumn: true,
            fontSize: 16.5,
          ),
          _buildCell(
            data.testCode,
            fontSize: 18,
            isNameColumn: true,
          ),
          _buildCell(
            data.standardRate,
            fontSize: 16,
          ),
          DataCell(
            data.hasApercentage!
                ? buildStyledTextField(tableRows, data.testName, context)
                : Row(
                    children: [
                      Text(
                        "اختر من النتيجة الوصفية",
                        style: AppTextStyles.font12blackWeight400.copyWith(
                          fontWeight: FontWeight.w700,
                          fontSize: 12.sp,
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward,
                        color: AppColorsManager.mainDarkBlue,
                        size: 32,
                      ),
                    ],
                  ),
          ),
          // 👇 العمود الجديد - زرار "اختر"
          DataCell(
            Center(
              child: ElevatedButton(
                onPressed: hasPercentage
                    ? null // 👈 Disabled لو التحليل له نسبة
                    : () {
                        _showSelectionBottomSheet(
                          context: context,
                          title: "اختر النتيجة لـ ${data.testName}",
                          options: data.testChoices ?? [],
                          searchHintText: "ابحث عن النتيجة...",
                          userEntryLabelText: "أدخل نتيجة يدوياً",
                          initialSelectedItem: context
                              .read<TestAnalysisDataEntryCubit>()
                              .getSelectedChoiceAccordingToTestName(
                                data.testName,
                              ),
                          onItemSelected: (value) {
                            for (var element in tableRows) {
                              if (element.testName == data.testName) {
                                element.selectedChoice = value;

                                break;
                              }
                            }

                            context
                                .read<TestAnalysisDataEntryCubit>()
                                .updateTestTableRowsData(tableRows);
                          },
                        );
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: hasPercentage
                      ? Colors.grey.shade400
                      : isSelected
                          ? Colors.green
                          : AppColorsManager.mainDarkBlue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  padding:
                      EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                ),
                child: Text(
                  isSelected ? "تم الاختيار" : "اختر",
                  style: AppTextStyles.font12blackWeight400.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    },
  ).toList();
}

void _showSelectionBottomSheet({
  required BuildContext context,
  required String title,
  required List<String> options,
  required Function(String) onItemSelected,
  required String userEntryLabelText,
  required String searchHintText,
  String? initialSelectedItem,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(18.r),
      ),
    ),
    builder: (context) => TestSelectionBottomSheet(
      title: title,
      options: options,
      onItemSelected: onItemSelected,
      userEntryLabelText: userEntryLabelText,
      initialSelectedItem: initialSelectedItem,
      searchHintText: searchHintText,
    ),
  );
}

DataColumn _buildColumn(
  String label, {
  bool isNumeric = false,
}) {
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

DataCell _buildCell(
  String text, {
  bool isNameColumn = false,
  double fontSize = 14,
}) {
  return DataCell(
    Container(
      alignment: Alignment.center,
      constraints: BoxConstraints(
        // عمود الاسم ياخد عرض أكبر شوية
        maxWidth: isNameColumn ? 120.w : 70.w,
        minWidth: isNameColumn ? 100.w : 50.w,
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        maxLines: isNameColumn ? 4 : 1,
        style: AppTextStyles.font12blackWeight400.copyWith(
          fontWeight: FontWeight.w700,
          fontSize: fontSize.sp,
        ),
      ),
    ),
  );
}

// class SymptomsRequiringInterventionSelector extends StatelessWidget {
//   const SymptomsRequiringInterventionSelector({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<EmergencyComplaintDataEntryDetailsCubit,
//         MedicalComplaintDataEntryDetailsState>(
//       buildWhen: (previous, current) =>
//           previous.medicalSymptomsIssue != current.medicalSymptomsIssue,
//       builder: (context, state) {
//         final xrayCubit = context.read<TestAnalysisDataEntryCubit>();

//         return SearchableUserSelectorContainer(
//           allowManualEntry: true,
//           categoryLabel: "الأعراض المستدعية للاجراء",
//           bottomSheetTitle: "اختر الأعراض المستدعية",
//           containerHintText:
//               state.medicalSymptomsIssue ?? "اختر الأعراض المستدعية",
//           onOptionSelected: (value) {
//             xrayCubit.updateSymptomsRequiringIntervention(value);
//           },
//           searchHintText: "ابحث عن الأعراض المستدعية",
//         );
//       },
//     );
//   }
// }

class SymptomsRequiringInterventionSelector extends StatelessWidget {
  const SymptomsRequiringInterventionSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EmergencyComplaintDataEntryDetailsCubit,
        MedicalComplaintDataEntryDetailsState>(
      buildWhen: (previous, current) =>
          previous.medicalSymptomsIssue != current.medicalSymptomsIssue,
      builder: (context, emergencyState) {
        final cubit = context.read<TestAnalysisDataEntryCubit>();

        return BlocBuilder<TestAnalysisDataEntryCubit,
            TestAnalysisDataEntryState>(
          buildWhen: (previous, current) =>
              previous.symptomsRequiringIntervention !=
              current.symptomsRequiringIntervention,
          builder: (context, xrayState) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SearchableUserSelectorContainer(
                  allowManualEntry: true,
                  categoryLabel: "الأعراض المستدعية للإجراء",

                  /// لو مفيش ولا عرض مختار → هينزل hint
                  /// لو فيه → يظهر عددها
                  containerHintText:
                      emergencyState.medicalSymptomsIssue.isEmptyOrNull
                          ? "اختر الأعراض المستدعية"
                          : "${emergencyState.medicalSymptomsIssue}",

                  bottomSheetTitle: "اختر الأعراض المستدعية",
                  searchHintText: "ابحث عن الأعراض",

                  onOptionSelected: (value) {
                    cubit.updateSymptomsRequiringIntervention(value);
                  },
                ),

                /// لو المستخدم اختار أعراض → اعرضهم بشكل Chips
                if (xrayState.symptomsRequiringIntervention.isNotEmpty) ...[
                  verticalSpacing(12),
                  Text(
                    "الأعراض المحددة:",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.start,
                  ),
                  verticalSpacing(6),
                  Wrap(
                    spacing: 8.0,
                    runSpacing: 4.0,
                    children: xrayState.symptomsRequiringIntervention.map(
                      (symptom) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color:
                                  AppColorsManager.mainDarkBlue.withAlpha(100),
                              width: 2,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Expanded(
                                child: Text(
                                  symptom,
                                  style: const TextStyle(
                                    fontSize: 14,
                                  ),
                                  maxLines: 10,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              verticalSpacing(4),
                              GestureDetector(
                                onTap: () {
                                  cubit.removeSymptomRequiringIntervention(
                                      symptom);
                                },
                                child: const Icon(
                                  Icons.close,
                                  size: 16,
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ).toList(),
                  ),
                ],
              ],
            );
          },
        );
      },
    );
  }
}

// store all objects in a list to use it later, and if user try to choose one of drop down  again
// it will be removed from the list
// validate that as minumum one field is not empty to submit the form
