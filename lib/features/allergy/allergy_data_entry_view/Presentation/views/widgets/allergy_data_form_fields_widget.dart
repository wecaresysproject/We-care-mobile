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
import 'package:we_care/core/global/SharedWidgets/dynamic_question_with_dynamic_answer_list_option.dart';
import 'package:we_care/core/global/SharedWidgets/general_yes_or_no_question_shared_widget.dart';
import 'package:we_care/core/global/SharedWidgets/options_selector_shared_container_widget.dart';
import 'package:we_care/core/global/SharedWidgets/show_image_picker_selection_widget.dart';
import 'package:we_care/core/global/SharedWidgets/word_limit_text_field_widget.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/allergy/allergy_data_entry_view/Presentation/views/widgets/medicine_name_selector_section_widget.dart';
import 'package:we_care/features/allergy/allergy_data_entry_view/logic/cubit/allergy_data_entry_cubit.dart';

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
                  ? "منذ الولادة او اختر تاريخ بداية الأعراض"
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
              allowManualEntry: true,
              categoryLabel: "مسببات الحساسية",
              containerHintText: state.selectedAllergyCauses.isEmpty
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

            verticalSpacing(16),
            UserSelectionContainer(
              allowManualEntry: true,

              categoryLabel:
                  "الأعراض الجانبية المتوقعة", // Another Dropdown Example
              containerHintText: state.expectedSideEffectSelection ??
                  "اختر الأعراض الجانبية المتوقعة",
              options: [
                "test1",
                "test2",
              ],
              onOptionSelected: (value) {
                context
                    .read<AllergyDataEntryCubit>()
                    .updateExpectedSideEffect(value);
              },
              bottomSheetTitle: "اختر الأعراض الجانبية المتوقعة",
              searchHintText: "ابحث عن الأعراض الجانبية المتوقعة",
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
              "التقرير الطبى/ اختبار الحساسية",
              style: AppTextStyles.font18blackWight500,
            ),
            verticalSpacing(10),
            SelectImageContainer(
              imagePath: "assets/images/t_shape_icon.png",
              label: "اكتب التقرير",
              onTap: () {},
            ),

            verticalSpacing(8),
            BlocListener<AllergyDataEntryCubit, AllergyDataEntryState>(
              listenWhen: (previous, current) =>
                  previous.uploadReportStatus != current.uploadReportStatus,
              listener: (context, state) async {
                if (state.uploadReportStatus ==
                    UploadReportRequestStatus.success) {
                  await showSuccess(state.message);
                }
                if (state.uploadReportStatus ==
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
                            .read<AllergyDataEntryCubit>()
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
