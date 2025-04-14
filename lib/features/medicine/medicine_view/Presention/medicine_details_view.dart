import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:share_plus/share_plus.dart';
import 'package:we_care/core/di/dependency_injection.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/app_toasts.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/SharedWidgets/details_view_app_bar.dart';
import 'package:we_care/core/global/SharedWidgets/details_view_info_tile.dart';
import 'package:we_care/core/routing/routes.dart';
import 'package:we_care/features/emergency_complaints/emergency_complaints_view/views/emergency_complaints_details_view.dart';
import 'package:we_care/features/medicine/medicine_view/logic/medicine_view_cubit.dart';
import 'package:we_care/features/medicine/medicine_view/logic/medicine_view_state.dart';

class MedicineDetailsView extends StatelessWidget {
  const MedicineDetailsView({
    super.key,
    required this.documentId,
  });
  final String documentId;
  @override
  Widget build(BuildContext context) {
    return BlocProvider<MedicineViewCubit>(
      create: (context) =>
          getIt<MedicineViewCubit>()..getMedicineDetailsById(documentId),
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
                  spacing: 16.h,
                  children: [
                    DetailsViewAppBar(
                      title: 'الدواء',
                      deleteFunction: () async {
                        await BlocProvider.of<MedicineViewCubit>(context)
                            .deleteMedicineById(documentId);
                      },
                      shareFunction: () {
                        _shareDetails(context);
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
                    Row(children: [
                      DetailsViewInfoTile(
                          title: "اسم الدواء",
                          value: state.selectestMedicineDetails!.medicineName,
                          icon: 'assets/images/doctor_name.png'),
                      Spacer(),
                      DetailsViewInfoTile(
                        title: "مستمر/متوقف",
                        value: state.selectestMedicineDetails!.dosageFrequency,
                        icon: 'assets/images/doctor_name.png',
                      ),
                    ]),
                    Row(children: [
                      DetailsViewInfoTile(
                          title: "تاريخ بدء الدواء",
                          value: state.selectestMedicineDetails!.startDate,
                          icon: 'assets/images/date_icon.png'),
                      Spacer(),
                      DetailsViewInfoTile(
                        title: " دواء مرض مزمن",
                        value: state
                            .selectestMedicineDetails!.chronicDiseaseMedicine,
                        icon: 'assets/images/medicine_icon.png',
                      ),
                    ]),
                    Row(children: [
                      DetailsViewInfoTile(
                          title: "طريقة الاستخدام",
                          value: state.selectestMedicineDetails!.usageMethod,
                          icon: 'assets/images/chat_question_icon.png'),
                      Spacer(),
                      DetailsViewInfoTile(
                        title: " الجرعه",
                        value: state.selectestMedicineDetails!.dosage,
                        icon: 'assets/images/hugeicons_medicine-01.png',
                      ),
                    ]),
                    Row(children: [
                      DetailsViewInfoTile(
                          title: "عدد مرات في اليوم",
                          value:
                              state.selectestMedicineDetails!.dosageFrequency,
                          icon: 'assets/images/times_icon.png'),
                      Spacer(),
                      DetailsViewInfoTile(
                        title: " مدة الاستخدام",
                        value: state.selectestMedicineDetails!.usageDuration,
                        icon: 'assets/images/time_icon.png',
                      ),
                    ]),
                    Row(children: [
                      DetailsViewInfoTile(
                          title: "تاريخ انتهاء العلاح ",
                          value: state.selectestMedicineDetails!.timeDuration,
                          icon: 'assets/images/date_icon.png'),
                      Spacer(),
                      DetailsViewInfoTile(
                          title: "اسم الطبيب ",
                          value: state.selectestMedicineDetails!.doctorName,
                          icon: 'assets/images/doctor_icon.png'),
                    ]),
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
                      children: [
                        DetailsViewInfoTile(
                            title: "التنبيهات",
                            value:
                                state.selectestMedicineDetails!.reminderStatus
                                    ? 'مفعل'
                                    : 'غير مفعل',
                            icon: 'assets/images/date_icon.png'),
                        Spacer(),
                        CustomContainer(
                            value: state.selectestMedicineDetails!.reminder),
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

void _shareDetails(BuildContext context) {
  final medicine =
      context.read<MedicineViewCubit>().state.selectestMedicineDetails;
  if (medicine == null) return;

  final shareContent = '''
🩺 تفاصيل الدواء:

• اسم الدواء: ${medicine.medicineName}
• مستمر/متوقف: ${medicine.dosageFrequency}
• تاريخ بدء الدواء: ${medicine.startDate}
• دواء مرض مزمن: ${medicine.chronicDiseaseMedicine}
• طريقة الاستخدام: ${medicine.usageMethod}
• الجرعة: ${medicine.dosage}
• عدد مرات في اليوم: ${medicine.dosageFrequency}
• مدة الاستخدام: ${medicine.usageDuration}
• تاريخ انتهاء العلاج: ${medicine.timeDuration}
• اسم الطبيب: ${medicine.doctorName}
• الأعراض المرضية: ${medicine.mainSymptoms.join(', ')}
• الملاحظات الشخصية: ${medicine.personalNotes}
• التنبيهات: ${medicine.reminderStatus ? 'مفعل' : 'غير مفعل'}
• وقت التنبيه: ${medicine.reminder}
''';

  Share.share(shareContent, subject: 'تفاصيل دواء من تطبيق WeCare');
}
