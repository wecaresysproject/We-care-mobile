import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:we_care/core/di/dependency_injection.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/app_toasts.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/custom_app_bar_with_centered_title_widget.dart';
import 'package:we_care/core/global/SharedWidgets/details_view_image_with_title.dart';
import 'package:we_care/core/global/SharedWidgets/details_view_info_tile.dart';
import 'package:we_care/core/global/SharedWidgets/loading_state_view.dart';
import 'package:we_care/core/routing/routes.dart';
import 'package:we_care/features/test_laboratory/analysis_view/logic/test_analysis_view_cubit.dart';
import 'package:we_care/features/test_laboratory/analysis_view/logic/test_analysis_view_state.dart';

class AnalysisDetailsView extends StatelessWidget {
  final String documentId;
  final String testName;
  const AnalysisDetailsView(
      {super.key, required this.documentId, required this.testName});

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
            return LoadingStateView();
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
                  AppBarWithCenteredTitle(
                      title: 'التحليل',
                      editFunction: () async {
                        final result = await context.pushNamed(
                          Routes.testAnalsisDataEntryView,
                          arguments: state.selectedAnalysisDetails,
                        );
                        if (result != null && result) {
                          if (!context.mounted) return;
                          context
                              .read<TestAnalysisViewCubit>()
                              .emitTestbyId(documentId);
                        }
                      },
                      deleteFunction: () async {
                        await context
                            .read<TestAnalysisViewCubit>()
                            .emitDeleteTest(
                              documentId,
                              testName,
                            );
                        await showSuccess('تم حذف التحليل بنجاح');
                        if (!context.mounted) return;
                        Navigator.pop(context, true);
                      },
                      shareFunction: () {
                        _shareDetails(context, state);
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
                      title: "التقرير الطبي",
                      isShareEnabled: true),
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

Future<void> _shareDetails(
    BuildContext context, TestAnalysisViewState state) async {
  try {
    final analysisDetails = state.selectedAnalysisDetails!;

    // 📝 Extract text details
    final text = '''
    🩺 *تفاصيل التحليل* 🩺

    📅 *التاريخ*: ${analysisDetails.testDate}
    🔬 *نوع التحليل*: ${analysisDetails.groupName}
    👨‍⚕️ *الطبيب المعالج*: ${analysisDetails.doctor}
    🏥 *المستشفى/المعمل*: ${analysisDetails.hospital}
    🌍 *الدولة*: ${analysisDetails.country}
    🏷 *نوعية الاحتياج*: دورية
    ''';

    // 📥 Download images
    final tempDir = await getTemporaryDirectory();
    List<String> imagePaths = [];

    if (analysisDetails.imageBase64.startsWith("http")) {
      final imagePath = await downloadImage(
          analysisDetails.imageBase64, tempDir, 'analysis_image.png');
      if (imagePath != null) imagePaths.add(imagePath);
    }

    if (analysisDetails.reportBase64.startsWith("http")) {
      final reportPath = await downloadImage(
          analysisDetails.reportBase64, tempDir, 'medical_report.png');
      if (reportPath != null) imagePaths.add(reportPath);
    }

//!TODO: to be removed after adding real data
    // 📤 Share text & images
    if (imagePaths.isNotEmpty) {
      await Share.shareXFiles([XFile(imagePaths.first), XFile(imagePaths.last)],
          text: text);
    } else {
      await Share.share(text);
    }
  } catch (e) {
    await showError("❌ حدث خطأ أثناء المشاركة");
  }
}
