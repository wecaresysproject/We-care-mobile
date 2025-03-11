import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/test_laboratory/analysis_view/Presention/similar_analysis_view.dart';
import 'package:we_care/features/test_laboratory/analysis_view/logic/test_analysis_view_cubit.dart';
import 'package:we_care/features/test_laboratory/analysis_view/logic/test_analysis_view_state.dart';

class SimilarAnalysisCard extends StatelessWidget {
  final List<String> date;
  final List<String> names;
  final List<String> ranges;
  final List<String> results;
  final String interpretation;
  final String recommendation;
  final String id;
  final String testName;

  const SimilarAnalysisCard({
    Key? key,
    required this.date,
    required this.names,
    required this.ranges,
    required this.results,
    required this.interpretation,
    required this.recommendation,
    required this.testName,
    required this.id,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TestAnalysisViewCubit, TestAnalysisViewState>(
      buildWhen: (previous, current) => previous.isEditing != current.isEditing,
      builder: (context, state) {
        final cubit = context.read<TestAnalysisViewCubit>();
        final isEditing = state.isEditing && state.editingId == id;
        return Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
          margin: EdgeInsets.symmetric(vertical: 12.h),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFECF5FF), Color(0xFFFBFDFF)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Color(0xFF014C8A), width: 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildColumnItem(
                    icon: Icons.calendar_today,
                    label: 'التاريخ',
                    value: date,
                    context: context,
                  ),
                  _buildColumnItem(
                    icon: Icons.text_fields,
                    label: 'الاسم',
                    value: names,
                    context: context,
                    isHighlightValue: true,
                  ),
                  _buildColumnItem(
                    icon: Icons.linear_scale,
                    label: 'المعيار',
                    value: ranges,
                    context: context,
                  ),
                  _buildColumnItem(
                    icon: Icons.receipt_long,
                    label: 'النتيجة',
                    value: results,
                    context: context,
                  ),
                ],
              ),
              InterpretationDetailsContainerWithTitleRow(
                  content: interpretation, title: 'التفسير'),
              verticalSpacing(8),
              InterpretationDetailsContainerWithTitleRow(
                  content: recommendation, title: 'التوصيات'),
              if (isEditing)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    keyboardType: TextInputType.number,
                    controller: context
                        .read<TestAnalysisViewCubit>()
                        .resultEditingController,
                    decoration: InputDecoration(
                      labelText: 'النتيجة الجديدة',
                    ),
                  ),
                ),
              Align(
                alignment: Alignment.bottomLeft,
                child: TextButton(
                  onPressed: () {
                    if (isEditing) {
                      cubit.toggleEditing(id, results[0]);
                    } else {
                      cubit.toggleEditing(id, results[0]);
                    }
                  },
                  child: Text(
                    isEditing ? 'إلغاء' : 'تعديل النتيجه',
                    style: AppTextStyles.font14BlueWeight700
                        .copyWith(decoration: TextDecoration.underline),
                  ),
                ),
              ),
              if (isEditing)
                ElevatedButton(
                  onPressed: () {
                    cubit.updateTestResult(
                      id: id,
                      testName: testName,
                      result: double.parse(cubit.resultEditingController.text),
                    );
                  },
                  child: Text(
                    'حفظ',
                    style: AppTextStyles.font14whiteWeight600,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildColumnItem({
    required IconData icon,
    required String label,
    required List<String> value,
    bool isHighlightValue = false,
    required BuildContext context,
  }) {
    const Color borderColor = AppColorsManager.mainDarkBlue;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: borderColor),
            horizontalSpacing(4),
            Text(
              label,
              style: AppTextStyles.font16DarkGreyWeight400
                  .copyWith(color: borderColor),
            ),
          ],
        ),
        verticalSpacing(4),
        SizedBox(
          height: value.length > 1
              ? MediaQuery.of(context).size.height * 0.17
              : MediaQuery.of(context).size.height * 0.05,
          width: MediaQuery.of(context).size.width * 0.2,
          child: ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: value.length,
            itemBuilder: (context, index) => Container(
              margin: EdgeInsets.symmetric(vertical: 2.w),
              padding: label == 'الاسم' || label == 'النتيجة'
                  ? EdgeInsets.symmetric(horizontal: 16.w, vertical: 2.h)
                  : EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
              decoration: BoxDecoration(
                color: isHighlightValue ? borderColor : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: borderColor, width: 1),
              ),
              child: Text(
                value[index],
                style: AppTextStyles.font14whiteWeight600.copyWith(
                  color: isHighlightValue ? Colors.white : Colors.black,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
