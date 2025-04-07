import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:we_care/core/di/dependency_injection.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
<<<<<<< HEAD
import 'package:we_care/core/global/Helpers/app_toasts.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
=======
import 'package:we_care/core/global/Helpers/extensions.dart';
>>>>>>> 8d63f32 (Enables surgery data editing)
import 'package:we_care/core/global/SharedWidgets/details_view_app_bar.dart';
import 'package:we_care/core/global/SharedWidgets/details_view_image_with_title.dart';
import 'package:we_care/core/global/SharedWidgets/details_view_info_tile.dart';
import 'package:we_care/core/routing/routes.dart';
import 'package:we_care/features/surgeries/surgeries_view/logic/surgeries_view_cubit.dart';
import 'package:we_care/features/surgeries/surgeries_view/logic/surgeries_view_state.dart';

class SurgeryDetailsView extends StatelessWidget {
  const SurgeryDetailsView({super.key, required this.documentId});
  final String documentId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: getIt<SurgeriesViewCubit>()..getSurgeryDetailsById(documentId),
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
                  DetailsViewAppBar(
                    title: 'العمليات',
                    deleteFunction: () async => await context
                        .read<SurgeriesViewCubit>()
                        .deleteSurgeryById(documentId),
                    shareFunction: () => _shareSurgeryDetails(context, state),
                    editFunction: () async {
                      final result = await context.pushNamed(
                        Routes.surgeriesDataEntryView,
                        arguments: state.selectedSurgeryDetails,
                      );
                      if (result != null && result) {
                        if (!context.mounted) return;
                        await context
                            .read<SurgeriesViewCubit>()
                            .getSurgeryDetailsById(documentId);
                      }
                    },
                  ),
                  Row(children: [
                    DetailsViewInfoTile(
                      title: "كود ICHI",
                      value: state.selectedSurgeryDetails!.ichiCode ?? "-",
                      icon: 'assets/images/data_search_icon.png',
                    ),
                    Spacer(),
                    DetailsViewInfoTile(
                        title: "التاريخ",
                        value: state.selectedSurgeryDetails!.surgeryDate,
                        icon: 'assets/images/date_icon.png'),
                  ]),
                  Row(children: [
                    DetailsViewInfoTile(
                      title: "العضو",
                      value: state.selectedSurgeryDetails!.surgeryRegion,
                      icon: 'assets/images/body_icon.png',
                    ),
                    Spacer(),
                    DetailsViewInfoTile(
                        title: "المنطقة الفرعية ",
                        value: state.selectedSurgeryDetails!.subSurgeryRegion,
                        icon: 'assets/images/body_icon.png'),
                  ]),
                  DetailsViewInfoTile(
                    title: 'اسم العملية',
                    value: state.selectedSurgeryDetails!.surgeryName,
                    icon: 'assets/images/doctor_name.png',
                    isExpanded: true,
                  ),
                  DetailsViewInfoTile(
                    title: ' الهدف من الاجراء',
                    value: state.selectedSurgeryDetails!.purpose ??
                        "لم يتم تحديده",
                    icon: 'assets/images/chat_question_icon.png',
                    isExpanded: true,
                  ),
                  Row(children: [
                    DetailsViewInfoTile(
                      title: "التقنية المستخدمة",
                      value: state.selectedSurgeryDetails!.usedTechnique,
                      icon: 'assets/images/data_search_icon.png',
                    ),
                    Spacer(),
                    DetailsViewInfoTile(
                        title: "حالة العملية",
                        value: state.selectedSurgeryDetails!.surgeryStatus,
                        icon: 'assets/images/ratio.png'),
                  ]),
                  DetailsViewInfoTile(
                      title: "وصف مفصل",
                      value: state.selectedSurgeryDetails!.surgeryDescription,
                      icon: 'assets/images/notes_icon.png',
                      isExpanded: true),
                  Row(children: [
                    DetailsViewInfoTile(
                      title: "الجراح ",
                      value: state.selectedSurgeryDetails!.surgeonName,
                      icon: 'assets/images/surgery_icon.png',
                    ),
                    Spacer(),
                    DetailsViewInfoTile(
                      title: "طبيب الباطنة ",
                      value: state.selectedSurgeryDetails!.anesthesiologistName,
                      icon: 'assets/images/doctor_icon.png',
                    ),
                  ]),
                  Row(children: [
                    DetailsViewInfoTile(
                        title: "الدولة",
                        value: state.selectedSurgeryDetails!.country,
                        icon: 'assets/images/country_icon.png'),
                    Spacer(),
                    DetailsViewInfoTile(
                        title: "المستشفي",
                        value: state.selectedSurgeryDetails!.hospitalCenter,
                        icon: 'assets/images/hospital_icon.png'),
                  ]),
                  DetailsViewInfoTile(
                      title: " تعليمات بعد العملية",
                      value:
                          state.selectedSurgeryDetails!.postSurgeryInstructions,
                      icon: 'assets/images/symptoms_icon.png',
                      isExpanded: true),
                  DetailsViewInfoTile(
                      title: " توصيف العملية",
                      value: state.selectedSurgeryDetails!.surgeryDescription,
                      icon: 'assets/images/file_date_icon.png',
                      isExpanded: true),
                  DetailsViewInfoTile(
                      title: " ملاحظات شخصية",
                      value: state.selectedSurgeryDetails!.additionalNotes,
                      icon: 'assets/images/notes_icon.png',
                      isExpanded: true),
                  DetailsViewImageWithTitleTile(
                    image: state.selectedSurgeryDetails!.medicalReportImage,
                    title: "التقرير الطبي",
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

Future<void> _shareSurgeryDetails(
    BuildContext context, SurgeriesViewState state) async {
  try {
    final surgeryDetails = state.selectedSurgeryDetails!;

    // 📝 Extract text details
    final text = '''
    ⚕️ *تفاصيل العملية* ⚕️

    📅 *التاريخ*: ${surgeryDetails.surgeryDate}
    🏥 *المستشفى*: ${surgeryDetails.hospitalCenter}
    🌍 *الدولة*: ${surgeryDetails.country}
    🧑‍⚕️ *الجراح*: ${surgeryDetails.surgeonName}
    ⚕️ *طبيب الباطنة*: ${surgeryDetails.anesthesiologistName}
    🌤 *الحالة*: ${surgeryDetails.surgeryStatus}
    💪 *التقنية المستخدمة*: ${surgeryDetails.usedTechnique}
    📃 *التوصيف*: ${surgeryDetails.surgeryDescription}
    📕 *التعليمات بعد العملية*: ${surgeryDetails.postSurgeryInstructions}
    ''';

    // 📥 Download images
    final tempDir = await getTemporaryDirectory();
    List<String> imagePaths = [];

    if (surgeryDetails.medicalReportImage.startsWith("http")) {
      final imagePath = await downloadImage(
          surgeryDetails.medicalReportImage, tempDir, 'medical_report.png');
      if (imagePath != null) imagePaths.add(imagePath);
    }

    // 📤 Share text & images
    if (imagePaths.isNotEmpty) {
      await Share.shareXFiles(imagePaths.map((path) => XFile(path)).toList(),
          text: text);
    } else {
      await Share.share(text);
    }
  } catch (e) {
    await showError("❌ حدث خطأ أثناء المشاركة");
  }
}
