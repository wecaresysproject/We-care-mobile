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
import 'package:we_care/core/global/SharedWidgets/details_view_info_tile.dart';
import 'package:we_care/core/global/SharedWidgets/loading_state_view.dart';
import 'package:we_care/core/routing/routes.dart';
import 'package:we_care/features/test_laboratory/analysis_view/Presention/widgets/details_view_images_with_title_widget.dart';
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
                  DetailsViewInfoTile(
                    title: "التاريخ",
                    value: state.selectedAnalysisDetails!.testDate,
                    icon: 'assets/images/date_icon.png',
                    isExpanded: true,
                  ),
                  DetailsViewInfoTile(
                    title: "نوع التحليل",
                    value: state.selectedAnalysisDetails!.groupName ?? "jkn",
                    icon: 'assets/images/analysis_type.png',
                    isExpanded: true,
                  ),
                  DetailsViewImagesWithTitleTile(
                    images: state.selectedAnalysisDetails!.imageBase64,
                    title: "صورة التحليل",
                  ),
                  DetailsViewImagesWithTitleTile(
                    images: state.selectedAnalysisDetails!.reportBase64,
                    title: "التقرير الطبي",
                    isShareEnabled: true,
                  ),
                  DetailsViewInfoTile(
                    value: "still dummy",
                    title: "توصيف التقرير الطبي",
                    icon: 'assets/images/need_icon.png',
                    isExpanded: true,
                  ),
                  DetailsViewInfoTile(
                    title: "نوعية الاحتياج",
                    value: state.selectedAnalysisDetails!.testNeedType ?? '-',
                    icon: 'assets/images/need_icon.png',
                    isExpanded: true,
                  ),
                  DetailsViewInfoTile(
                    title: "الأعراض المستدعية للإجراء",
                    value: state.selectedAnalysisDetails!.symptomsForProcedure!,
                    icon: 'assets/images/need_icon.png',
                    isExpanded: true,
                  ),
                  DetailsViewInfoTile(
                    title: "الطبيب المعالج",
                    value: state.selectedAnalysisDetails!.doctor,
                    icon: 'assets/images/doctor_icon.png',
                    isExpanded: true,
                  ),
                  DetailsViewInfoTile(
                    title: "المستشفى",
                    value: state.selectedAnalysisDetails!.hospital,
                    icon: 'assets/images/hospital_icon.png',
                    isExpanded: true,
                  ),
                  DetailsViewInfoTile(
                    title: "المعمل",
                    value: "dummy",
                    icon: 'assets/images/hospital_icon.png',
                    isExpanded: true,
                  ),
                  DetailsViewInfoTile(
                    title: "الدولة",
                    value: state.selectedAnalysisDetails!.country,
                    icon: 'assets/images/country_icon.png',
                    isExpanded: true,
                  ),
                  SizedBox(height: 24.h),
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
  BuildContext context,
  TestAnalysisViewState state,
) async {
  try {
    final analysisDetails = state.selectedAnalysisDetails!;
    final tempDir = await getTemporaryDirectory();
    final List<String> imagePaths = [];

    // 📝 نص تفاصيل التحليل
    final textBuffer = StringBuffer('''
🩺 *تفاصيل التحليل* 🩺

📅 *التاريخ*: ${analysisDetails.testDate ?? 'غير محدد'}
🔬 *نوع التحليل*: ${analysisDetails.groupName ?? 'غير محدد'}
👨‍⚕️ *الطبيب المعالج*: ${analysisDetails.doctor ?? 'غير محدد'}
🏥 *المستشفى/المعمل*: ${analysisDetails.hospital ?? 'غير محدد'}
🌍 *الدولة*: ${analysisDetails.country ?? 'غير محددة'}
🏷 *نوعية الاحتياج*: دورية
''');

    // 🧾 صور وتقارير التحاليل
    final List<String> analysisImages = analysisDetails.imageBase64 ?? [];
    final List<String> reportImages = analysisDetails.reportBase64 ?? [];
    final allImages = [...analysisImages, ...reportImages];

    if (allImages.isNotEmpty) {
      textBuffer.writeln('\n🧾 *صور وتقارير التحليل:*');
      for (final url in allImages) {
        if (url.startsWith('http')) {
          final path = await downloadImage(
            url,
            tempDir,
            'attachment_${DateTime.now().millisecondsSinceEpoch}.png',
          );
          if (path != null) imagePaths.add(path);
        }
      }
    }

    // 📤 المشاركة
    if (imagePaths.isNotEmpty) {
      await Share.shareXFiles(
        imagePaths.map((p) => XFile(p)).toList(),
        text: textBuffer.toString(),
      );
    } else {
      await Share.share(textBuffer.toString());
    }
  } catch (e) {
    await showError("❌ حدث خطأ أثناء المشاركة");
  }
}
