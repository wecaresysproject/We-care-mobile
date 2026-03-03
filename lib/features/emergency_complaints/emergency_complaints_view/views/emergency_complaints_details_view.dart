import 'dart:io';

import 'package:flutter/foundation.dart';
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
import 'package:we_care/core/global/SharedWidgets/details_view_images_with_title_widget.dart';
import 'package:we_care/core/global/SharedWidgets/details_view_info_tile.dart';
import 'package:we_care/core/global/SharedWidgets/module_guidance_alert_dialog.dart';
import 'package:we_care/core/global/SharedWidgets/shared_app_bar_widget.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/core/models/module_guidance_response_model.dart';
import 'package:we_care/core/routing/routes.dart';
import 'package:we_care/features/emergency_complaints/emergency_complaints_view/logic/emergency_complaint_view_state.dart';
import 'package:we_care/features/emergency_complaints/emergency_complaints_view/logic/emergency_complaints_view_cubit.dart';

class EmergencyComplaintsDetailsView extends StatelessWidget {
  const EmergencyComplaintsDetailsView({
    super.key,
    required this.documentId,
    this.guidanceData,
  });
  final String documentId;
  final ModuleGuidanceDataModel? guidanceData;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<EmergencyComplaintsViewCubit>()
        ..getEmergencyComplaintDetailsById(documentId),
      child: Scaffold(
        appBar: AppBar(toolbarHeight: 0.h),
        body: BlocConsumer<EmergencyComplaintsViewCubit,
            EmergencyComplaintViewState>(
          listener: (context, state) async {
            if (state.requestStatus == RequestStatus.success &&
                state.isDeleteRequest) {
              Navigator.pop(context, true);
              await showSuccess("تم حذف الشكوى بنجاح");
            } else if (state.requestStatus == RequestStatus.failure) {
              await showError(state.responseMessage);
            }
          },
          builder: (context, state) {
            final complaint = state.selectedEmergencyComplaint;
            if (complaint == null) {
              return Center(child: CircularProgressIndicator());
            }

            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppBarWithCenteredTitle(
                    title: 'الشكاوى المرضية الطارئة',
                    trailingActions: [
                      CircleIconButton(
                        icon: Icons.play_arrow,
                        color: guidanceData?.videoLink?.isNotEmpty == true
                            ? AppColorsManager.mainDarkBlue
                            : Colors.grey,
                        onTap: guidanceData?.videoLink?.isNotEmpty == true
                            ? () => launchYouTubeVideo(guidanceData!.videoLink)
                            : null,
                      ),
                      SizedBox(width: 12.w),
                      CircleIconButton(
                        icon: Icons.menu_book_outlined,
                        color:
                            guidanceData?.moduleGuidanceText?.isNotEmpty == true
                                ? AppColorsManager.mainDarkBlue
                                : Colors.grey,
                        onTap:
                            guidanceData?.moduleGuidanceText?.isNotEmpty == true
                                ? () {
                                    ModuleGuidanceAlertDialog.show(
                                      context,
                                      title: 'الشكاوى المرضية الطارئة',
                                      description:
                                          guidanceData!.moduleGuidanceText!,
                                    );
                                  }
                                : null,
                      ),
                    ],
                    editFunction: () async {
                      await context.pushNamed(
                        Routes.emergenciesComplaintDataEntryView,
                        arguments: state.selectedEmergencyComplaint,
                      );
                      if (context.mounted) {
                        await context
                            .read<EmergencyComplaintsViewCubit>()
                            .getEmergencyComplaintDetailsById(documentId);
                      }
                    },
                    shareFunction: () async {
                      await shareEmergencyComplaint(context, state);
                    },
                    deleteFunction: () async {
                      await context
                          .read<EmergencyComplaintsViewCubit>()
                          .deleteEmergencyComplaintById(documentId);
                    },
                  ),
                  verticalSpacing(16),
                  DetailsViewInfoTile(
                    title: "تاريخ ظهور الشكوى",
                    value: complaint.date,
                    icon: 'assets/images/date_icon.png',
                    isExpanded: true,
                  ),

                  // Display the main symptoms using SymptomContainer
                  ...complaint.mainSymptoms.asMap().entries.map(
                    (entry) {
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
                    },
                  ),
                  if (complaint.additionalMedicalComplains.isNotEmptyOrNull &&
                      complaint.additionalMedicalComplains !=
                          context.translate.no_data_entered) ...[
                    SectionTitleContainer(
                      title: "شكاوى إضافية",
                      iconPath: 'assets/images/notes_icon.png',
                    ),
                    DetailsViewInfoTile(
                      title: "شكاوى إضافية",
                      value: complaint.additionalMedicalComplains!,
                      icon: 'assets/images/notes_icon.png',
                      isExpanded: true,
                    ),
                  ],
                  // شكاوى مشابهه سابقا
                  if (complaint.similarComplaint.dateOfComplaint.isFilled ||
                      complaint.similarComplaint.diagnosis.isFilled) ...[
                    SectionTitleContainer(
                      title: 'شكاوى مشابهه سابقا',
                      iconPath: 'assets/images/symptoms_icon.png',
                    ),
                    DetailsViewInfoTile(
                      title: "تاريخ الشكوى",
                      value: complaint.similarComplaint.dateOfComplaint,
                      icon: 'assets/images/date_icon.png',
                      isExpanded: true,
                    ),
                    DetailsViewInfoTile(
                      title: "التشخيص",
                      value: complaint.similarComplaint.diagnosis,
                      icon: 'assets/images/doctor_stethoscope_icon.png',
                      isExpanded: true,
                    ),
                  ],

                  DetailsViewImagesWithTitleTile(
                    isShareEnabled: true,
                    images: complaint
                        .complainsImages, // Replace with actual image URL or asset
                    title: "صور الشكاوي",
                  ),

// أدوية حالية
                  if (complaint.medications.dosage.isFilled ||
                      complaint.medications.medicationName.isFilled) ...[
                    SectionTitleContainer(
                      title: "أدوية حالية",
                      iconPath: 'assets/images/medicines.png',
                    ),
                    DetailsViewInfoTile(
                      title: "اسم الدواء",
                      value: complaint.medications.medicationName,
                      icon: 'assets/images/doctor_name.png',
                      isExpanded: true,
                    ),
                    DetailsViewInfoTile(
                      title: "الجرعة",
                      value: complaint.medications.dosage,
                      icon: 'assets/images/hugeicons_medicine-01.png',
                      isExpanded: true,
                    ),
                  ],

// تدخل طبي طارئ للشكوى
                  if (complaint
                          .emergencyIntervention.interventionDate.isFilled ||
                      complaint
                          .emergencyIntervention.interventionType.isFilled) ...[
                    SectionTitleContainer(
                      title: "تدخل طبي طارئ للشكوى",
                      iconPath: 'assets/images/medical_kit_icon.png',
                    ),
                    DetailsViewInfoTile(
                      title: "تاريخ التدخل",
                      value: complaint.emergencyIntervention.interventionDate,
                      icon: 'assets/images/date_icon.png',
                      isExpanded: true,
                    ),
                    DetailsViewInfoTile(
                      title: "نوع التدخل",
                      value: complaint.emergencyIntervention.interventionType,
                      icon: 'assets/images/qr_code_icon.png',
                      isExpanded: true,
                    ),
                  ],

                  if (complaint.personalNote.isFilled) ...[
                    SectionTitleContainer(
                      title: "ملاحظات شخصية",
                      iconPath: 'assets/images/notes_icon.png',
                    ),
                    DetailsViewInfoTile(
                      title: "ملاحظات شخصية",
                      value: complaint.personalNote,
                      icon: 'assets/images/notes_icon.png',
                      isExpanded: true,
                    ),
                  ],
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class SectionTitleContainer extends StatelessWidget {
  const SectionTitleContainer(
      {super.key, required this.title, required this.iconPath});
  final String title;
  final String iconPath;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 55.w, bottom: 10.h, left: 55.w),
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.5.h),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14.r),
          color: AppColorsManager.secondaryColor),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(iconPath, width: 15.w, height: 15.h),
          horizontalSpacing(5),
          Text(title,
              style: AppTextStyles.font14whiteWeight600.copyWith(
                color: AppColorsManager.mainDarkBlue,
              )),
        ],
      ),
    );
  }
}

class SymptomContainer extends StatelessWidget {
  const SymptomContainer({
    super.key,
    required this.isMainSymptom,
    required this.symptomArea,
    required this.symptomComplaint,
    required this.natureOfComplaint,
    required this.severityOfComplaint,
  });

  final bool isMainSymptom;
  final String symptomArea; // e.g., "صعوبة في التنفس - ارتفاع درجة الحرارة"
  final String
      symptomComplaint; // e.g., "صعوبة في التنفس / ارتفاع درجة الحرارة"
  final String natureOfComplaint; // e.g., "مستمرة"
  final String severityOfComplaint; // e.g., "هذا النص مثال"

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: isMainSymptom
          ? EdgeInsets.all(8)
          : EdgeInsets.only(left: 8, right: 8, bottom: 8),
      margin: const EdgeInsets.only(top: 16, bottom: 16),
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(color: AppColorsManager.mainDarkBlue, width: 1),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        children: [
          if (isMainSymptom) // Conditionally render the main symptom title
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Center(
                child: Text(
                  "العرض المرضي الرئيسي",
                  style: AppTextStyles.font18blackWight500.copyWith(
                    color: AppColorsManager.mainDarkBlue,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          DetailsViewInfoTile(
            title: "الأعراض المرضية - المنطقة",
            value: symptomArea,
            isExpanded: true,
            icon: 'assets/images/symptoms_icon.png',
          ),
          verticalSpacing(16),
          DetailsViewInfoTile(
            title: "الأعراض المرضية - الشكوى",
            value: symptomComplaint,
            isExpanded: true,
            icon: 'assets/images/symptoms_icon.png',
          ),
          verticalSpacing(16),
          Row(
            children: [
              DetailsViewInfoTile(
                title: "طبيعة الشكوى",
                value: natureOfComplaint,
                icon: 'assets/images/file_icon.png',
              ),
              Spacer(),
              DetailsViewInfoTile(
                title: "حدة الشكوى",
                value: severityOfComplaint,
                icon: 'assets/images/heart_rate_search_icon.png',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ============================
// 🔵 1) دالة تنظيف النص
// ============================
String? cleanValue(BuildContext context, String? value) {
  if (value == null ||
      value.trim().isEmpty ||
      value == context.translate.no_data_entered) {
    return null;
  }
  return value;
}

// ============================
// 🔵 2) دالة بناء بلوك كامل
// ============================
String buildBlock(String title, List<String?> lines) {
  final filtered =
      lines.where((line) => line != null && line.trim().isNotEmpty).toList();

  if (filtered.isEmpty) return ""; // إلغاء البلوك تمامًا

  return '''
$title
${filtered.join("\n")}
''';
}

// ============================
// 🔵 3) تحميل الصور
// ============================
Future<List<XFile>> downloadImages(List<String> urls) async {
  final client = HttpClient();
  List<XFile> files = [];

  for (final url in urls) {
    try {
      final request = await client.getUrl(Uri.parse(url));
      final response = await request.close();

      if (response.statusCode == 200) {
        final bytes = await consolidateHttpClientResponseBytes(response);
        final tempDir = await getTemporaryDirectory();

        final file = File(
          '${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg',
        );

        await file.writeAsBytes(bytes);
        files.add(XFile(file.path));
      }
    } catch (_) {}
  }

  return files;
}

// ============================
// 🔵 4) ميثود الشير الكاملة
// ============================
Future<void> shareEmergencyComplaint(
    BuildContext context, EmergencyComplaintViewState state) async {
  try {
    final c = state.selectedEmergencyComplaint!;

    // ---------------------------------------------------
    // 🔥 Build Blocks
    // ---------------------------------------------------

    // الأعراض الرئيسية
    final symptomsBlock = buildBlock(
      "💡 *الأعراض الرئيسية*: ",
      c.mainSymptoms.map((s) {
        return cleanValue(context, s.symptomsRegion) == null &&
                cleanValue(context, s.sypmptomsComplaintIssue) == null &&
                cleanValue(context, s.natureOfComplaint) == null &&
                cleanValue(context, s.severityOfComplaint) == null
            ? null
            : '''
- المنطقة: ${cleanValue(context, s.symptomsRegion)}
- الشكوى: ${cleanValue(context, s.sypmptomsComplaintIssue)}
- طبيعة الشكوى: ${cleanValue(context, s.natureOfComplaint)}
- حدة الشكوى: ${cleanValue(context, s.severityOfComplaint)}
''';
      }).toList(),
    );

    // شكوى مشابهة سابقًا
    final similarBlock = buildBlock(
      "🔍 *شكوى مشابهة سابقًا*: ",
      [
        cleanValue(context, c.similarComplaint.diagnosis) == null
            ? null
            : "- التشخيص: ${cleanValue(context, c.similarComplaint.diagnosis)}",
        cleanValue(context, c.similarComplaint.dateOfComplaint) == null
            ? null
            : "- تاريخ الشكوى: ${cleanValue(context, c.similarComplaint.dateOfComplaint)}",
      ],
    );

    // شكاوى إضافية
    final additionalComplaintsBlock = buildBlock(
      "🟦 *شكاوى إضافية*: ",
      [
        cleanValue(context, c.additionalMedicalComplains) == null
            ? null
            : "- ${cleanValue(context, c.additionalMedicalComplains)}",
      ],
    );

    // الأدوية الحالية
    final medsBlock = buildBlock(
      "💊 *الأدوية الحالية*: ",
      [
        cleanValue(context, c.medications.medicationName) == null
            ? null
            : "- الاسم: ${cleanValue(context, c.medications.medicationName)}",
        cleanValue(context, c.medications.dosage) == null
            ? null
            : "- الجرعة: ${cleanValue(context, c.medications.dosage)}",
      ],
    );

    // التدخل الطبي الطارئ
    final interventionBlock = buildBlock(
      "🚑 *التدخل الطبي الطارئ*: ",
      [
        cleanValue(context, c.emergencyIntervention.interventionType) == null
            ? null
            : "- النوع: ${cleanValue(context, c.emergencyIntervention.interventionType)}",
        cleanValue(context, c.emergencyIntervention.interventionDate) == null
            ? null
            : "- التاريخ: ${cleanValue(context, c.emergencyIntervention.interventionDate)}",
      ],
    );

    // ملاحظات شخصية
    final notesBlock = buildBlock(
      "📝 *ملاحظات شخصية*: ",
      [
        cleanValue(context, c.personalNote),
      ],
    );

    // ---------------------------------------------------
    // 🔥 Final Share Text
    // ---------------------------------------------------
    final text = '''
🚨 *تفاصيل الشكوى المرضية الطارئة* 🚨

📅 *تاريخ ظهور الشكوى*: ${cleanValue(context, c.date)}

$symptomsBlock
$similarBlock
$additionalComplaintsBlock
$medsBlock
$interventionBlock
$notesBlock
''';

    // ---------------------------------------------------
    // 🔥 Share images if available
    // ---------------------------------------------------
    if (c.complainsImages != null && c.complainsImages!.isNotEmpty) {
      final files = await downloadImages(c.complainsImages!);

      if (files.isNotEmpty) {
        await Share.shareXFiles(files, text: text);
        return;
      }
    }

    // مشاركة النص فقط لو مفيش صور
    await Share.share(text);
  } catch (e) {
    await showError("❌ حدث خطأ أثناء المشاركة");
  }
}
