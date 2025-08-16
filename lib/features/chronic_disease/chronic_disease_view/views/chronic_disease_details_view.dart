import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:share_plus/share_plus.dart';
import 'package:we_care/core/di/dependency_injection.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/app_toasts.dart';
import 'package:we_care/core/global/SharedWidgets/custom_app_bar_with_centered_title_widget.dart';
import 'package:we_care/core/global/SharedWidgets/details_view_info_tile.dart';
import 'package:we_care/features/chronic_disease/chronic_disease_view/logic/chronic_disease_view_cubit.dart';
import 'package:we_care/features/chronic_disease/chronic_disease_view/views/widgets/medicine_details_template_widget.dart';
import 'package:we_care/features/chronic_disease/data/models/add_new_medicine_model.dart';

class ChronicDiseaseDetailsView extends StatelessWidget {
  const ChronicDiseaseDetailsView({super.key, required this.documentId});
  final String documentId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0.h,
      ),
      body: BlocProvider.value(
        value: getIt<ChronicDiseaseViewCubit>()
          ..getUserChronicDiseaseDetailsById(documentId),
        child: BlocConsumer<ChronicDiseaseViewCubit, ChronicDiseaseViewState>(
          listenWhen: (previous, current) =>
              previous.isDeleteRequest != current.isDeleteRequest,
          listener: (context, state) {
            if (state.requestStatus == RequestStatus.failure) {
              showError(state.responseMessage);
            }
            if (state.requestStatus == RequestStatus.success) {
              showSuccess(state.responseMessage);
              Navigator.pop(context, true);
            }
          },
          builder: (context, state) {
            if (state.requestStatus == RequestStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            }
            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.w),
              child: Column(
                spacing: 16.h,
                children: [
                  AppBarWithCenteredTitle(
                    title: 'الامراض المزمنة',
                    editFunction: () async {
                      // final result = await context.pushNamed(
                      //   Routes.prescriptionCategoryDataEntryView,
                      //   arguments: state.selectedPrescriptionDetails!,
                      // );
                      // if (result) {
                      //   if (!context.mounted) return;
                      //   await context
                      //       .read<ChronicDiseaseViewCubit>()
                      //       .getUserPrescriptionDetailsById(documentId);
                      // }
                    },
                    shareFunction: () async {
                      await _shareDetails(context, state);
                    },
                    deleteFunction: () async {
                      await context
                          .read<ChronicDiseaseViewCubit>()
                          .deleteUserChronicDiseaseById(documentId);
                    },
                  ),
                  DetailsViewInfoTile(
                    title: "تاريخ بداية التشخيص",
                    value:
                        state.selectedChronicDiseaseDetails!.diagnosisStartDate,
                    icon: 'assets/images/date_icon.png',
                    isExpanded: true,
                  ),
                  DetailsViewInfoTile(
                    title: "المرض المزمن",
                    value: state.selectedChronicDiseaseDetails!.diseaseName,
                    isExpanded: true,
                    icon: 'assets/images/t_icon.png',
                  ),
                  //  state.selectedChronicDiseaseDetails!.medications.map((med)
                  ...state.selectedChronicDiseaseDetails!.medications.map(
                    (med) => MedicineDetailsTemplate(
                      model: AddNewMedicineModel(
                        medicineName: med.medicineName,
                        startDate: med.startDate,
                        dose: med.dose,
                        numberOfDoses: med.numberOfDoses,
                        medicalForm: med.medicalForm,
                      ),
                    ),
                  ),

                  DetailsViewInfoTile(
                    title: "الطبيب المتابع",
                    value:
                        state.selectedChronicDiseaseDetails!.treatingDoctorName,
                    icon: 'assets/images/doctor_icon.png',
                    isExpanded: true,
                  ),
                  DetailsViewInfoTile(
                    title: "حالة المرض",
                    value: state.selectedChronicDiseaseDetails!.diseaseStatus,
                    icon: 'assets/images/thunder_image.png',
                    isExpanded: true,
                  ),
                  DetailsViewInfoTile(
                    title: "الأعراض الجانبية",
                    value: state.selectedChronicDiseaseDetails!.sideEffect,
                    icon: 'assets/images/symptoms_icon.png',
                    isExpanded: true,
                  ),
                  DetailsViewInfoTile(
                    title: "ملاحظات شخصية",
                    value: state.selectedChronicDiseaseDetails!.personalNotes,
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

// Future<void> _shareDetailsDummy(BuildContext context) async {
//   try {
//     // 📝 بيانات الأدوية (مثال على أكتر من دواء)
//     final medications = [
//       {
//         "medicineName": "Clavulanic acid",
//         "startDate": "2025-03-01",
//         "dose": "مرتين في اليوم",
//         "numberOfDoses": "مرتين",
//         "medicalForm": "حبوب"
//       },
//       {
//         "medicineName": "دواء ضغط الدم",
//         "startDate": "2024-05-10",
//         "dose": "50 ملغ",
//         "numberOfDoses": "مرتين يوميًا",
//         "medicalForm": "حبوب"
//       }
//     ];

//     // 📝 تحويل الأدوية لنص
//     final medicationsText = medications.map((med) {
//       return '''
// 💊 اسم الدواء: ${med["medicineName"]}
// 📅 تاريخ بدء الدواء: ${med["startDate"]}
// 💉 الجرعة: ${med["dose"]}
// 🔄 عدد مرات الجرعة: ${med["numberOfDoses"]}
// 💊 الشكل الصيدلاني: ${med["medicalForm"]}
// ''';
//     }).join("\n-----------------\n");

//     // 📝 النص النهائي حسب ترتيب الصفحة
//     final text = '''
// 🩺 *تفاصيل المرض المزمن* 🩺

// 📅 *تاريخ بداية التشخيص*: 2025-03-01
// 🦠 *المرض المزمن*: التهاب المفاصل الروماتويدي

// $medicationsText

// 👨‍⚕️ *الطبيب المتابع*: د. أسامة أحمد
// 📊 *حالة المرض*: تحت السيطرة
// 🤒 *الأعراض الجانبية*: صداع مزمن
// 📝 *ملاحظات شخصية*: هذا النص هو مثال نص يمكن أن يستبدل في نفس المساحة.
// ''';

//     await Share.share(text);
//   } catch (e) {
//     await showError("❌ حدث خطأ أثناء المشاركة");
//   }
// }

Future<void> _shareDetails(
    BuildContext context, ChronicDiseaseViewState state) async {
  try {
    final details = state.selectedChronicDiseaseDetails!;

    // 📝 الأدوية (ممكن أكتر من دواء)
    final medicationsText = (details.medications ?? []).map((med) {
      return '''
💊 اسم الدواء: ${med.medicineName}
📅 تاريخ بدء الدواء: ${med.startDate}
💉 الجرعة: ${med.dose}
🔄 عدد مرات الجرعة: ${med.numberOfDoses}
💊 الشكل الصيدلاني: ${med.medicalForm}
''';
    }).join("\n-----------------\n");

    // 📝 النص النهائي حسب ترتيب الصفحة
    final text = '''
🩺 *تفاصيل المرض المزمن* 🩺

📅 *تاريخ بداية التشخيص*: ${details.diagnosisStartDate}
🦠 *المرض المزمن*: ${details.diseaseName}

$medicationsText

👨‍⚕️ *الطبيب المتابع*: ${details.treatingDoctorName}
📊 *حالة المرض*: ${details.diseaseStatus}
🤒 *الأعراض الجانبية*: ${details.sideEffect}
📝 *ملاحظات شخصية*: ${details.personalNotes}
''';

    await Share.share(text);
  } catch (e) {
    await showError("❌ حدث خطأ أثناء المشاركة");
  }
}
