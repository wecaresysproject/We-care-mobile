import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:share_plus/share_plus.dart';
import 'package:we_care/core/di/dependency_injection.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/app_toasts.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/SharedWidgets/custom_app_bar_with_centered_title_widget.dart';
import 'package:we_care/core/global/SharedWidgets/details_view_info_tile.dart';
import 'package:we_care/core/routing/routes.dart';
import 'package:we_care/features/emergency_complaints/emergency_complaints_view/views/emergency_complaints_details_view.dart';
import 'package:we_care/features/medicine/medicine_view/logic/medicine_view_cubit.dart';
import 'package:we_care/features/medicine/medicine_view/logic/medicine_view_state.dart';

import '../../../../core/global/Helpers/share_details_helper.dart';

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
                  children: [
                    AppBarWithCenteredTitle(
                      isMedicineModule: true,
                      title: 'الدواء',
                      deleteFunction: () async {
                        await BlocProvider.of<MedicineViewCubit>(context)
                            .deleteMedicineById(documentId);
                        if (!context.mounted) return;
                        unawaited(
                          context
                              .read<MedicineViewCubit>()
                              .cancelAlarmsCreatedBeforePerMedicine(
                                state.selectestMedicineDetails!.medicineName,
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
                    DetailsViewInfoTile(
                      title: "اسم الدواء",
                      isExpanded: true,
                      value: state.selectestMedicineDetails!.medicineName,
                      icon: 'assets/images/doctor_name.png',
                    ),

                    Row(children: [
                      DetailsViewInfoTile(
                        title: "الشكل الدوائي",
                        value: " اقراص",
                        icon: 'assets/images/symptoms_icon.png',
                      ),
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
                        title: " مدة العلاج",
                        value: state.selectestMedicineDetails!.timeDuration,
                        icon: 'assets/images/time_icon.png',
                      ),
                    ]),
                    Row(children: [
                      DetailsViewInfoTile(
                          title: "تاريخ بدء الدواء",
                          value: state.selectestMedicineDetails!.startDate,
                          icon: 'assets/images/date_icon.png'),
                      Spacer(),
                      DetailsViewInfoTile(
                        title: "مستمر/متوقف",
                        value: state.selectestMedicineDetails!
                                    .chronicDiseaseMedicine ==
                                'نعم'
                            ? 'مستمر'
                            : 'متوقف',
                        icon: 'assets/images/doctor_name.png',
                      ),
                    ]),
                    Row(
                      children: [
                        DetailsViewInfoTile(
                          title: "اسم الطبيب ",
                          value: state.selectestMedicineDetails!.doctorName,
                          icon: 'assets/images/doctor_icon.png',
                        ),
                        Spacer(),
                        DetailsViewInfoTile(
                          title: " دواء مرض مزمن",
                          value: state
                              .selectestMedicineDetails!.chronicDiseaseMedicine,
                          icon: 'assets/images/medicine_icon.png',
                        ),
                      ],
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

String calculateMedicineStatus(String startDateStr, String durationStr) {
  try {
    // Split the string manually by hyphen to extract year, month, and day
    final dateParts = startDateStr.split('-');
    if (dateParts.length != 3) {
      throw FormatException("Invalid date format");
    }

    // Extract year, month, and day
    final year = int.parse(dateParts[0]);
    final month = int.parse(dateParts[1]);
    final day = int.parse(dateParts[2]);

    // Create the DateTime object
    final startDate = DateTime(year, month, day);

    final now = DateTime.now();

    Duration duration;

    // Determine the duration in days based on the given string
    switch (durationStr) {
      case '6 أسابيع':
        duration = Duration(days: 42); // 6 weeks
        break;
      case 'شهرين':
        duration = Duration(days: 60); // 2 months
        break;
      case '3 أشهر':
        duration = Duration(days: 90); // 3 months
        break;
      case '6 أشهر':
        duration = Duration(days: 180); // 6 months
        break;
      case '9 أشهر':
        duration = Duration(days: 270); // 9 months
        break;
      case 'سنة واحدة':
        duration = Duration(days: 365); // 1 year
        break;
      case 'سنتين':
        duration = Duration(days: 730); // 2 years
        break;
      case '3 سنوات':
        duration = Duration(days: 1095); // 3 years
        break;
      case 'مدى الحياة':
        return 'مستمر'; // Lifetime, always ongoing
      default:
        return 'غير معروف'; // Unknown duration
    }

    // Calculate the end date by adding the duration to the start date
    final endDate = startDate.add(duration);

    // Return the status based on whether the current date is before or after the end date
    return now.isBefore(endDate) ? 'مستمر' : 'متوقف';
  } catch (e) {
    return 'غير معروف'; // In case of an error or invalid date format
  }
}

Future<void> _shareMedicineDetails(BuildContext context) async {
  final medicine =
      context.read<MedicineViewCubit>().state.selectestMedicineDetails;
  if (medicine == null) return;

  // 🧠 نحول القيم البوليان إلى نص عربي
  String boolToText(bool? value) => value == true ? 'نعم' : 'لا';

  // 🧾 تفاصيل الدواء الأساسية
  final detailsMap = {
    '💊 *اسم الدواء*:': medicine.medicineName,
    '🧪 *الشكل الدوائي*:': 'أقراص',
    '📏 *الجرعة*:': medicine.dosage,
    '🔁 *عدد مرات الجرعة*:': medicine.dosageFrequency,
    '⏳ *المدد الزمنية*:': medicine.timeDuration,
    '🔄 *مستمر/متوقف*:':
        (medicine.chronicDiseaseMedicine == 'نعم') ? 'مستمر' : 'متوقف',
    '📅 *تاريخ بدء الدواء*:': medicine.startDate,
    '🧬 *دواء مرض مزمن*:': medicine.chronicDiseaseMedicine,
    '👨‍⚕️ *اسم الطبيب*:': medicine.doctorName,
    '📝 *الملاحظات الشخصية*:':
        (medicine.personalNotes?.isNotEmpty ?? false) ? medicine.personalNotes : 'لا توجد',
    '⏰ *التنبيهات*:': boolToText(medicine.reminderStatus),
    '🕒 *وقت التنبيه*:': medicine.reminder,
  };

  // 🌟 الأعراض المرضية (قائمة فرعية)
  final symptomsList = (medicine.mainSymptoms ?? []).map((s) {
    final index = medicine.mainSymptoms.indexOf(s);
    return {
      '${index == 0 ? "🌟 (رئيسي)" : "🔹"} *منطقة:*': s.symptomsRegion,
      '🩺 *الشكوى:*': s.sypmptomsComplaintIssue,
      '⚙️ *طبيعة الشكوى:*': s.natureOfComplaint,
      '📊 *الشدة:*': s.severityOfComplaint,
    };
  }).toList();

  // 🚀 نستخدم الميثود الجينيريك
  await shareDetails(
    title: '🩺 *تفاصيل الدواء*',
    details: detailsMap,
    subLists: symptomsList,
    subListTitle: '🧠 *الأعراض المرضية:*',
    errorMessage: '❌ حدث خطأ أثناء مشاركة تفاصيل الدواء',
  );
}
