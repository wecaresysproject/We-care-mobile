import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/di/dependency_injection.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/SharedWidgets/custom_app_bar_with_centered_title_widget.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/medical_illnesses/data/models/get_follow_up_report_section_model.dart';
import 'package:we_care/features/medical_illnesses/medical_illnesses_view/Presentation/widgets/section_info_details_widget.dart';
import 'package:we_care/features/medical_illnesses/medical_illnesses_view/logic/mental_illness_data_view_cubit.dart';
import 'package:we_care/features/medical_illnesses/medical_illnesses_view/logic/mental_illness_data_view_state.dart';

class MentalIllnessFollowUpReportDetailsView extends StatelessWidget {
  const MentalIllnessFollowUpReportDetailsView(
      {super.key, required this.docId});
  final String docId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<MentalIllnessDataViewCubit>(
      create: (context) => getIt<MentalIllnessDataViewCubit>()
        ..getFollowUpDocumentDetailsById(docId),
      child: Scaffold(
        appBar: AppBar(toolbarHeight: 0.h),
        body:
            BlocBuilder<MentalIllnessDataViewCubit, MentalIllnessDataViewState>(
          builder: (context, state) {
            switch (state.requestStatus) {
              case RequestStatus.loading:
                return const Center(child: CircularProgressIndicator());

              case RequestStatus.failure:
                return Center(
                  child: Text(
                    state.responseMessage ?? "حدث خطأ أثناء تحميل البيانات",
                    style: AppTextStyles.font22MainBlueWeight700,
                    textAlign: TextAlign.center,
                  ),
                );

              case RequestStatus.success:
                if (state.followUpSectionsDetailsContent.isEmpty) {
                  return Center(
                    child: Text(
                      "لا توجد بيانات متاحة",
                      style: AppTextStyles.font22MainBlueWeight700,
                    ),
                  );
                }
                final data = state.followUpSectionsDetailsContent;
                return _buildDetailsContent(data);

              default:
                return const SizedBox();
            }
          },
        ),
      ),
    );
  }

  /// Builds the content after successful API response
  Widget _buildDetailsContent(List<GetFollowUpReportSectionModel> data) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: Column(
        spacing: 16,
        children: [
          AppBarWithCenteredTitle(
            title: 'تفاصيل التقرير',
            titleColor: AppColorsManager.mainDarkBlue,
            shareFunction: () {},
            showShareButtonOnly: true,
          ),
          CustomInfoSection(
            headerIcon: Icons.trending_down,
            headerTitle: 'المستوى الإجمالى',
            content: data[0].sectionContent,
          ),
          CustomInfoSection(
            headerIcon: Icons.check_circle,
            headerTitle: 'عدد الإجابات الإيجابية',
            content: data[1].sectionContent,
          ),
          CustomInfoSection(
            headerIcon: Icons.question_mark,
            headerTitle: 'ملاحظة',
            content: data[2].sectionContent,
          ),
          CustomInfoSection(
            headerIcon: Icons.psychology,
            headerTitle: 'ملخص الحالة',
            content: data[3].sectionContent,
          ),
          CustomInfoSection(
            headerIcon: Icons.edit_square,
            headerTitle: 'ما الذي نلاحظه في إجابتك ؟',
            content: data[4].sectionContent,
          ),
          CustomInfoSection(
            headerIcon: Icons.psychology,
            headerTitle: 'ما الذي قد يحدث داخلك؟',
            content: data[5].sectionContent,
          ),
          CustomInfoSection(
            headerIcon: Icons.favorite,
            headerTitle: 'رسالة لك من القلب',
            content: data[6].sectionContent,
          ),
          CustomInfoSection(
            headerIcon: Icons.edit_square,
            headerTitle: 'الخطوات المقترحة (قصيرة المدى)',
            content: data[7].sectionContent,
          ),
          CustomInfoSection(
            headerIcon: Icons.self_improvement,
            headerTitle: 'خطة دعم نفسي تدريجى  ( متوسط  وطويل المدى )',
            content: data[8].sectionContent,
          ),
          CustomInfoSection(
            headerIcon: Icons.flag,
            headerTitle: 'ختامًا',
            content: data[9].sectionContent,
          ),
        ],
      ),
    );
  }
}
