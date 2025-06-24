import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_care/core/Database/dummy_data.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/app_custom_button.dart';
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
              UserSelectionContainer(
                allowManualEntry: true,
                categoryLabel: "محل النظارات",
                // containerHintText:
                //     state.selectedHospitalName ?? "اختر اسم المعمل / المستشفى",

                options: [],
                onOptionSelected: (value) {
                  // context
                  //     .read<TestAnalysisDataEntryCubit>()
                  //     .updateSelectedHospital(value);
                  // log("xxx:Selected: $value");
                },
                bottomSheetTitle: "اختر اسم محل النظارات",

                searchHintText: "ابحث عن اسم محل النظارات",
                containerHintText: 'اختر اسم محل النظارات',
              ),
              verticalSpacing(16),

              GenericQuestionWidget(
                questionTitle: "مضاد للانعكاس",
                onAnswerChanged: (p0) {},
              ),
              verticalSpacing(16),

              GenericQuestionWidget(
                questionTitle: "حماية من الضوء الأزرق",
                onAnswerChanged: (p0) {},
              ),
              verticalSpacing(16),

              GenericQuestionWidget(
                questionTitle: "مقاومة للخدش",
                onAnswerChanged: (p0) {},
              ),
              verticalSpacing(16),

              GenericQuestionWidget(
                questionTitle: "طبقة مضادة للبصمات",
                onAnswerChanged: (p0) {},
              ),
              verticalSpacing(16),

              GenericQuestionWidget(
                questionTitle: "طبقة مضادة للضباب",
                onAnswerChanged: (p0) {},
              ),
              verticalSpacing(16),

              GenericQuestionWidget(
                questionTitle: "طبقة حماية من الأشعة فوق البنفسجية",
                onAnswerChanged: (p0) {},
              ),
              verticalSpacing(40),
              AppCustomButton(
                isLoading: false,
                title: "ارسال",
                onPressed: () async {},
                isEnabled: true,
              ),
            ],
          ),
        );
      },
    );
  }
}
