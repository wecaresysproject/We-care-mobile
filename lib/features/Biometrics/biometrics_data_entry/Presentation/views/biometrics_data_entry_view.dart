import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/di/dependency_injection.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/custom_app_bar.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
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
                verticalSpacing(24),
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
              icon: Icons.favorite,
              label: 'نبضات\nالقلب',
              color: const Color(0xFFE74C3C),
              backgroundColor: const Color(0xFFFFE8E6),
              onTap: () =>
                  _showMeasurementDialog(context, 'نبضات القلب', 'bpm'),
            ),
          ),

          // Blood Pressure (الضغط)
          Positioned(
            top: 180.h,
            left: 0,
            child: BiometricMeasurementButton(
              icon: Icons.water_drop,
              label: 'الضغط',
              color: const Color(0xFF3498DB),
              backgroundColor: const Color(0xFFE3F2FD),
              onTap: () => _showMeasurementDialog(context, 'ضغط الدم', 'mmHg'),
            ),
          ),

          // Temperature (درجة الحرارة)
          Positioned(
            top: 300.h,
            left: 0,
            child: BiometricMeasurementButton(
              icon: Icons.thermostat,
              label: 'درجة الحرارة',
              color: const Color(0xFFFF9800),
              backgroundColor: const Color(0xFFFFF3E0),
              onTap: () =>
                  _showMeasurementDialog(context, 'درجة الحرارة', '°C'),
            ),
          ),

          // Weight (الوزن)
          Positioned(
            bottom: 10.h,
            left: 0,
            child: BiometricMeasurementButton(
              icon: Icons.monitor_weight,
              label: 'الوزن',
              color: const Color(0xFF9C27B0),
              backgroundColor: const Color(0xFFF3E5F5),
              onTap: () => _showMeasurementDialog(context, 'الوزن', 'kg'),
            ),
          ),

          // Right side buttons
          // Oxygen Level (مستوى الأكسجين)
          Positioned(
            top: 60.h,
            right: 0,
            child: BiometricMeasurementButton(
              icon: Icons.air,
              label: 'مستوى\nالأكسجين',
              color: const Color(0xFF00BCD4),
              backgroundColor: const Color(0xFFE0F2F1),
              onTap: () =>
                  _showMeasurementDialog(context, 'مستوى الأكسجين', '%'),
            ),
          ),

          // Random Blood Sugar (سكر عشوائي)
          Positioned(
            top: 180.h,
            right: 0,
            child: BiometricMeasurementButton(
              icon: Icons.bloodtype,
              label: 'سكر\nعشوائي',
              color: const Color(0xFFFF5722),
              backgroundColor: const Color(0xFFFBE9E7),
              onTap: () =>
                  _showMeasurementDialog(context, 'سكر الدم العشوائي', 'mg/dL'),
            ),
          ),

          // Fasting Blood Sugar (سكر صائم)
          Positioned(
            top: 300.h,
            right: 0,
            child: BiometricMeasurementButton(
              icon: Icons.science,
              label: 'سكر صائم',
              color: const Color(0xFF795548),
              backgroundColor: const Color(0xFFEFEBE9),
              onTap: () =>
                  _showMeasurementDialog(context, 'سكر الدم الصائم', 'mg/dL'),
            ),
          ),

          // Height (الطول)
          Positioned(
            bottom: 10.h,
            right: 0,
            child: BiometricMeasurementButton(
              icon: Icons.height,
              label: 'الطول',
              color: const Color(0xFF4CAF50),
              backgroundColor: const Color(0xFFE8F5E8),
              onTap: () => _showMeasurementDialog(context, 'الطول', 'cm'),
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
      ),
    );
  }
}

class BiometricMeasurementButton extends StatelessWidget {
  const BiometricMeasurementButton({
    super.key,
    required this.icon,
    required this.label,
    required this.color,
    required this.backgroundColor,
    required this.onTap,
    this.value,
  });

  final IconData icon;
  final String label;
  final Color color;
  final Color backgroundColor;
  final VoidCallback onTap;
  final String? value;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 70.w,
        padding: EdgeInsets.symmetric(vertical: 12.h),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: color.withOpacity(0.2)),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(8.r),
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: 20.sp,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              label,
              style: TextStyle(
                fontSize: 10.sp,
                fontWeight: FontWeight.w600,
                color: color,
                height: 1.2,
              ),
              textAlign: TextAlign.center,
            ),
            if (value != null) ...[
              SizedBox(height: 4.h),
              Text(
                value!,
                style: TextStyle(
                  fontSize: 8.sp,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
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
  });

  final String measurement;
  final String unit;
  final bool isRating;

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
                  Navigator.pop(context);
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
