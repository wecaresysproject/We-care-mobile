import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
        value: getIt<ChronicDiseaseViewCubit>(),
        // ..getUserPrescriptionDetailsById(documentId),
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
                    // shareFunction: () => _shareDetails(context, state),

                    deleteFunction: () async {
                      await context
                          .read<ChronicDiseaseViewCubit>()
                          .deletePrescriptionById(documentId);
                    },
                  ),
                  DetailsViewInfoTile(
                    title: "تاريخ بداية التشخيص",
                    // value: state
                    //     .selectedPrescriptionDetails!.preDescriptionDate,
                    value: "غير محدد",
                    icon: 'assets/images/date_icon.png',
                    isExpanded: true,
                  ),
                  DetailsViewInfoTile(
                    title: "المرض المزمن",
                    // value: state.selectedPrescriptionDetails!.disease,
                    value: "غير محدد",

                    isExpanded: true,

                    icon: 'assets/images/t_icon.png',
                  ),
                  MedicineDetailsTemplate(
                    model: AddNewMedicineModel(
                      medicineName: "دواء ضغط الدم",
                      startDate: "2024-05-10",
                      dose: "50 ملغ",
                      numberOfDoses: "مرتين يوميًا",
                      medicalForm: "حبوب",
                    ),
                  ),
                  DetailsViewInfoTile(
                    title: "الطبيب المتابع",
                    // value: state.selectedPrescriptionDetails!.cause,
                    value: "غير محدد",

                    icon: 'assets/images/doctor_icon.png',
                    isExpanded: true,
                  ),
                  DetailsViewInfoTile(
                    title: "حالة المرض",
                    // value: state.selectedPrescriptionDetails!.cause,
                    value: "غير محدد",

                    icon: 'assets/images/thunder_image.png',
                    isExpanded: true,
                  ),
                  DetailsViewInfoTile(
                    title: "الأعراض الجانبية",
                    // value: state.selectedPrescriptionDetails!.cause,
                    value: "غير محدد",

                    icon: 'assets/images/symptoms_icon.png',
                    isExpanded: true,
                  ),
                  DetailsViewInfoTile(
                    title: "ملاحظات شخصية",
                    // value:
                    // state.selectedPrescriptionDetails!.preDescriptionNotes,
                    value: "غير محدد",

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

// Future<void> _shareDetails(
//     BuildContext context, PrescriptionViewState state) async {
//   try {
//     final prescriptionDetails = state.selectedPrescriptionDetails!;

//     // 📝 Extract text details
//     final text = '''
//     🩺 *تفاصيل الروشتة* 🩺

//     📅 *التاريخ*: ${prescriptionDetails.preDescriptionDate}
//     👩‍⚕️ *الاعراض *: ${prescriptionDetails.cause}
//     🔬 * المرض*: ${prescriptionDetails.disease}
//     👨‍⚕️ *الطبيب المعالج*: ${prescriptionDetails.doctorName}
//     🏥 *التخصص*: ${prescriptionDetails.doctorSpecialty}
//     🌍 *الدولة*: ${prescriptionDetails.country}
//     📝 *ملاحظات*: ${prescriptionDetails.preDescriptionNotes}
//     ''';

//     // 📥 Download images
//     final tempDir = await getTemporaryDirectory();
//     List<String> imagePaths = [];

//     if (prescriptionDetails.preDescriptionPhoto.startsWith("http")) {
//       final imagePath = await downloadImage(
//           prescriptionDetails.preDescriptionPhoto,
//           tempDir,
//           'analysis_image.png');
//       if (imagePath != null) imagePaths.add(imagePath);
//     }

// //!TODO: to be removed after adding real data
//     // 📤 Share text & images
//     if (imagePaths.isNotEmpty) {
//       await Share.shareXFiles([XFile(imagePaths.first)], text: text);
//     } else {
//       await Share.share(text);
//     }
//   } catch (e) {
//     await showError("❌ حدث خطأ أثناء المشاركة");
//   }
//
