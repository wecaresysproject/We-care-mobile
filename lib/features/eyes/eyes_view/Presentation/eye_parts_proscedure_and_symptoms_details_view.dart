import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:we_care/core/di/dependency_injection.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/app_toasts.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/custom_app_bar_with_centered_title_widget.dart';
import 'package:we_care/core/global/SharedWidgets/details_view_images_with_title_widget.dart';
import 'package:we_care/core/global/SharedWidgets/details_view_info_tile.dart';
import 'package:we_care/core/routing/routes.dart';
import 'package:we_care/features/eyes/eyes_data_entry_view/Presentation/views/eye_procedures_and_syptoms_data_entry.dart';
import 'package:we_care/features/eyes/eyes_view/logic/eye_view_cubit.dart';
import 'package:we_care/features/eyes/eyes_view/logic/eye_view_state.dart';

class EyePartsProcedureAndSymptomsDetailsView extends StatelessWidget {
  const EyePartsProcedureAndSymptomsDetailsView({
    super.key,
    required this.documentId,
    required this.title,
  });

  final String documentId;
  final String title;

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: getIt<EyeViewCubit>()..getEyePartDocumentDetails(documentId),
      child: Scaffold(
        appBar: AppBar(toolbarHeight: 0),
        body: BlocConsumer<EyeViewCubit, EyeViewState>(
          listener: (context, state) async {
            if (state.isDeleteRequest &&
                state.requestStatus == RequestStatus.success) {
              Navigator.pop(context);
              await showSuccess(state.responseMessage);
            } else if (state.isDeleteRequest &&
                state.requestStatus == RequestStatus.failure) {
              await showError(state.responseMessage);
            }
          },
          buildWhen: (prev, curr) =>
              prev.selectedEyePartDocumentDetails !=
              curr.selectedEyePartDocumentDetails,
          builder: (context, state) {
            final details = state.selectedEyePartDocumentDetails;

            if (state.requestStatus == RequestStatus.loading ||
                details == null) {
              return const Center(child: CircularProgressIndicator());
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  AppBarWithCenteredTitle(
                    title: title,
                    deleteFunction: () => context
                        .read<EyeViewCubit>()
                        .deleteEyePartDocument(documentId),
                    shareFunction: () =>
                        shareEyePartDetails(title, context, details),
                    editFunction: () async {
                      final result = await context.pushNamed(
                        Routes.eyeDataEntry,
                        arguments: {
                          'editModelId': documentId,
                          'pastEyeData': details,
                          'affectedEyePart': details.affectedEyePart,
                          'selectedProcedures': details.medicalProcedures
                              .map(
                                (e) => SymptomAndProcedureItem(
                                  id: e,
                                  title: e,
                                  isSelected: true,
                                ),
                              )
                              .toList(),
                          'selectedSymptoms': details.symptoms
                              .map(
                                (e) => SymptomAndProcedureItem(
                                  id: e,
                                  title: e,
                                  isSelected: true,
                                ),
                              )
                              .toList(),
                        },
                      );
                      if (result == true && context.mounted) {
                        await context
                            .read<EyeViewCubit>()
                            .getEyePartDocumentDetails(
                              documentId,
                            );
                      }
                    },
                    showActionButtons: true,
                  ),
                  DetailsViewInfoTile(
                    title: 'تاريخ الاعراض',
                    value: details.symptomStartDate,
                    icon: 'assets/images/date_icon.png',
                    isExpanded: true,
                  ),
                  DetailsViewInfoTile(
                    title: 'الاعراض',
                    value: details.symptoms.join(', '),
                    icon: 'assets/images/symptoms_icon.png',
                    isExpanded: true,
                  ),
                  DetailsViewInfoTile(
                    title: 'مدة الاعراض',
                    value: details.symptomDuration,
                    icon: 'assets/images/symptoms_icon.png',
                    isExpanded: true,
                  ),
                  DetailsViewInfoTile(
                    title: 'تاريخ الاجراء الطبي',
                    value: details.medicalReportDate,
                    icon: 'assets/images/date_icon.png',
                    isExpanded: true,
                  ),
                  DetailsViewInfoTile(
                    title: 'الاجراء الطبي',
                    value: details.medicalProcedures.join(', '),
                    icon: 'assets/images/doctor_icon.png',
                    isExpanded: true,
                  ),
                  DetailsViewImagesWithTitleTile(
                    images: details.medicalReportUrl,
                    title: 'التقرير الطبي',
                    isShareEnabled: true,
                  ),
                  DetailsViewImagesWithTitleTile(
                    images: details.medicalExaminationImages,
                    title: 'صورة الفحص الطبي',
                    isShareEnabled: true,
                  ),
                  DetailsViewInfoTile(
                    title: "التقرير الطبي الكتابي",
                    value: details.writtenReport,
                    icon: 'assets/images/notes_icon.png',
                    isExpanded: true,
                  ),
                  DetailsViewInfoTile(
                    isExpanded: true,
                    title: 'المركز / المستشفى',
                    value: details.centerHospitalName ??
                        details.eyeMedicalCenter ??
                        '',
                    icon: 'assets/images/hospital_icon.png',
                  ),
                  DetailsViewInfoTile(
                    isExpanded: true,
                    title: 'الطبيب',
                    value: details.doctorName,
                    icon: 'assets/images/doctor_name.png',
                  ),
                  DetailsViewInfoTile(
                    isExpanded: true,
                    title: 'الدولة',
                    value: details.country,
                    icon: 'assets/images/country_icon.png',
                  ),
                  DetailsViewInfoTile(
                    title: 'الملاحظات',
                    value: details.additionalNotes,
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

Future<void> shareEyePartDetails(
    String title, BuildContext context, dynamic details) async {
  final shareContent = '''
👁️ تفاصيل $title

📅 تاريخ الأعراض: ${details.symptomStartDate}
🤒 الأعراض: ${details.symptoms.join(', ')}
⏳ مدة الأعراض: ${details.symptomDuration}

🩺 الإجراء الطبي
📅 تاريخ الإجراء: ${details.medicalReportDate}
🔬 الإجراء الطبي: ${details.medicalProcedures.join(', ')}

📄 التقرير الطبي المكتوب
${details.writtenReport}

🏥 المركز / المستشفى: ${details.centerHospitalName ?? details.eyeMedicalCenter ?? ''}
👨‍⚕️ الطبيب: ${details.doctorName}
🌍 الدولة: ${details.country}

📝 ملاحظات إضافية:
${details.additionalNotes}
''';

  final tempDir = await getTemporaryDirectory();
  List<XFile> filesToShare = [];

  int reportIndex = 1;
  int examIndex = 1;

  /// صور التقرير الطبي
  if (details.medicalReportUrl != null) {
    for (final url in details.medicalReportUrl) {
      if (url.startsWith("http")) {
        final path = await downloadImage(
          url,
          tempDir,
          'صورة_التقرير_${reportIndex++}.jpg',
        );
        if (path != null) {
          filesToShare.add(XFile(path));
        }
      }
    }
  }

  /// صور الفحص الطبي
  if (details.medicalExaminationImages != null) {
    for (final url in details.medicalExaminationImages) {
      if (url.startsWith("http")) {
        final path = await downloadImage(
          url,
          tempDir,
          'صورة_الفحص_${examIndex++}.jpg',
        );
        if (path != null) {
          filesToShare.add(XFile(path));
        }
      }
    }
  }

  if (filesToShare.isNotEmpty) {
    await Share.shareXFiles(filesToShare, text: shareContent);
  } else {
    await Share.share(shareContent);
  }
}
