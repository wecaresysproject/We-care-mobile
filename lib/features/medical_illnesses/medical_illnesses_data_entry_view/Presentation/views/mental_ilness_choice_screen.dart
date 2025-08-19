import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/custom_app_bar.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/core/routing/routes.dart';
import 'package:we_care/features/medical_illnesses/medical_illnesses_data_entry_view/logic/cubit/mental_illnesses_data_entry_cubit.dart';

class MentalIllnessChoiceScreen extends StatefulWidget {
  const MentalIllnessChoiceScreen({super.key});

  @override
  State<MentalIllnessChoiceScreen> createState() =>
      _MentalIllnessChoiceScreenState();
}

class _MentalIllnessChoiceScreenState extends State<MentalIllnessChoiceScreen> {
  @override
  void initState() {
    super.initState();

    // Call the Cubit method after the first frame is rendered
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        context
            .read<MedicalIllnessesDataEntryCubit>()
            .getActivationStatusOfUmbrella();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
          child: BlocBuilder<MedicalIllnessesDataEntryCubit,
              MedicalIllnessesDataEntryState>(
            buildWhen: (previous, current) =>
                previous.umbrellaActivationStatus !=
                current.umbrellaActivationStatus,
            builder: (context, state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CustomAppBarWidget(
                    haveBackArrow: true,
                  ),

                  verticalSpacing(72),

                  // Main Question
                  Text(
                    'هل تود تفعيل المتابعة النفسية الآمنة\nضمن مظلة WECARE؟',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.font22MainBlueWeight700.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColorsManager.textColor,
                      fontSize: 20.sp,
                    ),
                  ),
                  verticalSpacing(40),
                  // Buttons
                  _buildOptionButton(
                    label:
                        'أود تلقى المتابعة النفسية', //! disable border color and its text inside it , handle it with backend in sha2allah
                    iconPath: "assets/images/check_right.png",
                    isSelected: !state.umbrellaActivationStatus,
                    onTap: () async {
                      final bool? result = await context.pushNamed(
                        Routes.enableViewForWeCareMentalHealthUmbrella,
                      );
                      if (result != null && result == true && context.mounted) {
                        await context
                            .read<MedicalIllnessesDataEntryCubit>()
                            .getActivationStatusOfUmbrella();
                        // Handle successful navigation
                      }
                    },
                  ),
                  verticalSpacing(32),
                  _buildOptionButton(
                    isSelected: true,
                    label: state.umbrellaActivationStatus
                        ? 'الغاء التفعيل'
                        : 'أود التفعيل لاحقا', //! الغاء التفعيل ، in case it enabled by user and return back to this screen , handled with backend
                    iconPath: "assets/images/check_wrong.png",
                    onTap: () async {
                      final bool? result = await context.pushNamed(
                        Routes.disableViewForWeCareMentalHealthUmbrella,
                      );
                      if (result != null && result == true && context.mounted) {
                        await context
                            .read<MedicalIllnessesDataEntryCubit>()
                            .getActivationStatusOfUmbrella();
                        // Handle successful navigation
                      }
                    },
                    iconColor:
                        state.umbrellaActivationStatus ? Colors.red : null,
                  ),

                  verticalSpacing(72),

                  // Go to genetic diseases
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        iconSize: 28.sp,
                        backgroundColor: Color(0xFF003E78), // dark blue
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                      onPressed: () async {
                        await context.pushNamed(
                          Routes.mentalIllnessesDataEntryView,
                        );
                      },
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      label: Text(
                        'الذهاب للأمراض النفسية',
                        style: AppTextStyles.font22WhiteWeight600.copyWith(
                          fontSize: 20.sp,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildOptionButton({
    required String label,
    required String iconPath,
    required VoidCallback onTap,
    bool isSelected = false,
    Color? iconColor,
  }) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          side: BorderSide(
            color: isSelected
                ? AppColorsManager.mainDarkBlue
                : Colors.grey.shade400,
            width: 1.5,
          ),
          backgroundColor: isSelected ? Colors.transparent : Colors.white,
          padding: EdgeInsets.symmetric(
            vertical: 12.h,
            horizontal: 16.w,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
        ),
        onPressed: isSelected ? onTap : null, // 🔹 disable if not selected
        child: Row(
          children: [
            Image.asset(
              iconPath,
              width: 22.w,
              height: 22.h,
              color: iconColor ??
                  (isSelected
                      ? AppColorsManager.mainDarkBlue
                      : Colors.grey.shade500),
            ),
            horizontalSpacing(12),
            Text(
              label,
              style: AppTextStyles.font20blackWeight600.copyWith(
                color: isSelected
                    ? AppColorsManager.mainDarkBlue
                    : Colors.grey.shade500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
