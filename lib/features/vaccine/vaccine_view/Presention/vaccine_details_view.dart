import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:share_plus/share_plus.dart';
import 'package:we_care/core/di/dependency_injection.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/app_toasts.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/custom_app_bar_with_centered_title_widget.dart';
import 'package:we_care/core/global/SharedWidgets/details_view_info_tile.dart';
import 'package:we_care/core/global/SharedWidgets/loading_state_view.dart';
import 'package:we_care/core/global/SharedWidgets/module_guidance_alert_dialog.dart';
import 'package:we_care/core/global/SharedWidgets/shared_app_bar_widget.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/core/models/module_guidance_response_model.dart';
import 'package:we_care/core/routing/routes.dart';
import 'package:we_care/features/vaccine/data/models/get_vaccine_details_response_model.dart';
import 'package:we_care/features/vaccine/vaccine_view/logic/vaccine_view_cubit.dart';
import 'package:we_care/features/vaccine/vaccine_view/logic/vaccne_view_state.dart';

class VaccineDetailsView extends StatelessWidget {
  const VaccineDetailsView({
    super.key,
    required this.documentId,
    this.guidanceData,
  });

  final String documentId;

  /// Passed down from the list view so the details screen doesn't refetch it.
  final ModuleGuidanceDataModel? guidanceData;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<VaccineViewCubit>(
      create: (context) =>
          getIt<VaccineViewCubit>()..emitVaccineDetailsById(documentId),
      child: Scaffold(
        appBar: AppBar(toolbarHeight: 0.h),
        body: BlocConsumer<VaccineViewCubit, VaccineViewState>(
          listenWhen: (previous, current) =>
              current.isDeleteRequest &&
              previous.requestStatus != current.requestStatus,
          listener: (context, state) async {
            if (state.requestStatus == RequestStatus.failure) {
              await showError(state.message);
            } else if (state.requestStatus == RequestStatus.success) {
              await showSuccess(state.message);
              if (!context.mounted) return;
              // `true` tells the vaccines table to refetch itself.
              Navigator.pop(context, true);
            }
          },
          builder: (context, state) {
            if ((state.requestStatus == RequestStatus.loading ||
                    state.requestStatus == RequestStatus.initial) &&
                !state.isDeleteRequest) {
              return const LoadingStateView();
            }

            final vaccine = state.selectedVaccine;
            if (vaccine == null) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Text(
                    state.message.isEmpty ? 'لا يوجد بيانات' : state.message,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.font16DarkGreyWeight400,
                  ),
                ),
              );
            }

            return SingleChildScrollView(
              padding: EdgeInsets.only(bottom: 16.h, left: 16.w, right: 16.w),
              child: Column(
                children: [
                  AppBarWithCenteredTitle(
                    title: vaccine.vaccineName ?? 'التطعيم',
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
                                      title: 'التطعيمات',
                                      description:
                                          guidanceData!.moduleGuidanceText!,
                                    );
                                  }
                                : null,
                      ),
                    ],
                    shareFunction: () async =>
                        await _shareVaccineDetails(vaccine),
                    editFunction: () async {
                      final cubit = context.read<VaccineViewCubit>();
                      final wasEdited = await context.pushNamed(
                        Routes.vaccineDataEntryView,
                        arguments: vaccine,
                      );
                      if (wasEdited == true) {
                        await cubit.emitVaccineDetailsById(documentId);
                      }
                    },
                    deleteFunction: () async => await context
                        .read<VaccineViewCubit>()
                        .deleteVaccineUserEntry(documentId),
                  ),
                  verticalSpacing(16),
                  DetailsViewInfoTile(
                    title: "تاريخ التطعيم",
                    value: vaccine.date ?? "",
                    icon: 'assets/images/date_icon.png',
                    isExpanded: true,
                  ),
                  DetailsViewInfoTile(
                    title: "اسم اللقاح",
                    value: vaccine.vaccineName ?? "",
                    icon: 'assets/images/doctor_name.png',
                    isExpanded: true,
                  ),
                  DetailsViewInfoTile(
                    title: "الرمز المختصر",
                    value: vaccine.abbreviationCode ?? "",
                    icon: 'assets/images/ratio.png',
                    isExpanded: true,
                  ),
                  DetailsViewInfoTile(
                    title: "الجيل/ حقبة الميلاد",
                    value: vaccine.generation ?? "",
                    icon: 'assets/images/head_question_icon.png',
                    isExpanded: true,
                  ),
                  DetailsViewInfoTile(
                    title: "الفئة المستهدفة",
                    value: vaccine.targetAge ?? "",
                    icon: 'assets/images/head_question_icon.png',
                    isExpanded: true,
                  ),
                  DetailsViewInfoTile(
                    title: "فئة اللقاح",
                    value: vaccine.vaccineCategory ?? "",
                    icon: 'assets/images/ratio.png',
                    isExpanded: true,
                  ),
                  DetailsViewInfoTile(
                    title: "العمر النموذجي",
                    value: vaccine.perfectAge ?? "",
                    icon: 'assets/images/file_icon.png',
                    isExpanded: true,
                  ),
                  DetailsViewInfoTile(
                    title: "وصف عمل اللقاح",
                    value: vaccine.vaccineActionDescription ?? "",
                    icon: 'assets/images/need_icon.png',
                    isExpanded: true,
                  ),
                  DetailsViewInfoTile(
                    title: "الزامي / اختياري",
                    value: vaccine.priorityTake ?? "",
                    icon: 'assets/images/chat_question_icon.png',
                    isExpanded: true,
                  ),
                  DetailsViewInfoTile(
                    title: "المرض المستهدف",
                    value: vaccine.targetDisease ?? "",
                    icon: 'assets/images/tumor_icon.png',
                    isExpanded: true,
                  ),
                  DetailsViewInfoTile(
                    title: "الجرعة",
                    value: vaccine.dose ?? "",
                    icon: 'assets/images/hugeicons_medicine-01.png',
                    isExpanded: true,
                  ),
                  DetailsViewInfoTile(
                    title: "طريقة التطعيم",
                    value: vaccine.wayToTakeVaccine ?? "",
                    icon: 'assets/images/hugeicons_medicine-01.png',
                    isExpanded: true,
                  ),
                  DetailsViewInfoTile(
                    title: "جهة تلقي التطعيم",
                    value: vaccine.vaccinationProvider ?? "",
                    icon: 'assets/images/hospital_icon.png',
                    isExpanded: true,
                  ),
                  DetailsViewInfoTile(
                    title: "الدولة",
                    value: vaccine.country ?? "",
                    icon: 'assets/images/country_icon.png',
                    isExpanded: true,
                  ),
                  DetailsViewInfoTile(
                    title: "معلومات إضافية",
                    value: vaccine.additionalInfo ?? "",
                    icon: 'assets/images/notes_icon.png',
                    isExpanded: true,
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

Future<void> _shareVaccineDetails(VaccineUserEntryDetailsModel vaccine) async {
  try {
    final text = '''
💉 تفاصيل التطعيم

📅 تاريخ التطعيم: ${vaccine.date ?? "-"}
💊 اسم اللقاح: ${vaccine.vaccineName ?? "-"}
🔤 الرمز المختصر: ${vaccine.abbreviationCode ?? "-"}
🗓 الجيل/ حقبة الميلاد: ${vaccine.generation ?? "-"}
👥 الفئة المستهدفة: ${vaccine.targetAge ?? "-"}
🏷 فئة اللقاح: ${vaccine.vaccineCategory ?? "-"}
🎯 العمر النموذجي: ${vaccine.perfectAge ?? "-"}
📝 وصف عمل اللقاح: ${vaccine.vaccineActionDescription ?? "-"}
⚖️ الزامي / اختياري: ${vaccine.priorityTake ?? "-"}
🦠 المرض المستهدف: ${vaccine.targetDisease ?? "-"}
🧴 الجرعة: ${vaccine.dose ?? "-"}
💉 طريقة التطعيم: ${vaccine.wayToTakeVaccine ?? "-"}
🏥 جهة تلقي التطعيم: ${vaccine.vaccinationProvider ?? "-"}
🌍 الدولة: ${vaccine.country ?? "-"}
📌 معلومات إضافية: ${vaccine.additionalInfo ?? "-"}
''';

    await Share.share(text);
  } catch (e) {
    await showError("❌ حدث خطأ أثناء المشاركة");
  }
}
