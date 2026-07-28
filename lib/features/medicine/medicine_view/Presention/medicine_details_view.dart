import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/di/dependency_injection.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/app_toasts.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/custom_app_bar_with_centered_title_widget.dart';
import 'package:we_care/core/global/SharedWidgets/details_view_info_tile.dart';
import 'package:we_care/core/global/SharedWidgets/module_guidance_alert_dialog.dart';
import 'package:we_care/core/global/SharedWidgets/shared_app_bar_widget.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/core/models/module_guidance_response_model.dart';
import 'package:we_care/core/routing/routes.dart';
import 'package:we_care/features/emergency_complaints/emergency_complaints_view/views/emergency_complaints_details_view.dart';
import 'package:we_care/features/medicine/medicine_view/logic/medicine_view_cubit.dart';
import 'package:we_care/features/medicine/medicine_view/logic/medicine_view_state.dart';
import 'package:we_care/features/medicine/medicine_view/widgets/medicine_active_status_switch.dart';

import '../../../../core/global/Helpers/share_details_helper.dart';

class MedicineDetailsView extends StatelessWidget {
  const MedicineDetailsView({
    super.key,
    required this.documentId,
    this.guidanceData,
  });
  final String documentId;
  final ModuleGuidanceDataModel? guidanceData;
  @override
  Widget build(BuildContext context) {
    return BlocProvider<MedicineViewCubit>(
      create: (context) =>
          getIt<MedicineViewCubit>()..initialRequests(documentId),
      child: Scaffold(
          appBar: AppBar(
            toolbarHeight: 0.h,
          ),
          body: BlocConsumer<MedicineViewCubit, MedicineViewState>(
            listenWhen: (previous, current) =>
                previous.isDeleteRequest != current.isDeleteRequest,
            listener: (context, state) {
              if (state.isDeleteRequest &&
                  state.requestStatus == RequestStatus.success) {
                showSuccess(state.responseMessage);
                Navigator.pop(context);
              } else if (state.isDeleteRequest &&
                  state.requestStatus == RequestStatus.failure) {
                showError(state.responseMessage);
              }
            },
            buildWhen: (previous, current) =>
                previous.selectestMedicineDetails !=
                current.selectestMedicineDetails,
            builder: (context, state) {
              if (state.requestStatus == RequestStatus.loading) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state.requestStatus == RequestStatus.failure) {
                return Center(
                  child: Text(state.responseMessage),
                );
              }
              return SingleChildScrollView(
                padding: EdgeInsets.only(bottom: 16.h, left: 16.w, right: 16.w),
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
                              ? () =>
                                  launchYouTubeVideo(guidanceData!.videoLink)
                              : null,
                        ),
                        SizedBox(width: 12.w),
                        CircleIconButton(
                          icon: Icons.menu_book_outlined,
                          color: guidanceData?.moduleGuidanceText?.isNotEmpty ==
                                  true
                              ? AppColorsManager.mainDarkBlue
                              : Colors.grey,
                          onTap: guidanceData?.moduleGuidanceText?.isNotEmpty ==
                                  true
                              ? () {
                                  ModuleGuidanceAlertDialog.show(
                                    context,
                                    title: "الأدوية",
                                    description:
                                        guidanceData!.moduleGuidanceText!,
                                  );
                                }
                              : null,
                        ),
                      ],
                      isMedicineModule: true,
                      title: 'الدواء',
                      deleteFunction: () async {
                        final medicineName =
                            state.selectestMedicineDetails?.medicineName;
                        await BlocProvider.of<MedicineViewCubit>(context)
                            .deleteMedicineById(documentId);
                        if (!context.mounted) return;
                        if (medicineName == null || medicineName.isEmpty) return;
                        unawaited(
                          context
                              .read<MedicineViewCubit>()
                              .cancelAlarmsCreatedBeforePerMedicine(
                                medicineName,
                              ),
                        );
                      },
                      shareFunction: () {
                        _shareMedicineDetails(context);
                      },
                      editFunction: () async {
                        final result = await context.pushNamed(
                          Routes.medcinesDataEntryView,
                          arguments: state.selectestMedicineDetails,
                        );
                        if (result != null && result) {
                          if (!context.mounted) return;
                          await context
                              .read<MedicineViewCubit>()
                              .getMedicineDetailsById(documentId);
                        }
                      },
                    ),
                    verticalSpacing(16),
                    MedicineActiveStatusSwitch(medicineId: documentId),
                    DetailsViewInfoTile(
                      title: "اسم الدواء",
                      isExpanded: true,
                      value: state.selectestMedicineDetails!.medicineName,
                      icon: 'assets/images/doctor_name.png',
                    ),

                    Row(
                      children: [
                        DetailsViewInfoTile(
                          title: "الشكل الدوائي",
                          value: " اقراص",
                          icon: 'assets/images/symptoms_icon.png',
                        ),
                        Spacer(),
                        DetailsViewInfoTile(
                          title: "كمية الدواء",
                          value: state.selectestMedicineDetails!
                                  .selectedDoseAmount ??
                              "",
                          icon: 'assets/images/time_icon.png',
                        ),
                      ],
                    ),

                    Row(
                      children: [
                        DetailsViewInfoTile(
                            title: "عدد مرات الجرعة  ",
                            value:
                                state.selectestMedicineDetails!.dosageFrequency,
                            icon: 'assets/images/times_icon.png'),
                        Spacer(),
                        DetailsViewInfoTile(
                          title: " مدة العلاج",
                          value: state.selectestMedicineDetails!.timeDuration,
                          icon: 'assets/images/time_icon.png',
                        ),
                      ],
                    ),

                    DetailsViewInfoTile(
                      title: "تاريخ بدء الدواء",
                      value: state.selectestMedicineDetails!.startDate,
                      icon: 'assets/images/date_icon.png',
                      isExpanded: true,
                    ),

                    DetailsViewInfoTile(
                      title: "اسم الطبيب ",
                      value: state.selectestMedicineDetails!.doctorName,
                      icon: 'assets/images/doctor_icon.png',
                      isExpanded: true,
                    ),
                    DetailsViewInfoTile(
                      isExpanded: true,
                      title: "مرض مزمن",
                      value: state
                          .selectestMedicineDetails!.chronicDiseaseMedicine,
                      icon: 'assets/images/medicine_icon.png',
                    ),

                    // Display the main symptoms using SymptomContainer
                    ...state.selectestMedicineDetails!.mainSymptoms
                        .asMap()
                        .entries
                        .map((entry) {
                      final index = entry.key;
                      final symptom = entry.value;
                      return SymptomContainer(
                        isMainSymptom:
                            index == 0, // First symptom is the main one
                        symptomArea: symptom.symptomsRegion,
                        symptomComplaint: symptom.sypmptomsComplaintIssue,
                        natureOfComplaint: symptom.natureOfComplaint,
                        severityOfComplaint: symptom.severityOfComplaint,
                      );
                    }),
                    DetailsViewInfoTile(
                      title: 'الملاحظات الشخصية ',
                      value: state.selectestMedicineDetails!.personalNotes,
                      icon: 'assets/images/pin_edit_icon.png',
                      isExpanded: true,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        DetailsViewInfoTile(
                            title: "التنبيهات",
                            value:
                                state.selectestMedicineDetails!.reminderStatus
                                    ? 'مفعل'
                                    : 'غير مفعل',
                            icon: 'assets/images/date_icon.png'),
                        Spacer(),
                        state.selectestMedicineDetails!.reminder ==
                                "لم يتم ادخال بيانات"
                            ? SizedBox()
                            : CustomContainer(
                                value:
                                    state.selectestMedicineDetails!.reminder),
                      ],
                    ),
                  ],
                ),
              );
            },
          )),
    );
  }
}

Future<void> _shareMedicineDetails(BuildContext context) async {
  final medicine =
      context.read<MedicineViewCubit>().state.selectestMedicineDetails;

  if (medicine == null) return;

  String boolToText(bool? value) => value == true ? 'مفعل' : 'غير مفعل';

  final detailsMap = {
    '💊 اسم الدواء:': medicine.medicineName,
    '🧪 الشكل الدوائي:': 'أقراص',
    '🔁 عدد مرات الجرعة:': medicine.dosageFrequency,
    '⏳ مدة العلاج:': medicine.timeDuration,
    '💊 كمية الدواء:': medicine.selectedDoseAmount,
    '📅 تاريخ بدء الدواء:': medicine.startDate,
    '👨‍⚕️ اسم الطبيب:': medicine.doctorName,
    '🧬 مرض مزمن:': medicine.chronicDiseaseMedicine,
    '📝 الملاحظات الشخصية:':
        medicine.personalNotes.isNotEmpty ? medicine.personalNotes : 'لا توجد',
    '⏰ التنبيهات:': boolToText(medicine.reminderStatus),
    if (medicine.reminderStatus) '🕒 وقت التنبيه:': medicine.reminder,
  };

  final symptoms = medicine.mainSymptoms ?? [];

  final symptomsList = symptoms.asMap().entries.map((entry) {
    final index = entry.key;
    final s = entry.value;

    return {
      index == 0 ? "🌟 العرض الرئيسي - المنطقة:" : "🔹 المنطقة:":
          s.symptomsRegion,
      '🩺 الشكوى:': s.sypmptomsComplaintIssue,
      '⚙️ طبيعة الشكوى:': s.natureOfComplaint,
      '📊 حدة الشكوى:': s.severityOfComplaint,
    };
  }).toList();

  await shareDetails(
    title: '🩺 تفاصيل الدواء',
    details: detailsMap,
    subLists: symptomsList,
    subListTitle: '🧠 الأعراض المرضية:',
    errorMessage: '❌ حدث خطأ أثناء مشاركة تفاصيل الدواء',
  );
}
