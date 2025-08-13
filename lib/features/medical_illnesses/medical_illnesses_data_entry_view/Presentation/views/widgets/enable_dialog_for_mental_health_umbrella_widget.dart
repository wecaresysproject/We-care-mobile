import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/app_toasts.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/medical_illnesses/medical_illnesses_data_entry_view/logic/cubit/mental_illnesses_data_entry_cubit.dart';

class EnableMentalHealthUmbrellaDialogWidget extends StatelessWidget {
  const EnableMentalHealthUmbrellaDialogWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocListener<MedicalIllnessesDataEntryCubit,
        MedicalIllnessesDataEntryState>(
      listener: (context, state) async {
        if (state.mentalIllnessesDataEntryStatus == RequestStatus.success) {
          await showSuccess(state.message);
          context.pop(result: true);
        } else if (state.mentalIllnessesDataEntryStatus ==
            RequestStatus.failure) {
          await showError(state.message);
        }
        // TODO: implement listener
      },
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(
            color: AppColorsManager.mainDarkBlue,
          ),
          gradient: LinearGradient(
            colors: [
              Color(0xFFFBFDFF),
              Color(0xFFECF5FF),
            ],
            end: Alignment.centerLeft,
            begin: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(22),
        ),
        child: Column(
          children: [
            // Content section
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 10.w,
                vertical: 16.h,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Image.asset(
                    'assets/images/smile_face.png',
                    height: 60.h,
                    width: 60.w,
                  ),

                  verticalSpacing(20),
                  // Welcome text
                  const Text(
                    'مرحباً بك تحت مظلة WECARE للدعم النفسي الآمن.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2C3E50),
                      height: 1.5,
                    ),
                  ),

                  // Description text
                  Text(
                    'نحن سعداء بانضمامك إلى هذه الرحلة المصممة خصيصاً لتقوم حالتك النفسية ودعمك بشكل علمي وفعال.',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.font16DarkGreyWeight400.copyWith(
                      color: AppColorsManager.textColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  verticalSpacing(10),

                  // Journey description
                  Text(
                    'قبل بدء هذه الرحلة، نود إعلامك بأنك ستتلقى مجموعة من الأسئلة النفسية والسلوكية كل يومين، تغطي محاور متنوعة تهدف إلى تقييم حالتك النفسية بدقة.',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.font16DarkGreyWeight400.copyWith(
                      color: AppColorsManager.textColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  verticalSpacing(10),

                  // Text(
                  //   'الإجابة الدقيقة والصادقة بـ (نعم / لا) تبيح لنا إعداد تقرير شامل وموثوق يعكس حالتك النفسية بشكل تدريجي على مدار شهر.',
                  //   textAlign: TextAlign.center,
                  //   softWrap: true,
                  //   style: AppTextStyles.font16DarkGreyWeight400.copyWith(
                  //     color: AppColorsManager.textColor,
                  //     fontWeight: FontWeight.w500,
                  //     fontSize: 10.sp,
                  //   ),
                  // ),
                ],
              ),
            ),
            verticalSpacing(36),
            // Action buttons
            Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: Color(0xff909090),
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                children: [
                  // Continue button
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        context.read<MedicalIllnessesDataEntryCubit>()
                          ..updateUmbrellaActivationStatus(true)
                          ..postActivationOfUmbrella();
                      },
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'أكمل',
                        style: AppTextStyles.font22WhiteWeight600.copyWith(
                          color: AppColorsManager.mainDarkBlue,
                        ),
                      ),
                    ),
                  ),

                  // Divider
                  Container(
                    width: 1,
                    height: 50,
                    color: Color(0xff909090),
                  ),

                  // Cancel button
                  Expanded(
                    child: TextButton(
                      onPressed: () async {
                        // Handle cancel action
                        context.read<MedicalIllnessesDataEntryCubit>()
                          ..updateUmbrellaActivationStatus(false)
                          ..postActivationOfUmbrella();
                        context.pop();
                      },
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'إلغاء',
                        style: AppTextStyles.font22WhiteWeight600.copyWith(
                          color: Color(0xffE02E2E),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
