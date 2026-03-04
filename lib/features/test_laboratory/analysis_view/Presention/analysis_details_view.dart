import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/di/dependency_injection.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/app_toasts.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/custom_app_bar_with_centered_title_widget.dart';
import 'package:we_care/core/global/SharedWidgets/details_view_images_with_title_widget.dart';
import 'package:we_care/core/global/SharedWidgets/details_view_info_tile.dart';
import 'package:we_care/core/global/SharedWidgets/loading_state_view.dart';
import 'package:we_care/core/global/SharedWidgets/module_guidance_alert_dialog.dart';
import 'package:we_care/core/global/SharedWidgets/shared_app_bar_widget.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/core/routing/routes.dart';
import 'package:we_care/features/test_laboratory/analysis_view/logic/test_analysis_view_cubit.dart';
import 'package:we_care/features/test_laboratory/analysis_view/logic/test_analysis_view_state.dart';

import '../../../../core/global/Helpers/share_details_helper.dart';

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
                children: [
                  AppBarWithCenteredTitle(
                      title: 'التحليل',
                      trailingActions: [
                        CircleIconButton(
                          icon: Icons.play_arrow,
                          color:
                              state.moduleGuidanceData?.videoLink?.isNotEmpty ==
                                      true
                                  ? AppColorsManager.mainDarkBlue
                                  : Colors.grey,
                          onTap:
                              state.moduleGuidanceData?.videoLink?.isNotEmpty ==
                                      true
                                  ? () => launchYouTubeVideo(
                                      state.moduleGuidanceData!.videoLink)
                                  : null,
                        ),
                        SizedBox(width: 12.w),
                        CircleIconButton(
                          icon: Icons.menu_book_outlined,
                          color: state.moduleGuidanceData?.moduleGuidanceText
                                      ?.isNotEmpty ==
                                  true
                              ? AppColorsManager.mainDarkBlue
                              : Colors.grey,
                          onTap: state.moduleGuidanceData?.moduleGuidanceText
                                      ?.isNotEmpty ==
                                  true
                              ? () {
                                  ModuleGuidanceAlertDialog.show(
                                    context,
                                    title: "العمليات",
                                    description: state.moduleGuidanceData!
                                        .moduleGuidanceText!,
                                  );
                                }
                              : null,
                        ),
                      ],
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
                      shareFunction: () async {
                        final analysis = state.selectedAnalysisDetails!;

                        // 🧩 نجهّز البيانات الأساسية
                        final detailsMap = {
                          '📅 *التاريخ*:': analysis.testDate,
                          '🔬 *نوع التحليل*:': analysis.groupName,
                          '👨‍⚕️ *الطبيب المعالج*:': analysis.doctor,
                          '🏥 *المستشفى/المعمل*:': analysis.hospital,
                          '🌍 *الدولة*:': analysis.country,
                          '🏷 *نوعية الاحتياج*:': "دورية",
                          '🤒 *الأعراض المستدعية للإجراء*:':
                              analysis.symptomsRequiringIntervention,
                          '📝 *توصيف التقرير الطبي*:':
                              analysis.writtenReport ?? "لم يتم ادخال بيانات",
                        };
                        // 🧾 الصور (من analysis.imageBase64 + analysis.reportBase64)
                        final allImages = [
                          ...(analysis.imageBase64),
                          ...(analysis.reportBase64),
                        ];

                        // 🩺 مشاركة باستخدام الميثود الـgeneric
                        await shareDetails(
                          title: '🩺 *تفاصيل التحليل* 🩺',
                          details: detailsMap,
                          imageUrls: allImages,
                          errorMessage: "❌ حدث خطأ أثناء مشاركة تفاصيل التحليل",
                        );
                      }),
                  verticalSpacing(16),
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
                    value: state.selectedAnalysisDetails!.writtenReport ??
                        "لم يتم ادخال بيانات",
                    title: "توصيف التقرير الطبي",
                    icon: 'assets/images/need_icon.png',
                    isExpanded: true,
                  ),
                  DetailsViewInfoTile(
                    title: "نوعية الاحتياج",
                    value: state.selectedAnalysisDetails!.testNeedType ??
                        "لم يتم ادخال بيانات",
                    icon: 'assets/images/need_icon.png',
                    isExpanded: true,
                  ),
                  DetailsViewInfoTile(
                    title: "الأعراض المستدعية للإجراء",
                    value: state.selectedAnalysisDetails!
                            .symptomsRequiringIntervention
                            ?.asMap()
                            .entries
                            .map((e) => "${e.key + 1}- ${e.value}")
                            .join('\n') ??
                        "",
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
                    value: state.selectedAnalysisDetails!.radiologyCenter ?? "",
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
