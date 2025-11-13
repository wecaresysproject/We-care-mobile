import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/di/dependency_injection.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/app_toasts.dart';
import 'package:we_care/core/global/Helpers/share_details_helper.dart';
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
                children: [
                  AppBarWithCenteredTitle(
                    title: 'الامراض المزمنة',
                    editFunction: () async {
                      //! just un comment this section
                      // final result = await context.pushNamed(
                      //   Routes.chronicDiseaseDataEntry,
                      //   arguments: {
                      //     'id': documentId,
                      //     'editModel': state.selectedChronicDiseaseDetails
                      //   },
                      // );
                      // if (result) {
                      //   if (!context.mounted) return;
                      //   await context
                      //       .read<ChronicDiseaseViewCubit>()
                      //       .getUserChronicDiseaseDetailsById(documentId);
                      // }
                    },
                    shareFunction: () async {
                      final details = state.selectedChronicDiseaseDetails!;
                      await shareDetails(
                        title: '🩺 *تفاصيل المرض المزمن* 🩺',
                        details: {
                          '📅 *تاريخ بداية التشخيص*:':
                              details.diagnosisStartDate,
                          '🦠 *المرض المزمن*:': details.diseaseName,
                          '👨‍⚕️ *الطبيب المتابع*:': details.treatingDoctorName,
                          '📊 *حالة المرض*:': details.diseaseStatus,
                          '🤒 *الأعراض الجانبية*:': details.sideEffect,
                          '📝 *ملاحظات شخصية*:': details.personalNotes,
                        },
                        subLists: (details.medications).map((med) {
                          return {
                            '💊 اسم الدواء:': med.medicineName,
                            '📅 تاريخ بدء الدواء:': med.startDate,
                            '💉 الجرعة:': med.dose,
                            '🔄 عدد مرات الجرعة:': med.numberOfDoses,
                            '💊 الشكل الصيدلاني:': med.medicalForm,
                          };
                        }).toList(),
                        subListTitle: '💊 *الأدوية المستخدمة:*',
                        errorMessage:
                            "❌ حدث خطأ أثناء مشاركة تفاصيل المرض المزمن",
                      );
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
