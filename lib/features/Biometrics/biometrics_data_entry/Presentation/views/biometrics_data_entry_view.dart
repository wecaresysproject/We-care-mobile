import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/di/dependency_injection.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/custom_app_bar.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/Biometrics/biometrics_data_entry/logic/cubit/biometrics_data_entry_cubit.dart';

class BiometricsDataEntryView extends StatelessWidget {
  const BiometricsDataEntryView({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return BlocProvider<BiometricsDataEntryCubit>(
      create: (context) => getIt<BiometricsDataEntryCubit>(),
      child: Scaffold(
        appBar: AppBar(),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CustomAppBarWidget(
                  haveBackArrow: true,
                ),
                verticalSpacing(24),
                Text(
                  "ادخل ما تريد لإدخال\n رقم قياسه",
                  style: AppTextStyles.font22MainBlueWeight700.copyWith(
                    color: Colors.black,
                    fontFamily: "Rubik",
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.center,
                ),
                BiometricSkeletonSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class BiometricSkeletonSection extends StatelessWidget {
  const BiometricSkeletonSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 500.h,
      child: Stack(
        children: [
          // Human body skeleton image - centered
          Center(
            child: Image.asset(
              "assets/images/skeleton_image.png",
              fit: BoxFit.contain,
              height: 420.h,
            ),
          ),

          // Left side buttons
          // Heart Rate (نبضات القلب)
          Positioned(
            top: 60.h,
            left: 0,
            child: BiometricMeasurementButton(
              label: 'نبضات\nالقلب',
              onTap: () =>
                  _showMeasurementDialog(context, 'نبضات القلب', 'bpm'),
              image: 'assets/images/heart_beat.png',
            ),
          ),

          // Blood Pressure (الضغط)
          Positioned(
            top: 180.h,
            left: 0,
            child: BiometricMeasurementButton(
              label: 'الضغط',
              onTap: () => _showMeasurementDialog(context, 'ضغط الدم', 'mmHg'),
              image: 'assets/images/blood-pressure.png',
            ),
          ),

          // Temperature (درجة الحرارة)
          Positioned(
            top: 300.h,
            left: 0,
            child: BiometricMeasurementButton(
              label: 'درجة الحرارة',
              onTap: () =>
                  _showMeasurementDialog(context, 'درجة الحرارة', '°C'),
              image: 'assets/images/temperature_level.png',
            ),
          ),

          // Weight (الوزن)
          Positioned(
            bottom: 10.h,
            left: 0,
            child: BiometricMeasurementButton(
              label: 'الوزن',
              onTap: () => _showMeasurementDialog(context, 'الوزن', 'kg'),
              image: 'assets/images/weight_level.png',
            ),
          ),

          // Right side buttons
          // Oxygen Level (مستوى الأكسجين)
          Positioned(
            top: 60.h,
            right: 0,
            child: BiometricMeasurementButton(
              label: 'مستوى\nالأكسجين',
              onTap: () =>
                  _showMeasurementDialog(context, 'مستوى الأكسجين', '%'),
              image: 'assets/images/oxygen_level.png',
            ),
          ),

          // Random Blood Sugar (سكر عشوائي)
          Positioned(
            top: 180.h,
            right: 0,
            child: BiometricMeasurementButton(
              label: 'سكر\nعشوائي',
              onTap: () =>
                  _showMeasurementDialog(context, 'سكر الدم العشوائي', 'mg/dL'),
              image: 'assets/images/glucose_level.png',
            ),
          ),

          // Fasting Blood Sugar (سكر صائم)
          Positioned(
            top: 300.h,
            right: 0,
            child: BiometricMeasurementButton(
              label: 'سكر صائم',
              onTap: () =>
                  _showMeasurementDialog(context, 'سكر الدم الصائم', 'mg/dL'),
              image: 'assets/images/glucose_level.png',
            ),
          ),

          // Height (الطول)
          Positioned(
            bottom: 10.h,
            right: 0,
            child: BiometricMeasurementButton(
              label: 'الطول',
              onTap: () => _showMeasurementDialog(context, 'الطول', 'cm'),
              image: 'assets/images/ruler.png',
            ),
          ),
        ],
      ),
    );
  }

  void _showMeasurementDialog(
      BuildContext context, String measurement, String unit) {
    showDialog(
      context: context,
      builder: (context) => BiometricInputDialog(
        measurement: measurement,
        unit: unit,
        onSave: (categoryName, userInput) {
          // context.read<BiometricsDataEntryCubit>().saveBiometricData(
          //   categoryName: categoryName,
          //   value: userInput,
          //   unit: unit,
          // );
        },
      ),
    );
  }
}

class BiometricMeasurementButton extends StatelessWidget {
  const BiometricMeasurementButton({
    super.key,
    required this.label,
    required this.image,
    required this.onTap,
  });

  final String label;
  final String image;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 54.w,
            height: 44.h,
            padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 10.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18.r),
              gradient: const LinearGradient(
                colors: [Color(0xFFCDE1F8), Color(0xFFE7E9EB)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.25),
                  offset: const Offset(0, 2),
                  blurRadius: 3,
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Image.asset(
              image,
              width: 34.w,
              height: 28.h,
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
        ],
      ),
    );
  }
}

class BiometricInputDialog extends StatefulWidget {
  const BiometricInputDialog({
    super.key,
    required this.measurement,
    required this.unit,
    this.isRating = false,
    this.onSave, // Added callback parameter
  });

  final String measurement;
  final String unit;
  final bool isRating;
  final Function(String categoryName, String userInput)?
      onSave; // Callback function

  @override
  State<BiometricInputDialog> createState() => _BiometricInputDialogState();
}

class _BiometricInputDialogState extends State<BiometricInputDialog> {
  final TextEditingController _controller = TextEditingController();
  int _rating = 3;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.r),
      ),
      backgroundColor: Colors.white,
      title: Column(
        children: [
          Container(
            padding: EdgeInsets.all(12.r),
            decoration: BoxDecoration(
              color: const Color(0xFF4A90E2).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.edit,
              color: const Color(0xFF4A90E2),
              size: 24.sp,
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            'إدخال ${widget.measurement}',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF2C3E50),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (!widget.isRating) ...[
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF8F9FE),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: const Color(0xFFE0E6ED)),
              ),
              child: TextField(
                controller: _controller,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
                decoration: InputDecoration(
                  hintText: 'أدخل القيمة',
                  hintStyle: TextStyle(
                    color: Colors.grey[400],
                    fontWeight: FontWeight.normal,
                  ),
                  suffixText: widget.unit,
                  suffixStyle: TextStyle(
                    color: const Color(0xFF4A90E2),
                    fontWeight: FontWeight.w600,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(16.r),
                ),
              ),
            ),
          ] else ...[
            Text(
              'قيم من 1 إلى 5',
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 16.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(5, (index) {
                return GestureDetector(
                  onTap: () => setState(() => _rating = index + 1),
                  child: Container(
                    width: 40.w,
                    height: 40.h,
                    decoration: BoxDecoration(
                      color: _rating > index
                          ? const Color(0xFF4A90E2)
                          : Colors.grey[300],
                      shape: BoxShape.circle,
                      boxShadow: _rating > index
                          ? [
                              BoxShadow(
                                color: const Color(0xFF4A90E2).withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ]
                          : null,
                    ),
                    child: Center(
                      child: Text(
                        '${index + 1}',
                        style: TextStyle(
                          color:
                              _rating > index ? Colors.white : Colors.grey[600],
                          fontWeight: FontWeight.bold,
                          fontSize: 16.sp,
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ],
        ],
      ),
      actions: [
        Row(
          children: [
            Expanded(
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
                child: Text(
                  'إلغاء',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 16.sp,
                  ),
                ),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  final value =
                      widget.isRating ? _rating.toString() : _controller.text;

                  // // Validate input
                  // if (!widget.isRating && value.trim().isEmpty) {
                  //   ScaffoldMessenger.of(context).showSnackBar(
                  //     SnackBar(
                  //       content: Text('يرجى إدخال قيمة'),
                  //       backgroundColor: Colors.red,
                  //       shape: RoundedRectangleBorder(
                  //         borderRadius: BorderRadius.circular(8.r),
                  //       ),
                  //       behavior: SnackBarBehavior.floating,
                  //     ),
                  //   );
                  //   return;
                  // }

                  Navigator.pop(context);

                  // Call the callback function with category name and user input
                  if (widget.onSave != null) {
                    widget.onSave!(widget.measurement, value);
                  }

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                          'تم حفظ ${widget.measurement}: $value ${widget.unit}'),
                      backgroundColor: const Color(0xFF4CAF50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4A90E2),
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  elevation: 2,
                ),
                child: Text(
                  'حفظ',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
