import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/app_toasts.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/medical_illnesses/medical_illnesses_data_entry_view/logic/cubit/mental_illnesses_data_entry_cubit.dart';

class DisableMentalHealthUmbrellaDialogWidget extends StatelessWidget {
  const DisableMentalHealthUmbrellaDialogWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<MedicalIllnessesDataEntryCubit,
        MedicalIllnessesDataEntryState>(
      listener: (context, state) async {
        // TODO: implement listener
        if (state.mentalIllnessesDataEntryStatus == RequestStatus.success) {
          await showSuccess(state.message);
          context.pop(result: true);
        } else if (state.mentalIllnessesDataEntryStatus ==
            RequestStatus.failure) {
          await showError(state.message);
        }
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
                children: [
                  Image.asset(
                    'assets/images/sad_face.png',
                    height: 60.h,
                    width: 60.w,
                  ),

                  const SizedBox(height: 40),

                  // Description text
                  Text(
                    'بإيقاف التفعيل ، ستفقد جزءًا من التقدم الذي حققته في فهم حالتك النفسية ، ولن يتم إصدار التقرير النهائي في نهاية الشهر .',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.font16DarkGreyWeight400.copyWith(
                      color: AppColorsManager.textColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Report information
                  Text(
                    'نقترح إتمام الشهر الحالي للاستفادة القصوى من التقييم، ثم إيقاف التفعيل بعد ذلك إذا رغبت .',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.font16DarkGreyWeight400.copyWith(
                      color: AppColorsManager.textColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
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
                          ..updateUmbrellaActivationStatus(false)
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
                      onPressed: () {
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
