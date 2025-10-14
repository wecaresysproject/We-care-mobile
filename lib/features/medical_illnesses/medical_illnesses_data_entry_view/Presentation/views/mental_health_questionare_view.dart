import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/SharedWidgets/custom_app_bar_with_centered_title_widget.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/medical_illnesses/data/models/fcm_message_model.dart';
import 'package:we_care/features/medical_illnesses/medical_illnesses_data_entry_view/Presentation/views/widgets/progress_header_widget.dart';
import 'package:we_care/features/medical_illnesses/medical_illnesses_data_entry_view/Presentation/views/widgets/question_card_widget.dart';
import 'package:we_care/features/medical_illnesses/medical_illnesses_data_entry_view/Presentation/views/widgets/send_questions_button_widget.dart';

class MentalHealthQuestionnaireView extends StatefulWidget {
  final List<FcmQuestionModel> questions;
  final int patchNumber;
  const MentalHealthQuestionnaireView({
    super.key,
    required this.questions,
    required this.patchNumber,
  });

  @override
  State<MentalHealthQuestionnaireView> createState() =>
      _MentalHealthQuestionnairePageState();
}

class _MentalHealthQuestionnairePageState
    extends State<MentalHealthQuestionnaireView> {
  double progress = 0.0;

  @override
  void initState() {
    super.initState();
    _updateProgress();
  }

  void _updateProgress() {
    final answeredCount =
        widget.questions.where((q) => q.answer != null).length;
    progress = answeredCount / widget.questions.length;
  }

  void _onAnswerChanged(int questionIndex, bool answer) {
    setState(() {
      // عمل نسخة جديدة بالموديل مع تحديث الإجابة
      widget.questions[questionIndex] = FcmQuestionModel(
        id: widget.questions[questionIndex].id,
        text: widget.questions[questionIndex].text,
        answer: answer,
      );

      _updateProgress();
    });
  }

  bool get isAllQuestionsAnswered =>
      widget.questions.every((q) => q.answer != null);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(toolbarHeight: 0),
//       body: Padding(
//         padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
//         child: Column(
//           children: [
//             AppBarWithCenteredTitle(
//               title: 'تقييم الحالة النفسية',
//               showActionButtons: false,
//               titleColor: AppColorsManager.mainDarkBlue,
//             ),

//             ProgressHeader(progress: progress),
//             Expanded(
//               child: ListView.builder(
//                 padding: const EdgeInsets.all(16),
//                 itemCount: widget.questions.length,
//                 itemBuilder: (context, index) {
//                   return Padding(
//                     padding: const EdgeInsets.only(bottom: 16),
//                     child: QuestionCard(
//                       question: widget.questions[index],
//                       selectedAnswer: widget.questions[index].answer,
//                       onAnswerChanged: (answer) =>
//                           _onAnswerChanged(index, answer),
//                     ),
//                   );
//                 },
//               ),
//             ),

//             /// ✅ زرار الإجابة الكاملة
//             ElevatedButton(
//               onPressed: () {
//                 setState(() {
//                   for (int i = 0; i < widget.questions.length; i++) {
//                     widget.questions[i] = FcmQuestionModel(
//                       id: widget.questions[i].id,
//                       text: widget.questions[i].text,
//                       answer: true,
//                     );
//                   }
//                   _updateProgress();
//                 });
//               },
//               child: Text('الإجابة على الكل بـ نعم'),
//             ),

//             /// زرار الإرسال
//             SendButtonBlocConsumer(
//               isAllQuestionsAnswered: isAllQuestionsAnswered,
//               questions: widget.questions,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(toolbarHeight: 0),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
        child: Column(
          children: [
            AppBarWithCenteredTitle(
              title: 'تقييم الحالة النفسية',
              showActionButtons: false,
              titleColor: AppColorsManager.mainDarkBlue,
            ),
            Text(
              'تقرير رقم (15/${widget.patchNumber})',
              style: AppTextStyles.font22WhiteWeight600.copyWith(
                color: AppColorsManager.mainDarkBlue,
              ),
            ),
            ProgressHeader(progress: progress),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: widget.questions.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: QuestionCard(
                      question: widget.questions[index],
                      selectedAnswer: widget.questions[index].answer,
                      onAnswerChanged: (answer) =>
                          _onAnswerChanged(index, answer),
                    ),
                  );
                },
              ),
            ),
            SendButtonBlocConsumer(
              isAllQuestionsAnswered: isAllQuestionsAnswered,
              questions: widget.questions, // يفضل null لو مش كلهم جاوبوا
            ),
          ],
        ),
      ),
    );
  }
}
