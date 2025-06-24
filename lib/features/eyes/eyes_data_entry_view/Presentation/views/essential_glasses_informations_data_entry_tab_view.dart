import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_care/core/Database/dummy_data.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/app_toasts.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/app_custom_button.dart';
import 'package:we_care/core/global/SharedWidgets/custom_textfield.dart';
import 'package:we_care/core/global/SharedWidgets/date_time_picker_widget.dart';
import 'package:we_care/core/global/SharedWidgets/general_yes_or_no_question_shared_widget.dart';
import 'package:we_care/core/global/SharedWidgets/user_selection_container_shared_widget.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/eyes/eyes_data_entry_view/logic/cubit/glasses_data_entry_cubit.dart';

class EssenstialGlassesInformationsDataDataEntryTabBar extends StatelessWidget {
  const EssenstialGlassesInformationsDataDataEntryTabBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GlassesDataEntryCubit, GlassesDataEntryState>(
      builder: (context, state) {
        return SingleChildScrollView(
          scrollDirection: Axis.vertical,
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "تاريخ الفحص",
                style: AppTextStyles.font18blackWight500,
              ),
              verticalSpacing(10),

              DateTimePickerContainer(
                containerBorderColor: state.examinationDateSelection == null
                    ? AppColorsManager.warningColor
                    : AppColorsManager.textfieldOutsideBorderColor,
                placeholderText: state.examinationDateSelection == null
                    ? isArabic()
                        ? "يوم / شهر / سنة"
                        : "Date / Month / Year"
                    : state.examinationDateSelection!,
                onDateSelected: (pickedDate) {
                  context
                      .read<GlassesDataEntryCubit>()
                      .updateExaminationDate(pickedDate);
                },
              ),

              /// size between each categogry
              verticalSpacing(16),

              UserSelectionContainer(
                categoryLabel: "اسم الطبيب",
                containerHintText: state.doctorName ?? "اختر اسم الطبيب",
                options: [],
                onOptionSelected: (value) {
                  context
                      .read<GlassesDataEntryCubit>()
                      .updateSelectedDoctor(value);
                },
                bottomSheetTitle: "اختر اسم الدكتور",
                searchHintText: "ابحث عن اسم الدكتور",
              ),

              verticalSpacing(16),

              /// المركز / المستشفى
              //   //! write by ur hand
              UserSelectionContainer(
                allowManualEntry: true,
                categoryLabel: "المعمل / المستشفى",
                // containerHintText:
                //     state.selectedHospitalName ?? "اختر اسم المعمل / المستشفى",

                options: hosptitalsNames,
                onOptionSelected: (value) {
                  context
                      .read<GlassesDataEntryCubit>()
                      .updateSelectedHospital(value);
                  // log("xxx:Selected: $value");
                },
                bottomSheetTitle: 'اختر اسم المستشفى/المركز',
                searchHintText: "ابحث عن اسم المستشفى/المركز",
                containerHintText:
                    state.selectedHospitalCenter ?? 'اختر اسم المركز/المستشفي',
              ),

              verticalSpacing(16),
              Text(
                " محل النظارات",
                style: AppTextStyles.font18blackWight500,
              ),
              verticalSpacing(10),
              CustomTextField(
                hintText: state.glassesStore ?? "اكتب اسم المحل",
                validator: (value) {},
                onChanged: (value) {
                  context
                      .read<GlassesDataEntryCubit>()
                      .updateSelectedGlassesStore(value);
                },
              ),

              verticalSpacing(16),

              GenericQuestionWidget(
                questionTitle: "مضاد للانعكاس",
                initialValue: state.antiReflection,
                onAnswerChanged: (p0) {
                  context
                      .read<GlassesDataEntryCubit>()
                      .updateAntiReflection(p0);
                },
              ),
              verticalSpacing(16),

              GenericQuestionWidget(
                questionTitle: "حماية من الضوء الأزرق",
                initialValue: state.isBlueLightProtection,
                onAnswerChanged: (p0) {
                  context.read<GlassesDataEntryCubit>().updateAntiBlueLight(p0);
                },
              ),
              verticalSpacing(16),

              GenericQuestionWidget(
                questionTitle: "مقاومة للخدش",
                initialValue: state.isScratchResistance,
                onAnswerChanged: (p0) {
                  context
                      .read<GlassesDataEntryCubit>()
                      .updateScratchResistance(p0);
                },
              ),
              verticalSpacing(16),

              GenericQuestionWidget(
                questionTitle: "طبقة مضادة للبصمات",
                initialValue: state.isAntiFingerprint,
                onAnswerChanged: (p0) {
                  context
                      .read<GlassesDataEntryCubit>()
                      .updateAntiFingerprint(p0);
                },
              ),
              verticalSpacing(16),

              GenericQuestionWidget(
                questionTitle: "طبقة مضادة للضباب",
                initialValue: state.isAntiFogCoating,
                onAnswerChanged: (p0) {
                  context
                      .read<GlassesDataEntryCubit>()
                      .updateAntiFogCoating(p0);
                },
              ),
              verticalSpacing(16),

              GenericQuestionWidget(
                questionTitle: "طبقة حماية من الأشعة فوق البنفسجية",
                initialValue: state.isUVProtection,
                onAnswerChanged: (p0) {
                  context.read<GlassesDataEntryCubit>().updateUVProtection(p0);
                },
              ),
              verticalSpacing(40),
              submitDataEnteredButtonBlocConsumer(),
              verticalSpacing(40),
            ],
          ),
        );
      },
    );
  }
}

Widget submitDataEnteredButtonBlocConsumer() {
  return BlocConsumer<GlassesDataEntryCubit, GlassesDataEntryState>(
    listenWhen: (prev, curr) =>
        curr.glassesEssentialDataEntryStatus == RequestStatus.failure ||
        curr.glassesEssentialDataEntryStatus == RequestStatus.success,
    buildWhen: (prev, curr) =>
        prev.isFormValidated != curr.isFormValidated ||
        prev.glassesEssentialDataEntryStatus !=
            curr.glassesEssentialDataEntryStatus,
    listener: (context, state) async {
      if (state.glassesEssentialDataEntryStatus == RequestStatus.success) {
        await showSuccess(state.message);
        if (!context.mounted) return;
        //* in order to catch it again to rebuild details view
        context.pop(result: true);
      } else {
        await showError(state.message);
      }
    },
    builder: (context, state) {
      return AppCustomButton(
        isLoading:
            state.glassesEssentialDataEntryStatus == RequestStatus.loading,
        title: context.translate.send,
        onPressed: () async {
          if (state.isFormValidated) {
            if (state.isEditMode) {
              await context
                  .read<GlassesDataEntryCubit>()
                  .submitGlassesEssentialDataEntryEndPoint(
                      locale: context.translate);
            }
          }
        },
        isEnabled: state.isFormValidated ? true : false,
      );
    },
  );
}
