import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/di/dependency_injection.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/Biometrics/biometrics_view/logic/biometrics_view_cubit.dart';
import 'package:we_care/features/Biometrics/biometrics_view/logic/biometrics_view_state.dart';

class CurrentBiometricsResultsTab extends StatelessWidget {
  const CurrentBiometricsResultsTab({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          getIt.get<BiometricsViewCubit>()..getCurrentBiometricData(),
      child: BlocBuilder<BiometricsViewCubit, BiometricsViewState>(
        builder: (context, state) {
          if (state.requestStatus == RequestStatus.loading) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppColorsManager.mainDarkBlue,
              ),
            );
          }
          return SizedBox(
            width: double.infinity,
            height: 550.h,
            child: Stack(
              children: [
                // Human body skeleton image - centered
                Center(
                  child: Image.asset(
                    "assets/images/skeleton_image.png",
                    fit: BoxFit.cover,
                    height: 420.h,
                  ),
                ),

                // Left side buttons
                // Heart Rate (نبضات القلب)
                Positioned(
                  top: 0.h,
                  left: 0,
                  child: BiometricMeasurementCard(
                    label: 'نبضات القلب',
                    image: 'assets/images/heart_beat.png',
                    value:
                        state.currentBiometricsData?.heartRate?.value ?? 'N/A',
                    date: state.currentBiometricsData?.heartRate?.date ?? 'N/A',
                  ),
                ),

                // Blood Pressure (الضغط)
                Positioned(
                  top: 125.h,
                  left: 0,
                  child: BiometricMeasurementCard(
                    label: 'الضغط',
                    value: state.currentBiometricsData?.bloodPressure?.value ??
                        'N/A',
                    date: state.currentBiometricsData?.bloodPressure?.date ??
                        'N/A',
                    image: 'assets/images/blood-pressure.png',
                  ),
                ),

                // Temperature (درجة الحرارة)
                Positioned(
                  top: 250.h,
                  left: 0,
                  child: BiometricMeasurementCard(
                    label: 'درجة الحرارة',
                    value:
                        state.currentBiometricsData?.bodyTemperature?.value ??
                            'N/A',
                    date: state.currentBiometricsData?.bodyTemperature?.date ??
                        'N/A',
                    image: 'assets/images/temperature_level.png',
                  ),
                ),

                // Weight (الوزن)
                Positioned(
                  top: 375.h,
                  left: 0,
                  child: BiometricMeasurementCard(
                    label: 'الوزن',
                    value: state.currentBiometricsData?.weight?.value ?? 'N/A',
                    date: state.currentBiometricsData?.weight?.date ?? 'N/A',
                    image: 'assets/images/weight.png',
                  ),
                ),

                // Right side buttons
                // Oxygen Level (مستوى الأكسجين)
                Positioned(
                  top: 0.h,
                  right: 0,
                  child: BiometricMeasurementCard(
                    label: 'مستوى الأكسجين',
                    value: state.currentBiometricsData?.oxygenLevel?.value ??
                        'N/A',
                    date:
                        state.currentBiometricsData?.oxygenLevel?.date ?? 'N/A',
                    image: 'assets/images/oxygen_level.png',
                  ),
                ),

                // Random Blood Sugar (سكر عشوائي)
                Positioned(
                  top: 125.h,
                  right: 0,
                  child: BiometricMeasurementCard(
                    label: 'سكر عشوائي',
                    value:
                        state.currentBiometricsData?.randomBloodSugar?.value ??
                            'N/A',
                    date: state.currentBiometricsData?.randomBloodSugar?.date ??
                        'N/A',
                    image: 'assets/images/glucose_level.png',
                  ),
                ),

                // Fasting Blood Sugar (سكر صائم)
                Positioned(
                  top: 250.h,
                  right: 0,
                  child: BiometricMeasurementCard(
                    label: 'سكر صائم',
                    value:
                        state.currentBiometricsData?.fastingBloodSugar?.value ??
                            'N/A',
                    date:
                        state.currentBiometricsData?.fastingBloodSugar?.date ??
                            'N/A',
                    image: 'assets/images/glucose_level.png',
                  ),
                ),

                // Height (الطول)
                Positioned(
                  top: 375.h,
                  right: 0,
                  child: BiometricMeasurementCard(
                    label: 'الطول',
                    value: state.currentBiometricsData?.height?.value ?? 'N/A',
                    date: state.currentBiometricsData?.height?.date ?? 'N/A',
                    image: 'assets/images/ruler.png',
                  ),
                ),

                // BMI
                Positioned(
                  top: 450.h,
                  left: MediaQuery.of(context).size.width / 2 - 70.w,
                  child: BiometricMeasurementCard(
                    label: 'مؤشر الكتلة ',
                    value: state.currentBiometricsData?.bmi?.value ?? 'N/A',
                    date: state.currentBiometricsData?.bmi?.date ?? 'N/A',
                    image: 'assets/images/BMI.png',
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class BiometricMeasurementCard extends StatelessWidget {
  const BiometricMeasurementCard(
      {super.key,
      required this.label,
      required this.image,
      required this.value,
      required this.date});

  final String label;
  final String image;
  final String value;
  final String date;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 6.h),
      padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 4.w),
      height: 120.h,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18.r), color: Color(0xffF1F3F6)),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 30.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22.r),
              border: Border.all(
                color: AppColorsManager.mainDarkBlue,
                width: 1.3.w,
              ),
              gradient: const LinearGradient(
                colors: [Color(0xFFCDE1F8), Color(0xFFE7E9EB)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Image.asset(
              image,
              width: 30.w,
              height: 30.h,
            ),
          ),
          verticalSpacing(6),
          Text(
            label,
            style: AppTextStyles.font12blackWeight400.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColorsManager.mainDarkBlue,
            ),
            textAlign: TextAlign.center,
          ),
          Text(
            value,
            style: AppTextStyles.font14blackWeight400.copyWith(
              color: AppColorsManager.mainDarkBlue,
              fontWeight: FontWeight.w600,
            ),
          ),
          verticalSpacing(3),
          Text(
            date,
            style: AppTextStyles.font12blackWeight400.copyWith(
              fontWeight: FontWeight.w300,
              color: AppColorsManager.mainDarkBlue,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
