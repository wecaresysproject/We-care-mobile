import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:we_care/core/di/dependency_injection.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/app_toasts.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/custom_app_bar_with_centered_title_widget.dart';
import 'package:we_care/core/global/SharedWidgets/details_view_image_with_title.dart';
import 'package:we_care/core/global/SharedWidgets/details_view_info_tile.dart';
import 'package:we_care/features/allergy/allergy_view/logic/allergy_view_cubit.dart';
import 'package:we_care/features/surgeries/surgeries_view/logic/surgeries_view_cubit.dart';
import 'package:we_care/features/surgeries/surgeries_view/logic/surgeries_view_state.dart';

class AllergyDetailsView extends StatelessWidget {
  const AllergyDetailsView({super.key, required this.documentId});
  final String documentId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: getIt<AllergyViewCubit>()..getSurgeryDetailsById(documentId),
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
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.w),
              child: Column(
                spacing: 16.h,
                children: [
                  AppBarWithCenteredTitle(
                    title: 'الحساسية',
                    // deleteFunction: () async => await context
                    //     .read<SurgeriesViewCubit>()
                    //     .deleteSurgeryById(documentId),
                    shareFunction: () => _shareAllergyDetails(context, state),
                    // editFunction: () async {
                    //   final result = await context.pushNamed(
                    //     Routes.surgeriesDataEntryView,
                    //     arguments: state.selectedSurgeryDetails,
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
                    value: state.selectedSurgeryDetails!.surgeryDate,
                    icon: 'assets/images/date_icon.png',
                    isExpanded: true,
                  ),
                  Row(
                    children: [
                      DetailsViewInfoTile(
                        title: "النوع",
                        value: state.selectedSurgeryDetails!.surgeryRegion,
                        icon: 'assets/images/qr_code_icon.png',
                      ),
                      Spacer(),
                      DetailsViewInfoTile(
                          //!joint t later with 1/
                          title: "مسببات الحساسية",
                          value: state.selectedSurgeryDetails!.subSurgeryRegion,
                          icon: 'assets/images/chat_question.png'),
                    ],
                  ),
                  DetailsViewInfoTile(
                    title: "الأعراض الجانبية المتوقعة ( رد الفعل التحسسى)",
                    value: state.selectedSurgeryDetails!.surgeryName,
                    icon: 'assets/images/symptoms_icon.png',
                    isExpanded: true,
                  ),
                  DetailsViewInfoTile(
                    title: "حدة الأعراض",
                    value: state.selectedSurgeryDetails!.purpose ??
                        "لم يتم تحديده",
                    icon: 'assets/images/thunder_image.png',
                    isExpanded: true,
                  ),
                  DetailsViewInfoTile(
                    title: "زمن بدء الأعراض بعد التعرض للمسبب",
                    value: state.selectedSurgeryDetails!.surgeryDescription,
                    icon: 'assets/images/time_icon.png',
                    isExpanded: true,
                  ),
                  Row(children: [
                    DetailsViewInfoTile(
                      title: "استشارة طبيب",
                      value: state.selectedSurgeryDetails!.usedTechnique,
                      icon: 'assets/images/doctor_icon.png',
                    ),
                    Spacer(),
                    DetailsViewInfoTile(
                      title: "اختبار حساسية",
                      value: state.selectedSurgeryDetails!.surgeryStatus,
                      icon: 'assets/images/data_search_icon.png',
                    ),
                  ]),
                  DetailsViewInfoTile(
                    title: "الأدوية",
                    value: state.selectedSurgeryDetails!.surgeryDescription,
                    icon: 'assets/images/medicine_icon.png',
                    isExpanded: true,
                  ),
                  Row(
                    children: [
                      DetailsViewInfoTile(
                        title: "هل العلاجات فعالة",
                        value: state.selectedSurgeryDetails!.surgeonName,
                        icon: 'assets/images/surgery_icon.png',
                      ),
                      Spacer(),
                      DetailsViewInfoTile(
                        title: "وجود صدمة تحسسية",
                        value:
                            state.selectedSurgeryDetails!.anesthesiologistName,
                        icon: 'assets/images/chat_question.png',
                      ),
                    ],
                  ),
                  DetailsViewImageWithTitleTile(
                    isShareEnabled: true,
                    image: state.selectedSurgeryDetails!
                        .medicalReportImage, // Replace with actual image URL or asset
                    title: "التقرير الطبى/اختبار الحساسية",
                  ),
                  DetailsViewInfoTile(
                    title: "التاريخ العائلى",
                    value:
                        state.selectedSurgeryDetails!.postSurgeryInstructions,
                    icon: 'assets/images/icon_family.png',
                    isExpanded: true,
                  ),
                  DetailsViewInfoTile(
                    title: "الاحتياطات",
                    value: state.selectedSurgeryDetails!.description ??
                        "لم يتم تحديده",
                    icon: 'assets/images/file_icon.png',
                    isExpanded: true,
                  ),
                  Row(
                    children: [
                      DetailsViewInfoTile(
                        title: "تحذير طبى للمسببات",
                        value: state.selectedSurgeryDetails!.surgeonName,
                        icon: 'assets/images/circular_warning.png',
                      ),
                      Spacer(),
                      DetailsViewInfoTile(
                        title: "حمل حقنة الإبينفرين",
                        value:
                            state.selectedSurgeryDetails!.anesthesiologistName,
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
    BuildContext context, SurgeriesViewState state) async {
  try {
    final allergy = state.selectedSurgeryDetails!;

    // 📝 Extract text details (re-mapped to allergy fields)
    final text = '''
⚕️ *تفاصيل الحساسية* ⚕️

📅 *التاريخ*: ${allergy.surgeryDate}
🦠 *مسببات الحساسية*: ${allergy.subSurgeryRegion}
🤧 *الأعراض الجانبية (رد الفعل التحسسي)*: ${allergy.surgeryName}
⚡ *حدة الأعراض*: ${allergy.purpose ?? "لم يتم تحديده"}
⏱ *زمن بدء الأعراض*: ${allergy.surgeryDescription}
👨‍⚕️ *استشارة طبيب*: ${allergy.usedTechnique}
🧪 *اختبار حساسية*: ${allergy.surgeryStatus}
💊 *الأدوية*: ${allergy.surgeryDescription}
💉 *هل العلاجات فعالة*: ${allergy.surgeonName}
🚨 *وجود صدمة تحسسية*: ${allergy.anesthesiologistName}
📷 *التقرير الطبي/اختبار الحساسية*: مرفق بالأسفل (إن وجد)
👪 *التاريخ العائلي*: ${allergy.postSurgeryInstructions}
📘 *الاحتياطات*: ${allergy.description ?? "لم يتم تحديده"}
⚠️ *تحذير طبي للمسببات*: ${allergy.surgeonName}
💉 *حمل حقنة الإبينفرين*: ${allergy.anesthesiologistName}
    ''';

    // 📥 Download medical report image if available
    final tempDir = await getTemporaryDirectory();
    List<String> imagePaths = [];

    if (allergy.medicalReportImage.startsWith("http")) {
      final imagePath = await downloadImage(
        allergy.medicalReportImage,
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
