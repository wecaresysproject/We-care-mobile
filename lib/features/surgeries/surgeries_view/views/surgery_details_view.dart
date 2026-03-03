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
import 'package:we_care/core/global/SharedWidgets/module_guidance_alert_dialog.dart';
import 'package:we_care/core/global/SharedWidgets/shared_app_bar_widget.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/core/models/module_guidance_response_model.dart';
import 'package:we_care/core/routing/routes.dart';
import 'package:we_care/features/surgeries/surgeries_view/logic/surgeries_view_cubit.dart';
import 'package:we_care/features/surgeries/surgeries_view/logic/surgeries_view_state.dart';

class SurgeryDetailsView extends StatelessWidget {
  const SurgeryDetailsView({
    super.key,
    required this.documentId,
    this.guidanceData,
  });
  final String documentId;
  final ModuleGuidanceDataModel? guidanceData;

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: getIt<SurgeriesViewCubit>()..getSurgeryDetailsById(documentId),
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 0.h,
        ),
        body: BlocConsumer<SurgeriesViewCubit, SurgeriesViewState>(
          listener: (context, state) async {
            if (state.requestStatus == RequestStatus.success &&
                state.isDeleteRequest) {
              Navigator.pop(context);
              await showSuccess(state.responseMessage);
            } else if (state.requestStatus == RequestStatus.failure &&
                state.isDeleteRequest) {
              await showError(state.responseMessage);
            }
          },
          buildWhen: (previous, current) =>
              previous.selectedSurgeryDetails != current.selectedSurgeryDetails,
          builder: (context, state) {
            if (state.requestStatus == RequestStatus.loading ||
                state.selectedSurgeryDetails == null) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: 16.w,
              ),
              child: Column(
                children: [
                  AppBarWithCenteredTitle(
                    trailingActions: [
                      CircleIconButton(
                        icon: Icons.play_arrow,
                        color: guidanceData?.videoLink?.isNotEmpty == true
                            ? AppColorsManager.mainDarkBlue
                            : Colors.grey,
                        onTap: guidanceData?.videoLink?.isNotEmpty == true
                            ? () => launchYouTubeVideo(guidanceData!.videoLink)
                            : null,
                      ),
                      SizedBox(width: 12.w),
                      CircleIconButton(
                        icon: Icons.menu_book_outlined,
                        color:
                            guidanceData?.moduleGuidanceText?.isNotEmpty == true
                                ? AppColorsManager.mainDarkBlue
                                : Colors.grey,
                        onTap:
                            guidanceData?.moduleGuidanceText?.isNotEmpty == true
                                ? () {
                                    ModuleGuidanceAlertDialog.show(
                                      context,
                                      title: "العمليات",
                                      description:
                                          guidanceData!.moduleGuidanceText!,
                                    );
                                  }
                                : null,
                      ),
                    ],
                    title: 'العمليات',
                    deleteFunction: () async => await context
                        .read<SurgeriesViewCubit>()
                        .deleteSurgeryById(documentId),
                    shareFunction: () => _shareSurgeryDetails(context, state),
                    editFunction: () async {
                      final result = await context.pushNamed(
                        Routes.surgeriesDataEntryView,
                        arguments: state.selectedSurgeryDetails,
                      );
                      // if (result != null && result) {
                      if (!context.mounted) return;
                      await context
                          .read<SurgeriesViewCubit>()
                          .getSurgeryDetailsById(documentId);
                      // }
                    },
                  ),
                  verticalSpacing(16),
                  Row(children: [
                    DetailsViewInfoTile(
                      title: "كود ICHI",
                      value: state.selectedSurgeryDetails!.ichiCode ?? "-",
                      icon: 'assets/images/data_search_icon.png',
                    ),
                    Spacer(),
                    DetailsViewInfoTile(
                        title: "التاريخ",
                        value: state.selectedSurgeryDetails!.surgeryDate,
                        icon: 'assets/images/date_icon.png'),
                  ]),
                  Row(children: [
                    DetailsViewInfoTile(
                      title: "العضو",
                      value: state.selectedSurgeryDetails!.surgeryRegion,
                      icon: 'assets/images/body_icon.png',
                    ),
                    Spacer(),
                    DetailsViewInfoTile(
                        title: "المنطقة الفرعية ",
                        value: state.selectedSurgeryDetails!.subSurgeryRegion,
                        icon: 'assets/images/body_icon.png'),
                  ]),
                  DetailsViewInfoTile(
                    title: 'اسم العملية',
                    value: state.selectedSurgeryDetails!.surgeryName,
                    icon: 'assets/images/doctor_name.png',
                    isExpanded: true,
                  ),
                  DetailsViewInfoTile(
                    title: ' الهدف من الاجراء',
                    value: state.selectedSurgeryDetails!.purpose ??
                        "لم يتم تحديده",
                    icon: 'assets/images/chat_question_icon.png',
                    isExpanded: true,
                  ),
                  Row(children: [
                    DetailsViewInfoTile(
                      title: "التقنية المستخدمة",
                      value: state.selectedSurgeryDetails!.usedTechnique,
                      icon: 'assets/images/data_search_icon.png',
                    ),
                    Spacer(),
                    DetailsViewInfoTile(
                        title: "حالة العملية",
                        value: state.selectedSurgeryDetails!.surgeryStatus,
                        icon: 'assets/images/ratio.png'),
                  ]),
                  DetailsViewInfoTile(
                      title: "وصف اضافي للعملية",
                      value: state.selectedSurgeryDetails!.surgeryDescription,
                      icon: 'assets/images/notes_icon.png',
                      isExpanded: true),
                  DetailsViewInfoTile(
                    title: "الجراح ",
                    value: state.selectedSurgeryDetails!.surgeonName,
                    icon: 'assets/images/surgery_icon.png',
                    isExpanded: true,
                  ),
                  DetailsViewInfoTile(
                    title: "طبيب الباطنة ",
                    value: state.selectedSurgeryDetails!.anesthesiologistName,
                    icon: 'assets/images/doctor_icon.png',
                    isExpanded: true,
                  ),
                  DetailsViewInfoTile(
                      title: "الدولة",
                      value: state.selectedSurgeryDetails!.country,
                      isExpanded: true,
                      icon: 'assets/images/country_icon.png'),
                  DetailsViewInfoTile(
                      title: "المستشفي",
                      value: state.selectedSurgeryDetails!.hospitalCenter,
                      icon: 'assets/images/hospital_icon.png',
                      isExpanded: true),
                  DetailsViewInfoTile(
                      title: " تعليمات بعد العملية",
                      value:
                          state.selectedSurgeryDetails!.postSurgeryInstructions,
                      icon: 'assets/images/symptoms_icon.png',
                      isExpanded: true),
                  DetailsViewInfoTile(
                      title: " توصيف العملية",
                      value: state.selectedSurgeryDetails!.description ??
                          "لم يتم تحديده",
                      icon: 'assets/images/file_date_icon.png',
                      isExpanded: true),
                  DetailsViewInfoTile(
                      title: " ملاحظات شخصية",
                      value: state.selectedSurgeryDetails!.additionalNotes,
                      icon: 'assets/images/notes_icon.png',
                      isExpanded: true),
                  DetailsViewInfoTile(
                    title: "التقرير الطبي المكتوب",
                    value: state.selectedSurgeryDetails!.writtenReport ?? "",
                    icon: 'assets/images/notes_icon.png',
                    isExpanded: true,
                  ),
                  DetailsViewImagesWithTitleTile(
                    images: state.selectedSurgeryDetails!.medicalReportImage,
                    title: "التقرير الطبي",
                    isShareEnabled: true,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

Future<void> _shareSurgeryDetails(
  BuildContext context,
  SurgeriesViewState state,
) async {
  try {
    final surgery = state.selectedSurgeryDetails!;

    // 🧾 نجهّز البيانات الأساسية
    final detailsMap = {
      '📅 *التاريخ*:': surgery.surgeryDate,
      '🏥 *المستشفى*:': surgery.hospitalCenter,
      '🌍 *الدولة*:': surgery.country,
      '🧑‍⚕️ *الجراح*:': surgery.surgeonName,
      '⚕️ *طبيب الباطنة*:': surgery.anesthesiologistName,
      '🌤 *الحالة*:': surgery.surgeryStatus,
      '💪 *التقنية المستخدمة*:': surgery.usedTechnique,
      '📃 *التوصيف*:': surgery.surgeryDescription,
      '📕 *التعليمات بعد العملية*:': surgery.postSurgeryInstructions,
    };

    // 📷 الصور (التقرير الطبي فقط إن وُجد)
    // final imageUrls = <String>[];
    // if (surgery.medicalReportImage.startsWith("http")) {
    //   imageUrls.add(surgery.medicalReportImage);
    // }

    // // 🚀 استدعاء الميثود الجينيريك
    // await shareDetails(
    //   title: '⚕️ *تفاصيل العملية* ⚕️',
    //   details: detailsMap,
    //   imageUrls: imageUrls,
    //   errorMessage: "❌ حدث خطأ أثناء مشاركة تفاصيل العملية",
    // );
  } catch (e) {
    await showError("❌ حدث خطأ أثناء المشاركة");
  }
}
