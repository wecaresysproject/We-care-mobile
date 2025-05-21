import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/custom_action_button_widget.dart';
import 'package:we_care/core/global/SharedWidgets/details_view_app_bar.dart';
import 'package:we_care/core/global/SharedWidgets/details_view_image_with_title.dart';
import 'package:we_care/core/global/SharedWidgets/details_view_info_tile.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';

class DentalOperationDetailsView extends StatelessWidget {
  const DentalOperationDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(toolbarHeight: 0.h),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.w),
        child: Column(
          children: [
            DetailsViewAppBar(title: 'علاج العصبي'),
            verticalSpacing(16),
            SymptomContainer(
              complaintDate: "2023-10-01",
              complaintReason: "التهاب في اللثة",
              symptomComplaint: "صعوبة في التنفس / ارتفاع درجة الحرارة",
              natureOfComplaint: "مستمرة",
              severityOfComplaint: "هذا النص مثال",
            ),
            verticalSpacing(16),
            MedicalOperationsComponent(
              operationStartDate: "2023-10-01",
              mainMedicalOperation: "علاج العصب",
              secendoryMedicalOperation: "حشو عصب",
              operationDetailedDescription:
                  "تم إجراء عملية علاج العصب بنجاح، وتم حشو العصب بشكل كامل.",
              operationType: "جراحي",
              operationLevelOfPain: "خفيف",
              operationRecoveryDuration: "3 أسابيع",
              useOfAnesthesia: "نعم",
            ),
            verticalSpacing(16),
            Row(children: [
              DetailsViewInfoTile(
                title: "الدولة",
                value: "مصر",
                icon: 'assets/images/country_icon.png',
              ),
              Spacer(),
              DetailsViewInfoTile(
                title: "المستشفي",
                value: "دار الفؤاد",
                icon: 'assets/images/hospital_icon.png',
              ),
            ]),

            DetailsViewInfoTile(
              title: " ملاحظات شخصية",
              value:
                  "هذا الإجراء مؤلم قليلًا، يستحسن في المستقبل الكشف الدوري لتفادي مثل هذه الحالات.",
              icon: 'assets/images/notes_icon.png',
              isExpanded: true,
            ),

            DetailsViewImageWithTitleTile(
              image:
                  "assets/images/x_ray_sample.png" , // Replace with actual image URL or asset
              title: "التقرير الطبي",
            ),
            DetailsViewImageWithTitleTile(
              image:
                 "assets/images/x_ray_sample.png" , 
              title: "اللقطة السنية",
            ),
          ],
        ),
      ),
    );
  }
}


class SymptomContainer extends StatelessWidget {
  const SymptomContainer({
    super.key,
    required this.complaintDate,
    required this.symptomComplaint,
    required this.natureOfComplaint,
    required this.severityOfComplaint,
    required this.complaintReason,
  });

   final String complaintDate; 
  final String symptomComplaint; 
  final String natureOfComplaint; 
  final String severityOfComplaint;
  final String complaintReason;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:  EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(color: AppColorsManager.mainDarkBlue, width: 1),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        children: [
            Row(
              children: [
                Text(
                  "الشكوي المرضية",
                  style: AppTextStyles.font18blackWight500.copyWith(
                    color: AppColorsManager.mainDarkBlue,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.start,),
                Spacer(),
                     CustomActionButton(
                  onTap: () {
                    
                  },
                  title: 'ارسال',
                  icon: 'assets/images/share.png',
                ),

              ],
            ),
          verticalSpacing(8),
          DetailsViewInfoTile(
            title: "تاريخ الشكوى",
            value: complaintDate,
            icon: 'assets/images/date_icon.png',
            isExpanded: true,
          ),
          verticalSpacing(16),
          DetailsViewInfoTile(
            title: " الشكوى",
            value: symptomComplaint,
            isExpanded: true,
            icon: 'assets/images/symptoms_icon.png',
          ),
          verticalSpacing(16),
                 DetailsViewInfoTile(
            title: "الاسباب المحتملة ",
            value: complaintReason,
            icon: 'assets/images/notes_icon.png',
            isExpanded: true,
          ),
          verticalSpacing(16),
        
              DetailsViewInfoTile(
                title: "طبيعة الشكوى",
                value: natureOfComplaint,
                icon: 'assets/images/file_icon.png',
                isExpanded: true,
              ),
          verticalSpacing(16),
              DetailsViewInfoTile(
                title: "حدة الشكوى",
                value: severityOfComplaint,
                icon: 'assets/images/heart_rate_search_icon.png',
                isExpanded: true,
              ),
            ],
     
       
      ),
    );
  }
}

class MedicalOperationsComponent extends StatelessWidget {
  const MedicalOperationsComponent({
    super.key,
    required this.operationStartDate,
    required this.mainMedicalOperation,
    required this.secendoryMedicalOperation,
    required this.operationDetailedDescription,
    required this.operationType,
    required this.operationLevelOfPain,
    required this.operationRecoveryDuration,
    required this.useOfAnesthesia,
  });

  final String operationStartDate;
  final String mainMedicalOperation;
  final String secendoryMedicalOperation;
  final String operationDetailedDescription;
  final String operationType;
  final String operationLevelOfPain;
  final String operationRecoveryDuration;
  final String useOfAnesthesia;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(color: AppColorsManager.mainDarkBlue, width: 1),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
   Row(
              children: [
                Text(
                  "الإجراء الطبي",
                  style: AppTextStyles.font18blackWight500.copyWith(
                    color: AppColorsManager.mainDarkBlue,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.start,),
                Spacer(),
                     CustomActionButton(
                  onTap: () {
                    
                  },
                  title: 'ارسال',
                  icon: 'assets/images/share.png',
                ),

              ],
            ),
          verticalSpacing(8),
          DetailsViewInfoTile(
            title: "تاريخ الإجراء",
            value: operationStartDate,
            icon: 'assets/images/date_icon.png',
            isExpanded: true,
          ),
          verticalSpacing(16),
          DetailsViewInfoTile(
            title: "الإجراء الطبي الرئيسي",
            value: mainMedicalOperation,
            icon: 'assets/images/data_search_icon.png',
            isExpanded: true,
          ),
          verticalSpacing(16),
          DetailsViewInfoTile(
            title: "الإجراء الطبي الفرعي",
            value: secendoryMedicalOperation,
            icon: 'assets/images/data_search_icon.png',
            isExpanded: true,
          ),
          verticalSpacing(16),
           DetailsViewInfoTile(
            title: "الوصف التفصيلي للإجراء",
            value: operationDetailedDescription,
            icon: 'assets/images/notes_icon.png',
            isExpanded: true,
          ),
          verticalSpacing(16),
       Row(
            children: [
              DetailsViewInfoTile(
                title: "نوع الإجراء",
                value: operationType,
                icon: 'assets/images/file_icon.png',
              ),
              Spacer(),
              DetailsViewInfoTile(
                title: "مستوى الألم",
                value: operationLevelOfPain,
                icon: 'assets/images/heart_rate_search_icon.png',
              ),
            ],
          ),
          verticalSpacing(16),
          Row(
            children: [
              DetailsViewInfoTile(
                title: "استخدام التخدير",
                value: useOfAnesthesia,
                icon: 'assets/images/file_icon.png',
              ),
              Spacer(),
                      DetailsViewInfoTile(
            title: "مدة الشفاء",
            value: operationRecoveryDuration,
            icon: 'assets/images/notes_icon.png',
          ),
            
            ],
          ),
        ],
      ),
    );
  }
}
