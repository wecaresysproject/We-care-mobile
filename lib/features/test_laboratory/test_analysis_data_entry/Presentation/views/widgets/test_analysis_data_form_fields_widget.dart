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
import 'package:we_care/features/show_data_entry_types/data_entry_types_features/prescription_data_entry/Presentation/views/widgets/select_image_container_widget.dart';
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
              containerBorderColor: state.isDateSelected == null
                  ? AppColorsManager.warningColor
                  : AppColorsManager.textfieldOutsideBorderColor,
              placeholderText:
                  isArabic() ? "يوم / شهر / سنة" : "Date / Month / Year",
              onDateSelected: (pickedDate) {
                context.read<TestAnalysisDataEntryCubit>().updateTestDate(
                      pickedDate,
                    );
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
            BlocListener<TestAnalysisDataEntryCubit,
                TestAnalysisDataEntryState>(
              listenWhen: (prev, curr) =>
                  prev.testImageRequestStatus != curr.testImageRequestStatus,
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
              listenWhen: (prev, curr) =>
                  prev.testReportRequestStatus != curr.testReportRequestStatus,
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
              options: state.countriesNames,
              categoryLabel: state.selectedCountryName ?? "الدولة",
              bottomSheetTitle: "اختر اسم الدولة",
              onOptionSelected: (selectedCountry) {
                context
                    .read<TestAnalysisDataEntryCubit>()
                    .updateSelectedCountry(selectedCountry);
              },
              containerHintText: "اختر اسم الدولة",
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
                  ? buildTable().paddingTop(16)
                  : SizedBox.shrink(), // Hide when not visible
            ),
          ],
        );
      },
    );
  }
}

Widget buildTable() {
  return SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: DataTable(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      headingRowColor: WidgetStateProperty.all(
        AppColorsManager.mainDarkBlue,
      ),
      columnSpacing: 16.8.w,
      dataRowMaxHeight: 44.5.h,
      horizontalMargin: 7,
      dividerThickness: .83,
      headingTextStyle: AppTextStyles.font16DarkGreyWeight400.copyWith(
        color: AppColorsManager.backGroundColor,
        fontWeight: FontWeight.w600,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          0,
        ),
      ),
      showBottomBorder: true,
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
          ),
          headingRowAlignment: MainAxisAlignment.center,
        ),
        DataColumn(
          label: Text(
            "الرمز",
          ),
          headingRowAlignment: MainAxisAlignment.center,
        ),
        DataColumn(
          label: Text(
            "المعيار",
          ),
          headingRowAlignment: MainAxisAlignment.center,
          numeric: true,
        ),
        DataColumn(
          label: Text(
            "النتيجة",
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
    ),
  );
}

Widget buildStyledTextField() {
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
