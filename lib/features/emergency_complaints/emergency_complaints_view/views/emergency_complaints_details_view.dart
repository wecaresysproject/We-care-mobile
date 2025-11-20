import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:share_plus/share_plus.dart';
import 'package:we_care/core/di/dependency_injection.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/app_toasts.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/custom_app_bar_with_centered_title_widget.dart';
import 'package:we_care/core/global/SharedWidgets/details_view_info_tile.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/core/routing/routes.dart';
import 'package:we_care/features/emergency_complaints/emergency_complaints_view/logic/emergency_complaint_view_state.dart';
import 'package:we_care/features/emergency_complaints/emergency_complaints_view/logic/emergency_complaints_view_cubit.dart';

class EmergencyComplaintsDetailsView extends StatelessWidget {
  const EmergencyComplaintsDetailsView({super.key, required this.documentId});
  final String documentId;

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
                      await _shareComplaintDetails(context, state);
                    },
                    deleteFunction: () async {
                      await context
                          .read<EmergencyComplaintsViewCubit>()
                          .deleteEmergencyComplaintById(documentId);
                    },
                  ),
                  DetailsViewInfoTile(
                    title: "تاريخ ظهور الشكوى",
                    value: complaint.date,
                    icon: 'assets/images/date_icon.png',
                    isExpanded: true,
                  ),

                  // Display the main symptoms using SymptomContainer
                  ...complaint.mainSymptoms.asMap().entries.map((entry) {
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
      isExpanded: true,),

    DetailsViewInfoTile(
      title: "التشخيص",
      value: complaint.similarComplaint.diagnosis,
      icon: 'assets/images/doctor_stethoscope_icon.png',
      isExpanded: true,
    ),
],

// أدوية حالية
if (complaint.medications.dosage.isFilled ||
    complaint.medications.medicationName.isFilled) ...[
  SectionTitleContainer(
    title: "أدوية حالية",
    iconPath: 'assets/images/medicines.png',
  ),
    DetailsViewInfoTile(
      title: "تاريخ الاستخدام / الجرعة",
      value: complaint.medications.dosage,
      icon: 'assets/images/hugeicons_medicine-01.png',
      isExpanded: true,
    ),
    DetailsViewInfoTile(
      title: "اسم الدواء",
      value: complaint.medications.medicationName,
      icon: 'assets/images/doctor_name.png',
      isExpanded: true,
    ),
],

// تدخل طبي طارئ للشكوى
if (complaint.emergencyIntervention.interventionDate.isFilled ||
    complaint.emergencyIntervention.interventionType.isFilled) ...[
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

Future<void> _shareComplaintDetails(
    BuildContext context, EmergencyComplaintViewState state) async {
  try {
    final complaintDetails = state.selectedEmergencyComplaint!;

    final text = '''
    🚨 *تفاصيل الشكوى المرضية الطارئة* 🚨

    📅 *تاريخ ظهور الشكوى*: ${complaintDetails.date}

    💡 *الأعراض الرئيسية*:
    ${complaintDetails.mainSymptoms.map((symptom) {
      return '''
      - *المنطقة*: ${symptom.symptomsRegion}
      - *الشكوى*: ${symptom.sypmptomsComplaintIssue}
      - *طبيعة الشكوى*: ${symptom.natureOfComplaint}
      - *حدة الشكوى*: ${symptom.severityOfComplaint}
      ''';
    }).join('\n')}

    🔍 *شكوى مشابهة سابقًا*:
    - *التشخيص*: ${complaintDetails.similarComplaint.diagnosis}
    - *تاريخ الشكوى*: ${complaintDetails.similarComplaint.dateOfComplaint}

    💊 *الأدوية الحالية*:
    - *اسم الدواء*: ${complaintDetails.medications.medicationName}
    - *الجرعة*: ${complaintDetails.medications.dosage}

    🚑 *التدخل الطبي الطارئ*:
    - *نوع التدخل*: ${complaintDetails.emergencyIntervention.interventionType}
    - *تاريخ التدخل*: ${complaintDetails.emergencyIntervention.interventionDate}

    📝 *ملاحظات شخصية*: ${complaintDetails.personalNote}
    ''';

    await Share.share(text);
  } catch (e) {
    await showError("❌ حدث خطأ أثناء المشاركة");
  }
}
