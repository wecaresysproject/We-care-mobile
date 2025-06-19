import 'package:flutter/material.dart';
import 'package:we_care/core/Database/dummy_data.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/app_custom_button.dart';
import 'package:we_care/core/global/SharedWidgets/date_time_picker_widget.dart';
import 'package:we_care/core/global/SharedWidgets/general_yes_or_no_question_shared_widget.dart';
import 'package:we_care/core/global/SharedWidgets/user_selection_container_shared_widget.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';

class EssenstialGlassesInformationsDataDataEntryTabBar extends StatelessWidget {
  const EssenstialGlassesInformationsDataDataEntryTabBar({super.key});

  @override
  Widget build(BuildContext context) {
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
            // containerBorderColor: state.startIssueDateSelection == null
            //     ? AppColorsManager.warningColor
            //     : AppColorsManager.textfieldOutsideBorderColor,
            // placeholderText: state.startIssueDateSelection == null
            //     ? isArabic()
            //         ? "يوم / شهر / سنة"
            //         : "Date / Month / Year"
            //     : state.startIssueDateSelection!,
            placeholderText: "يوم / شهر / سنة",
            onDateSelected: (pickedDate) {
              // context
              //     .read<DentalDataEntryCubit>()
              //     .updateStartIssueDate(pickedDate);
            },
          ),

          /// size between each categogry
          verticalSpacing(16),

          UserSelectionContainer(
            // containerBorderColor: state.syptomTypeSelection == null
            //     ? AppColorsManager.warningColor
            //     : AppColorsManager.textfieldOutsideBorderColor,
            categoryLabel: "اسم الطبيب",
            // containerHintText: state.syptomTypeSelection ?? "اختر نوع العرض",
            containerHintText: "اختر اسم الطبيب",
            options: doctorsList,
            onOptionSelected: (value) {
              // log("xxx:Selected: $value");
              // context.read<DentalDataEntryCubit>().updateTypeOfSyptom(value);
            },
            // bottomSheetTitle: state.syptomTypeSelection ?? "اختر نوع العرض",
            bottomSheetTitle: "اختر نوع العرض",
            searchHintText: "ابحث عن العرض",
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
              // context
              //     .read<TestAnalysisDataEntryCubit>()
              //     .updateSelectedHospital(value);
              // log("xxx:Selected: $value");
            },
            bottomSheetTitle: 'اختر اسم المستشفى/المركز',
            searchHintText: "ابحث عن اسم المستشفى/المركز",
            containerHintText: 'اختر اسم المركز/المستشفي',
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
  }
}
