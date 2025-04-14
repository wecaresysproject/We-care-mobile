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
import 'package:intl/intl.dart';

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
                        // value: MedicineStatusHelper.determineMedicineStatus(
                        //   state.selectestMedicineDetails!.startDate,
                        //   state.selectestMedicineDetails!.usageDuration,
                        // ),
                        value: state.selectestMedicineDetails!.chronicDiseaseMedicine=='نعم'
                            ? 'مستمر'
                            : 'متوقف',
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
                          title: "عدد مرات الجرعة  ",
                          value:
                              state.selectestMedicineDetails!.dosageFrequency,
                          icon: 'assets/images/times_icon.png'),
                      Spacer(),
                      DetailsViewInfoTile(
                        title: " المدد الزمنية",
                        value: state.selectestMedicineDetails!.timeDuration,
                        icon: 'assets/images/time_icon.png',
                      ),
                    ]),
                    Row(children: [
                      DetailsViewInfoTile(
                          title: "مدة الاستخدام",
                          value: state.selectestMedicineDetails!.usageDuration,
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

class MedicineStatusHelper {
  static String determineMedicineStatus(String startDate, String timeDuration) {
    try {
      // Parse the start date (format: "dd/MM/yyyy")
      final dateParts = startDate.split('/');
      if (dateParts.length != 3) return "غير معروف";

      final day = int.parse(dateParts[0]);
      final month = int.parse(dateParts[1]);
      final year = int.parse(dateParts[2]);
      final startDateTime = DateTime(year, month, day);

      final today = DateTime.now();

      // Calculate end date based on timeDuration
      final endDateTime = _calculateEndDate(startDateTime, timeDuration);

      // Compare with today's date
      if (endDateTime == null) {
        return "مستمر"; // No end date case
      }

      return today.isBefore(endDateTime) ? "مستمر" : "متوقف";
    } catch (e) {
      return "غير معروف"; // In case of any parsing errors
    }
  }

  static DateTime? _calculateEndDate(DateTime startDate, String timeDuration) {
    if (timeDuration.isEmpty || timeDuration == "لم يتم ادخال بيانات") {
      return null;
    }

    // Handle different duration formats
    if (timeDuration.contains("المدد الزمنية الطويلة")) {
      return null; // Consider long durations as ongoing
    }

    // Parse specific durations
    if (timeDuration.contains("سنة واحدة")) {
      return DateTime(startDate.year + 1, startDate.month, startDate.day);
    }
    if (timeDuration.contains("شهرين")) {
      return DateTime(startDate.year, startDate.month + 2, startDate.day);
    }
    if (timeDuration.contains("3 أشهر")) {
      return DateTime(startDate.year, startDate.month + 3, startDate.day);
    }
    if (timeDuration.contains("6 أشهر")) {
      return DateTime(startDate.year, startDate.month + 6, startDate.day);
    }
    if (timeDuration.contains("9 أشهر")) {
      return DateTime(startDate.year, startDate.month + 9, startDate.day);
    }
    if (timeDuration.contains("سنتين")) {
      return DateTime(startDate.year + 2, startDate.month, startDate.day);
    }
    if (timeDuration.contains("3 سنوات")) {
      return DateTime(startDate.year + 3, startDate.month, startDate.day);
    }
    if (timeDuration.contains("6 أسابيع")) {
      return startDate.add(Duration(days: 6 * 7));
    }
    if (timeDuration.contains("مدى الحياة")) {
      return null;
    }

    return null; // Default for unknown durations
  }
}
