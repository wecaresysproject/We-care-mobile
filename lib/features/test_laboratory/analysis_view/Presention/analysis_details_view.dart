import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/di/dependency_injection.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/app_toasts.dart';
import 'package:we_care/core/global/SharedWidgets/details_view_app_bar.dart';
import 'package:we_care/core/global/SharedWidgets/details_view_image_with_title.dart';
import 'package:we_care/core/global/SharedWidgets/details_view_info_tile.dart';
import 'package:we_care/features/test_laboratory/analysis_view/Presention/analysis_view.dart';
import 'package:we_care/features/test_laboratory/analysis_view/logic/test_analysis_view_cubit.dart';
import 'package:we_care/features/test_laboratory/analysis_view/logic/test_analysis_view_state.dart';

class AnalysisDetailsView extends StatelessWidget {
  final String documentId;
  const AnalysisDetailsView({super.key, required this.documentId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: getIt<TestAnalysisViewCubit>()..emitTestbyId(documentId),
      child: BlocConsumer<TestAnalysisViewCubit, TestAnalysisViewState>(
        listener: (context, state) async {
          if (state.requestStatus == RequestStatus.success &&
              state.isDeleteRequest == true) {
            await showSuccess(state.message!);
            Navigator.pop(context);
          } else if (state.requestStatus == RequestStatus.failure &&
              state.isDeleteRequest == true) {
            await showError(state.message!);
          }
        },
        builder: (context, state) {
          if (state.requestStatus == RequestStatus.loading &&
              !state.isDeleteRequest) {
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
                  DetailsViewAppBar(
                      title: 'التحليل',
                      editFunction: () {},
                      deleteFunction: () async {
                        await getIt<TestAnalysisViewCubit>()
                            .emitDeleteTest(documentId);
                        await showSuccess('تم حذف التحليل بنجاح');
                        Navigator.pop(context, true);
                      }),
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
                      image: state.selectedAnalysisDetails!.imageBase64,
                      title: "صورة التحليل"),
                  DetailsViewImageWithTitleTile(
                      image: state.selectedAnalysisDetails!.reportBase64,
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
      ),
    );
  }
}
