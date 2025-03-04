import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/di/dependency_injection.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/SharedWidgets/details_view_app_bar.dart';
import 'package:we_care/core/global/SharedWidgets/details_view_image_with_title.dart';
import 'package:we_care/core/global/SharedWidgets/details_view_info_tile.dart';
import 'package:we_care/features/test_laboratory/analysis_view/logic/test_analysis_view_cubit.dart';
import 'package:we_care/features/test_laboratory/analysis_view/logic/test_analysis_view_state.dart';

class AnalysisDetailsView extends StatelessWidget {
  final String documentId;
  const AnalysisDetailsView({super.key, required this.documentId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: getIt<TestAnalysisViewCubit>()..emitTestbyId(documentId),
      child: BlocBuilder<TestAnalysisViewCubit, TestAnalysisViewState>(
        builder: (context, state) {
          if (state.requestStatus == RequestStatus.loading) {
            return Scaffold(
              body: const Center(child: CircularProgressIndicator()),
              backgroundColor: Colors.white,
            );
          }
          return Scaffold(
            appBar: AppBar(
              toolbarHeight: 0.h,
            ),
            body: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                spacing: 16.h,
                children: [
                  DetailsViewAppBar(title: 'التحليل'),
                  Row(children: [
                    DetailsViewInfoTile(
                        title: "التاريخ",
                        value: state.selectedAnalysisDetails!.testDate,
                        icon: 'assets/images/date_icon.png'),
                    Spacer(),
                    DetailsViewInfoTile(
                      title: "نوع التحليل",
                      value: state.selectedAnalysisDetails!.groupName,
                      icon: 'assets/images/analysis_type.png',
                    ),
                  ]),
                  DetailsViewImageWithTitleTile(
                      //  image: state.selectedAnalysisDetails!.imageBase64,
                      image: '',
                      title: "صورة التحليل"),
                  DetailsViewImageWithTitleTile(
                      //    image: state.selectedAnalysisDetails!.reportBase64,
                      image: '',
                      title: "التقرير الطبي"),
                  Row(children: [
                    DetailsViewInfoTile(
                        title: "نوعية الاحتياج",
                        value: "دورية",
                        icon: 'assets/images/need_icon.png'),
                    Spacer(),
                    DetailsViewInfoTile(
                        title: "الطبيب المعالج",
                        value: state.selectedAnalysisDetails!.doctor,
                        icon: 'assets/images/doctor_icon.png'),
                  ]),
                  Row(children: [
                    DetailsViewInfoTile(
                        title: "المستشفى/المعمل",
                        value: state.selectedAnalysisDetails!.hospital,
                        icon: 'assets/images/hospital_icon.png'),
                    Spacer(),
                    DetailsViewInfoTile(
                        title: "الدولة",
                        value: state.selectedAnalysisDetails!.country,
                        icon: 'assets/images/country_icon.png'),
                  ]),
                ],
              ),
            ),
          );
        },
=======
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/details_view_app_bar.dart';
import 'package:we_care/core/global/SharedWidgets/details_view_image_with_title.dart';
import 'package:we_care/core/global/SharedWidgets/details_view_info_tile.dart';

class AnalysisDetailsView extends StatelessWidget {
  const AnalysisDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0.h,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          spacing: 16.h,
          children: [
            DetailsViewAppBar(title: 'التحليل'),
            Row(children: [
              DetailsViewInfoTile(
                  title: "التاريخ",
                  value: "1 / 3 / 2025",
                  icon: 'assets/images/date_icon.png'),
              Spacer(),
              DetailsViewInfoTile(
                title: "نوع التحليل",
                value: "صورة دم كاملة",
                icon: 'assets/images/analysis_type.png',
              ),
            ]),
            Row(children: [
              Column(
                children: [
                  DetailsViewInfoTile(
                      title: "الاعراض المستدعية",
                      value: "دوخة",
                      icon: 'assets/images/symptoms_icon.png'),
                  verticalSpacing(8),
                  CustomContainer(value: 'الصداع المزمن'),
                  verticalSpacing(8),
                  CustomContainer(value: 'شحوب في البشرة'),
                ],
              ),
              Spacer(),
              Column(
                children: [
                  DetailsViewInfoTile(
                      title: "النسب ",
                      value: "كرات الدم البيضاء 4",
                      icon: 'assets/images/ratio.png'),
                  verticalSpacing(8),
                  CustomContainer(value: 'كرات الدم الحمراء 3'),
                  verticalSpacing(8),
                  CustomContainer(value: ' الصفائح الدموية 2 '),
                ],
              ),
            ]),
            Row(children: [
              DetailsViewInfoTile(
                  title: "نوعية الاحتياج",
                  value: "دورية",
                  icon: 'assets/images/need_icon.png'),
              Spacer(),
              DetailsViewInfoTile(
                  title: "الطبيب المعالج",
                  value: "د/ أحمد هاني",
                  icon: 'assets/images/doctor_icon.png'),
            ]),
            Row(children: [
              DetailsViewInfoTile(
                  title: "المستشفى/المعمل",
                  value: "دار الفؤاد",
                  icon: 'assets/images/hospital_icon.png'),
              Spacer(),
              DetailsViewInfoTile(
                  title: "الدولة",
                  value: "مصر",
                  icon: 'assets/images/country_icon.png'),
            ]),
            DetailsViewImageWithTitleTile(image: '', title: "صورة التحليل"),
            DetailsViewImageWithTitleTile(image: '', title: "التقرير الطبي"),
          ],
        ),
>>>>>>> 3fa0b39 (add intial wiring up for get table with relevant data logic)
      ),
    );
  }
}
