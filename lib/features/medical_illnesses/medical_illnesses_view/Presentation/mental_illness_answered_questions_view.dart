import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:share_plus/share_plus.dart';
import 'package:we_care/core/di/dependency_injection.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/app_toasts.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/custom_app_bar_with_centered_title_widget.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/medical_illnesses/data/models/answered_question_model.dart';
import 'package:we_care/features/medical_illnesses/medical_illnesses_view/logic/mental_illness_data_view_cubit.dart';
import 'package:we_care/features/medical_illnesses/medical_illnesses_view/logic/mental_illness_data_view_state.dart';

class MentalIllnessYesAnswersView extends StatelessWidget {
  const MentalIllnessYesAnswersView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<MentalIllnessDataViewCubit>(
      create: (context) =>
          getIt<MentalIllnessDataViewCubit>()..getAllAnsweredQuestions(),
      child: Scaffold(
        appBar: AppBar(toolbarHeight: 0),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              BlocBuilder<MentalIllnessDataViewCubit, MentalIllnessDataViewState>(
                builder: (context, state) {
                  return AppBarWithCenteredTitle(
                    title: 'الأسئلة المجاب عليها بنعم',
                    titleColor: AppColorsManager.mainDarkBlue,
                    showShareButtonOnly: true,
                    shareFunction: () {
                      final hasYesAnswers = state.mentalIllnessAnsweredQuestions != null &&
                          state.mentalIllnessAnsweredQuestions!.isNotEmpty;
                      if (!hasYesAnswers) {
                        showError("لا توجد أسئلة مجاب عليها بنعم للمشاركة");
                        return;
                      }
                      final questionsText = state.mentalIllnessAnsweredQuestions!
                          .map((q) =>
                              "المحور: ${q.category}\nالسؤال: ${q.questionText}\nالنطاق: ${q.scope}\nالتاريخ: ${q.answeredDate}\n")
                          .join("\n\n");
                      Share.share('🧠📄 الأسئلة المجاب عليها بنعم 🧠📄\n\n$questionsText');
                    },
                  );
                },
              ),
              verticalSpacing(16),
              Expanded(child: buildQuestionTable(context)),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildQuestionTable(BuildContext context) {
    return BlocBuilder<MentalIllnessDataViewCubit, MentalIllnessDataViewState>(
      builder: (context, state) {
        if (state.requestStatus == RequestStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state.requestStatus == RequestStatus.failure) {
          return Center(
            child: Text(
              state.responseMessage ?? "حدث خطأ ما",
              style: AppTextStyles.font18blackWight500.copyWith(
                color: AppColorsManager.textColor,
              ),
            ),
          );
        }
        final answeredQuestions = state.mentalIllnessAnsweredQuestions;

        if (state.requestStatus == RequestStatus.success &&
            (answeredQuestions == null || answeredQuestions.isEmpty)) {
          return Center(
            child: Text(
              "لا توجد بيانات متاحة",
              style: AppTextStyles.font22MainBlueWeight700,
            ),
          );
        }

        return SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: DataTable(
            clipBehavior: Clip.antiAliasWithSaveLayer,
            headingRowColor: WidgetStateProperty.all(const Color(0xFF014C8A)),
            headingTextStyle: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold),
            columnSpacing: 5.w,
            dataRowHeight: 130.h,
            horizontalMargin: 8,
            showBottomBorder: true,
            border: TableBorder.all(
              borderRadius: BorderRadius.circular(16.r),
              color: Colors.grey.withAlpha(90),
              width: .7,
            ),
            decoration: BoxDecoration(
                color: AppColorsManager.secondaryColor.withAlpha(75),
                borderRadius: BorderRadius.circular(16.r)),
            columns: [
              _buildDataColumn("المحور"),
              _buildDataColumn("السؤال"),
              _buildDataColumn("النطاق"),
              _buildDataColumn("التاريخ"),
            ],
            rows: answeredQuestions!.map((q) {
              return DataRow(cells: [
                _buildDataCellCenter(q.category),
                _buildDataCellCenter(q.questionText, maxLines: 6),
                _buildDataCellCenter(q.scope),
                _buildDataCellCenter(
                  q.answeredDate,
                  maxLines: 2,
                ),
              ]);
            }).toList(),
          ),
        );
      },
    );
  }

  DataColumn _buildDataColumn(String title) {
    return DataColumn(
      headingRowAlignment: MainAxisAlignment.center,
      label: Center(
        child: Text(title,
            textAlign: TextAlign.center,
            style: AppTextStyles.font14whiteWeight600.copyWith(
              fontSize: 14.sp,
            )),
      ),
    );
  }

  // DataCell _buildDataCellCenter(String text, {int maxLines = 3, Color? color}) {
  //   return DataCell(
  //     Center(
  //       child: Text(
  //         text,
  //         maxLines: maxLines,
  //         textAlign: TextAlign.center,
  //         style: TextStyle(
  //           color: color ?? AppColorsManager.textColor,
  //           fontSize: 13.sp,
  //           fontWeight: FontWeight.w600,
  //         ),
  //       ),
  //     ),
  //   );
  // }
  DataCell _buildDataCellCenter(String text,
      {int maxLines = 3, Color? color, double? width}) {
    final content = Text(
      text,
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
      textAlign: TextAlign.center,
      style: TextStyle(
        color: color ?? AppColorsManager.textColor,
        fontSize: 13.sp,
        fontWeight: FontWeight.w600,
      ),
    );

    return DataCell(
      Center(
        child: width != null ? SizedBox(width: width, child: content) : content,
      ),
    );
  }
}

class QuestionData {
  final String date;
  final String sensitivity;
  final String domain;
  final String question;
  final String category;

  QuestionData({
    required this.date,
    required this.sensitivity,
    required this.domain,
    required this.question,
    required this.category,
  });
}
