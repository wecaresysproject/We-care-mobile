import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/app_toasts.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/app_custom_button.dart';
import 'package:we_care/core/global/SharedWidgets/date_time_picker_widget.dart';
import 'package:we_care/core/global/SharedWidgets/dynamic_question_with_dynamic_answer_list_option.dart';
import 'package:we_care/core/global/SharedWidgets/general_yes_or_no_question_shared_widget.dart';
import 'package:we_care/core/global/SharedWidgets/options_selector_shared_container_widget.dart';
import 'package:we_care/core/global/SharedWidgets/report_uploader_section_widget.dart';
import 'package:we_care/core/global/SharedWidgets/word_limit_text_field_widget.dart';
import 'package:we_care/core/global/SharedWidgets/write_report_screen.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/allergy/allergy_data_entry_view/Presentation/views/widgets/medicine_name_selector_section_widget.dart';
import 'package:we_care/features/allergy/allergy_data_entry_view/logic/cubit/allergy_data_entry_cubit.dart';
import 'package:we_care/features/genetic_diseases/genetic_diseases_data_entry/Presentation/views/widgets/genetic_disease_template_widget.dart';

import '../../../../../../core/global/SharedWidgets/select_image_container_shared_widget.dart';
import '../../../../../../core/global/SharedWidgets/user_selection_container_shared_widget.dart';

class AllergyDataFormFieldsWidget extends StatefulWidget {
  const AllergyDataFormFieldsWidget({super.key});

  @override
  State<AllergyDataFormFieldsWidget> createState() =>
      _AllergyDataFormFieldsWidgetState();
}

class _AllergyDataFormFieldsWidgetState
    extends State<AllergyDataFormFieldsWidget> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AllergyDataEntryCubit, AllergyDataEntryState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "تاريخ الاصابة بالحساسية",
              style: AppTextStyles.font18blackWight500,
            ),
            verticalSpacing(10),

            DateTimePickerContainer(
              containerBorderColor: state.allergyDateSelection == null
                  ? AppColorsManager.warningColor
                  : AppColorsManager.textfieldOutsideBorderColor,
              placeholderText: state.allergyDateSelection == null
                  ? "اختر تاريخ بداية الأعراض"
                  : state.allergyDateSelection!,
              onDateSelected: (pickedDate) {
                context
                    .read<AllergyDataEntryCubit>()
                    .updateAllergyDate(pickedDate);
              },
            ),

            /// size between each categogry
            verticalSpacing(16),

            UserSelectionContainer(
              containerBorderColor: state.alleryTypeSelection == null
                  ? AppColorsManager.warningColor
                  : AppColorsManager.textfieldOutsideBorderColor,
              categoryLabel: "النوع",
              containerHintText:
                  state.alleryTypeSelection ?? "اختر نوع الحساسية",
              options: state.allergyTypes, //! get from backend
              onOptionSelected: (value) {
                context.read<AllergyDataEntryCubit>().updateAllergyType(value);
              },
              bottomSheetTitle:
                  state.alleryTypeSelection ?? 'اختر نوع الحساسية',
              searchHintText: 'اختر نوع الحساسية',
            ),

            verticalSpacing(16),

            UserSelectionContainer(
              isDisabled: state.allergyTriggers.isEmpty,
              allowManualEntry: true,
              categoryLabel: "مسببات الحساسية",
              containerHintText: state.alleryTypeSelection == null
                  ? 'اختر نوع الحساسية أولاً'
                  : state.selectedAllergyCauses.isEmpty
                      ? 'اختر الأشياء المسببة للحساسية'
                      : '${state.selectedAllergyCauses.length} مسببات محددة',

              options: state.allergyTriggers, //! get from backend
              onOptionSelected: (value) {
                context
                    .read<AllergyDataEntryCubit>()
                    .updateSelectedAllergyCauses(value);
              },
              bottomSheetTitle: 'اختر الأشياء المسببة للحساسية',
              searchHintText: 'ابحث عن الأشياء المسببة للحساسية',
            ),

            // Display selected allergy causes with remove option
            if (state.selectedAllergyCauses.isNotEmpty) ...[
              verticalSpacing(8),
              Text(
                "المسببات المحددة:",
                style: AppTextStyles.font14blackWeight400,
              ),
              verticalSpacing(4),
              Wrap(
                spacing: 8.0,
                runSpacing: 4.0,
                children: state.selectedAllergyCauses.map((cause) {
                  return Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: AppColorsManager.mainDarkBlue.withOpacity(0.3),
                        width: 2,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          cause,
                          style: AppTextStyles.font14blackWeight400,
                        ),
                        const SizedBox(width: 4),
                        GestureDetector(
                          onTap: () {
                            context
                                .read<AllergyDataEntryCubit>()
                                .removeAllergyCause(cause);
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
                }).toList(),
              ),
            ],

            if (state.expectedSideEffects.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  verticalSpacing(16),
                  Text(
                    "الأعراض الجانبية المتوقعة",
                    style: AppTextStyles.font18blackWight500,
                  ),
                  verticalSpacing(10),
                  ...state.expectedSideEffects.asMap().entries.map(
                        (e) => CustomContainer(
                          value: "${e.key + 1}. ${e.value}",
                          isExpanded: true,
                        ).paddingBottom(5),
                      ),
                ],
              ),

            verticalSpacing(16),
            Text(
              "حدة الأعراض",
              style: AppTextStyles.font18blackWight500,
            ),
            verticalSpacing(10),
            OptionSelectorWidget(
              options: [
                'خفيفة',
                'متوسطة',
                'شديدة',
              ],
              initialSelectedOption: state.selectedSyptomSeverity,
              onOptionSelected: (p0) {
                context.read<AllergyDataEntryCubit>().updateSyptomSeverity(p0);
              },
            ),
            verticalSpacing(16),

            UserSelectionContainer(
              categoryLabel:
                  "زمن بدء الأعراض بعد التعرض للمسبب", // Another Dropdown Example
              containerHintText: state.symptomOnsetAfterExposure ??
                  "اختر مدة ظهور الأعراض بعد التعرض للمسبب",
              options: [
                'خلال دقائق',
                'خلال ساعة',
                'بعد عدة ساعات',
                'يوم',
                'يومين',
                'غير معروف',
              ],
              onOptionSelected: (value) {
                context
                    .read<AllergyDataEntryCubit>()
                    .updateSymptomOnsetAfterExposure(value);
              },
              bottomSheetTitle: "مدة ظهور الأعراض بعد التعرض؟",
              searchHintText: "متى ظهرت الأعراض بعد التعرض للمسبب؟",
            ),
            verticalSpacing(16),

            GenericQuestionWidget(
              questionTitle: "هل تم استشارة طبيب؟",
              initialValue: state.isDoctorConsulted,
              onAnswerChanged: (p0) {
                context
                    .read<AllergyDataEntryCubit>()
                    .updateIsDoctorConsulted(p0);
              },
            ),
            verticalSpacing(16),

            GenericQuestionWidget(
              questionTitle: "هل تم اجراء اختبار للحساسية؟",
              initialValue: state.isAllergyTestDn,
              onAnswerChanged: (p0) {
                context
                    .read<AllergyDataEntryCubit>()
                    .updateIsAllergyTestDone(p0);
              },
            ),
            verticalSpacing(16),
            MedicineNameSelectorSection(),
            verticalSpacing(16),
            GenericQuestionWidget(
              questionTitle: "هل كانت العلاجات فعالة؟",
              initialValue: state.isTreatmentsEffective,
              onAnswerChanged: (p0) {
                context
                    .read<AllergyDataEntryCubit>()
                    .updateIsTreatmentsEffective(p0);
              },
            ),
            verticalSpacing(16),

            Text(
              "التقرير الطبى/ اختبار الحساسية (${state.reportsUploadedUrls.length}/8)",
              style: AppTextStyles.font18blackWight500,
            ),
            verticalSpacing(10),
            // SelectImageContainer(
            //   imagePath: "assets/images/t_shape_icon.png",
            //   label: "اكتب التقرير",
            //   onTap: () {},
            // ),
            SelectImageContainer(
              imagePath: "assets/images/t_shape_icon.png",
              label: context
                      .read<AllergyDataEntryCubit>()
                      .reportTextController
                      .text
                      .isEmpty
                  ? "اكتب التقرير"
                  : "تعديل التقرير",
              onTap: () async {
                // ✅ اقرا الـ cubit من الـ context الحالي
                final cubit = context.read<AllergyDataEntryCubit>();
                final isFirstTime = state.isEditMode;
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

            ReportUploaderSection<AllergyDataEntryCubit, AllergyDataEntryState>(
              statusSelector: (state) => state.uploadReportStatus,
              uploadedSelector: (state) => state.reportsUploadedUrls,
              resultMessage: state.message,
              onRemove: (imagePath) {
                context
                    .read<AllergyDataEntryCubit>()
                    .removeUploadedReport(imagePath);
              },
              onUpload: (path) async {
                await context
                    .read<AllergyDataEntryCubit>()
                    .uploadReportImagePicked(
                      imagePath: path,
                    );
              },
            ),

            verticalSpacing(16),
            Text(
              "التاريخ العائلى",
              style: AppTextStyles.font18blackWight500,
            ),
            verticalSpacing(10),

            WordLimitTextField(
              hintText: "اكتب باختصار الأشخاص المصابون",
              controller:
                  context.read<AllergyDataEntryCubit>().effectedFamilyMembers,
            ),
            verticalSpacing(16),

            Text(
              "الاحتياطات",
              style: AppTextStyles.font18blackWight500,
            ),
            verticalSpacing(10),
            WordLimitTextField(
              hintText: "اكتب باختصار الاحتياطات التى أخذتها",
              controller: context.read<AllergyDataEntryCubit>().precautions,
            ),
            verticalSpacing(16),

            QuestionWithDynamicAnswerListOption(
              options: [
                'نعم',
                'لا',
                'غير معروف',
              ],
              questionTitle: 'هل أنت معرض لصدمة تحسسية؟',
              initialValue: state.isAtRiskOfAnaphylaxis,
              onAnswerChanged: (val) {
                context
                    .read<AllergyDataEntryCubit>()
                    .updateIsAtRiskOfAnaphylaxis(val);
              },
            ),
            verticalSpacing(16),
            QuestionWithDynamicAnswerListOption(
              options: [
                'نعم',
                'لا',
                'غير معروف',
              ],
              questionTitle: 'هل يوجد تحذير طبى حين تتعرض لمسببات الحساسية ؟',
              initialValue: state.isThereMedicalWarningOnExposure,
              onAnswerChanged: (val) {
                context
                    .read<AllergyDataEntryCubit>()
                    .updateIsThereMedicalWarningOnExposure(val);
              },
            ),
            verticalSpacing(16),

            GenericQuestionWidget(
              questionTitle: "هل تحمل حقنة الإبينفرين بانتظام؟",
              initialValue: state.isEpinephrineInjectorCarried,
              onAnswerChanged: (p0) {
                context
                    .read<AllergyDataEntryCubit>()
                    .isEpinephrineInjectorCarried(p0);
              },
            ),
            verticalSpacing(40),

            /// final section
            submitAllergyEntryButtonBlocConsumer(),
          ],
        );
      },
    );
  }

  Widget submitAllergyEntryButtonBlocConsumer() {
    return BlocConsumer<AllergyDataEntryCubit, AllergyDataEntryState>(
      listenWhen: (prev, curr) =>
          curr.allergyDataEntryStatus == RequestStatus.failure ||
          curr.allergyDataEntryStatus == RequestStatus.success,
      buildWhen: (prev, curr) =>
          prev.isFormValidated != curr.isFormValidated ||
          prev.allergyDataEntryStatus != curr.allergyDataEntryStatus,
      listener: (context, state) async {
        if (state.allergyDataEntryStatus == RequestStatus.success) {
          await showSuccess(state.message);
          if (!context.mounted) return;
          context.pop(
              result:
                  true //! send true back to test analysis details view inn order to check if its updated , then reload the view
              );
        } else {
          await showError(state.message);
        }
      },
      builder: (context, state) {
        return AppCustomButton(
          isLoading: state.allergyDataEntryStatus == RequestStatus.loading,
          title: state.isEditMode ? "تحديت البيانات" : context.translate.send,
          onPressed: () async {
            if (state.isFormValidated) {
              state.isEditMode
                  ? await context
                      .read<AllergyDataEntryCubit>()
                      .updateAllergyDocumentById()
                  : await context.read<AllergyDataEntryCubit>().postModuleData(
                        context.translate,
                      );
            }
          },
          isEnabled: state.isFormValidated ? true : false,
        );
      },
    );
  }
}
