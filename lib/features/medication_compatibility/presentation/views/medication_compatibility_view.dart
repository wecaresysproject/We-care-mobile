import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/di/dependency_injection.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/custom_app_bar_with_centered_title_widget.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/features/medicine/shared/widgets/medicine_form_fields_widget.dart';
import 'package:we_care/features/medicine/medicines_data_entry/logic/cubit/medicines_data_entry_cubit.dart';

class MedicationCompatibilityView extends StatelessWidget {
  const MedicationCompatibilityView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<MedicinesDataEntryCubit>(
      create: (context) {
        final cubit = getIt<MedicinesDataEntryCubit>();
        cubit.initialDataEntryRequests();
        return cubit;
      },
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 0,
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AppBarWithCenteredTitle(
                  title:'اختبار توافق ادويتي'
                  ,showActionButtons: false,
                ),
                verticalSpacing(24),
                MedicinesDataEntryFormFieldsWidget(
                  showStartDate: false,
                  showChronicDisease: false,
                  showMedicalComplaints: false,
                  showDoctorName: false,
                  showAlarms: false,
                  showPersonalNotes: false,
                  onCustomSubmit: () {
                    print("Compatibility Check Submitted");
                  },
                ),
                Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Column(
                    children: [
                      Text(
                        "تنويه:",
                        style: AppTextStyles.font16BlackSemiBold,
                        textAlign: TextAlign.center,
                      ),
                      verticalSpacing(8),
                      Text(
                        "هذا الموديل لا يقدم استشارة أو رأيا طبيا، ولا يغني عن مراجعة الطبيب أو الصيدلي المختص. تعتمد النتائج على تحليل سجلك الصحي والمرضي باستخدام نماذج ذكاء اصطناعي معروفة، بهدف تزويدك بمعلومات إرشادية تساعدك على التواصل الفعال مع الطبيب، وطرح الأسئلة المناسبة، والتنبيه إلى نقاط الخطر المحتملة، والأخطاء التي قد تنتج عن تشخيص غير دقيق أو وصف أدوية لا تتناسب مع حالتك الصحية، أو أدويتك الحالية، أو أمراضك المزمنة، أو نتائج التحاليل الطبية.",
                        style: AppTextStyles.font14BlackMedium.copyWith(
                          height: 1.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                verticalSpacing(20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
