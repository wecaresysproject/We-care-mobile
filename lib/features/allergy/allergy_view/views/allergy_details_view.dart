import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:we_care/core/di/dependency_injection.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/app_toasts.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/custom_app_bar_with_centered_title_widget.dart';
import 'package:we_care/core/global/SharedWidgets/details_view_image_with_title.dart';
import 'package:we_care/core/global/SharedWidgets/details_view_info_tile.dart';
import 'package:we_care/features/allergy/allergy_view/logic/allergy_view_cubit.dart';

class AllergyDetailsView extends StatelessWidget {
  const AllergyDetailsView({super.key, required this.documentId});
  final String documentId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: getIt<AllergyViewCubit>()..getSingleAllergyDetailsById(documentId),
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 0.h,
        ),
        body: BlocConsumer<AllergyViewCubit, AllergyViewState>(
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
          buildWhen: (previous, current) =>
              previous.selectedAllergyDetails != current.selectedAllergyDetails,
          builder: (context, state) {
            if (state.requestStatus == RequestStatus.loading ||
                state.selectedAllergyDetails == null) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.w),
              child: Column(
                spacing: 16.h,
                children: [
                  AppBarWithCenteredTitle(
                    title: 'الحساسية',
                    deleteFunction: () async => await context
                        .read<AllergyViewCubit>()
                        .deleteAllergyById(documentId),
                    shareFunction: () => _shareAllergyDetails(context, state),
                    // editFunction: () async {
                    //   final result = await context.pushNamed(
                    //     Routes.surgeriesDataEntryView,
                    //     arguments: state.selectedAllergyDetails,
                    //   );
                    //   if (result != null && result) {
                    //     if (!context.mounted) return;
                    //     await context
                    //         .read<SurgeriesViewCubit>()
                    //         .getSurgeryDetailsById(documentId);
                    //   }
                    // },
                  ),
                  DetailsViewInfoTile(
                    title: "التاريخ",
                    value: state.selectedAllergyDetails!.allergyOccurrenceDate,
                    icon: 'assets/images/date_icon.png',
                    isExpanded: true,
                  ),
                  Row(
                    children: [
                      DetailsViewInfoTile(
                        title: "النوع",
                        value: state.selectedAllergyDetails!.allergyType,
                        icon: 'assets/images/qr_code_icon.png',
                      ),
                      Spacer(),
                      DetailsViewInfoTile(
                          //!joint t later with 1/
                          title: "مسببات الحساسية",
                          value: state.selectedAllergyDetails!.allergyTriggers
                              .join(', '),
                          icon: 'assets/images/chat_question.png'),
                    ],
                  ),
                  DetailsViewInfoTile(
                    title: "الأعراض الجانبية المتوقعة",
                    value: state.selectedAllergyDetails!.expectedSideEffects!,
                    icon: 'assets/images/symptoms_icon.png',
                    isExpanded: true,
                  ),
                  DetailsViewInfoTile(
                    title: "حدة الأعراض",
                    value: state.selectedAllergyDetails!.symptomSeverity!,
                    icon: 'assets/images/thunder_image.png',
                    isExpanded: true,
                  ),
                  DetailsViewInfoTile(
                    title: "زمن بدء الأعراض بعد التعرض للمسبب",
                    value: state.selectedAllergyDetails!.timeToSymptomOnset!,
                    icon: 'assets/images/time_icon.png',
                    isExpanded: true,
                  ),
                  Row(children: [
                    DetailsViewInfoTile(
                      title: "استشارة طبيب",
                      value: state.selectedAllergyDetails?.isDoctorConsulted ==
                              null
                          ? context.translate.no_data_entered
                          : state.selectedAllergyDetails!.isDoctorConsulted!
                              ? 'نعم'
                              : 'لا',
                      icon: 'assets/images/doctor_icon.png',
                    ),
                    Spacer(),
                    DetailsViewInfoTile(
                      title: "اختبار حساسية",
                      value: state.selectedAllergyDetails!
                                  .isAllergyTestPerformed ==
                              null
                          ? context.translate.no_data_entered
                          : state.selectedAllergyDetails!
                                  .isAllergyTestPerformed!
                              ? 'نعم'
                              : 'لا',
                      icon: 'assets/images/data_search_icon.png',
                    ),
                  ]),
                  DetailsViewInfoTile(
                    title: "الأدوية",
                    value: state.selectedAllergyDetails!.medicationName!,
                    icon: 'assets/images/medicine_icon.png',
                    isExpanded: true,
                  ),
                  Row(
                    children: [
                      DetailsViewInfoTile(
                        title: "هل العلاجات فعالة",
                        value: state.selectedAllergyDetails!
                                    .isTreatmentsEffective ==
                                null
                            ? context.translate.no_data_entered
                            : state.selectedAllergyDetails!
                                    .isTreatmentsEffective!
                                ? 'نعم'
                                : 'لا',
                        icon: 'assets/images/surgery_icon.png',
                      ),
                      Spacer(),
                      DetailsViewInfoTile(
                        title: "وجود صدمة تحسسية",
                        value: state.selectedAllergyDetails!.proneToAllergies ??
                            '--',
                        icon: 'assets/images/chat_question.png',
                      ),
                    ],
                  ),
                  DetailsViewImageWithTitleTile(
                    isShareEnabled: true,
                    image: state.selectedAllergyDetails!
                        .medicalReportImage!, // Replace with actual image URL or asset
                    title: "التقرير الطبى/اختبار الحساسية",
                  ),
                  DetailsViewInfoTile(
                    title: "التاريخ العائلى",
                    value: state.selectedAllergyDetails!.familyHistory!,
                    icon: 'assets/images/icon_family.png',
                    isExpanded: true,
                  ),
                  DetailsViewInfoTile(
                    title: "الاحتياطات",
                    value: state.selectedAllergyDetails!.precautions!,
                    icon: 'assets/images/file_icon.png',
                    isExpanded: true,
                  ),
                  Row(
                    children: [
                      DetailsViewInfoTile(
                        title: "تحذير طبى للمسببات",
                        value: state
                            .selectedAllergyDetails!.isMedicalWarningReceived!,
                        icon: 'assets/images/circular_warning.png',
                      ),
                      Spacer(),
                      DetailsViewInfoTile(
                        title: "حمل حقنة الإبينفرين",
                        value: state
                                .selectedAllergyDetails!.carryEpinephrine.isNull
                            ? '--'
                            : state.selectedAllergyDetails!.carryEpinephrine!
                                ? 'نعم'
                                : 'لا',
                        icon: 'assets/images/Injection.png',
                      ),
                    ],
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

Future<void> _shareAllergyDetails(
    BuildContext context, AllergyViewState state) async {
  try {
    final allergy = state.selectedAllergyDetails!;

    // 📝 Extract text details (re-mapped to allergy fields)
    final text = '''
⚕️ *تفاصيل الحساسية* ⚕️

📅 *التاريخ*: ${allergy.allergyOccurrenceDate}
🦠 *مسببات الحساسية*: ${allergy.allergyTriggers}
🤧 *الأعراض الجانبية (رد الفعل التحسسي)*: ${allergy.expectedSideEffects}
⚡ *حدة الأعراض*: ${allergy.symptomSeverity ?? "لم يتم تحديده"}
⏱ *زمن بدء الأعراض*: ${allergy.timeToSymptomOnset}
👨‍⚕️ *استشارة طبيب*: ${allergy.isDoctorConsulted}
🧪 *اختبار حساسية*: ${allergy.isAllergyTestPerformed}
💊 *الأدوية*: ${allergy.medicationName}
💉 *هل العلاجات فعالة*: ${allergy.isTreatmentsEffective}
🚨 *وجود صدمة تحسسية*: ${allergy.proneToAllergies}
📷 *التقرير الطبي/اختبار الحساسية*: مرفق بالأسفل (إن وجد)
👪 *التاريخ العائلي*: ${allergy.familyHistory}
📘 *الاحتياطات*: ${allergy.precautions ?? "لم يتم تحديده"}
⚠️ *تحذير طبي للمسببات*: ${allergy.isMedicalWarningReceived}
💉 *حمل حقنة الإبينفرين*: ${allergy.carryEpinephrine}
    ''';

    // 📥 Download medical report image if available
    final tempDir = await getTemporaryDirectory();
    List<String> imagePaths = [];

    if (allergy.medicalReportImage != null &&
        allergy.medicalReportImage!.startsWith("http")) {
      final imagePath = await downloadImage(
        allergy.medicalReportImage!,
        tempDir,
        'allergy_report.png',
      );
      if (imagePath != null) imagePaths.add(imagePath);
    }

    // 📤 Share text & image
    if (imagePaths.isNotEmpty) {
      await Share.shareXFiles(imagePaths.map((path) => XFile(path)).toList(),
          text: text);
    } else {
      await Share.share(text);
    }
  } catch (e) {
    await showError("❌ حدث خطأ أثناء مشاركة تفاصيل الحساسية");
  }
}
