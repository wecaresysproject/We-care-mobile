// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:we_care/features/Biometrics/biometrics_data_entry/Presentation/views/biometrics_data_entry_view.dart';

// class BiometricSkeletonSection extends StatelessWidget {
//   const BiometricSkeletonSection({
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       width: double.infinity,
//       height: 500.h,
//       child: Stack(
//         children: [
//           // Human body skeleton image - centered
//           Center(
//             child: Image.asset(
//               "assets/images/skeleton_image.png",
//               fit: BoxFit.contain,
//               height: 420.h,
//             ),
//           ),

//           // Left side buttons
//           // Heart Rate (نبضات القلب)
//           Positioned(
//             top: 60.h,
//             left: 0,
//             child: BiometricMeasurementButton(
//               icon: Icons.favorite,
//               label: 'نبضات\nالقلب',
//               color: const Color(0xFFE74C3C),
//               backgroundColor: const Color(0xFFFFE8E6),
//               onTap: () =>
//                   _showMeasurementDialog(context, 'نبضات القلب', 'bpm'),
//             ),
//           ),

//           // Blood Pressure (الضغط)
//           Positioned(
//             top: 180.h,
//             left: 0,
//             child: BiometricMeasurementButton(
//               icon: Icons.water_drop,
//               label: 'الضغط',
//               color: const Color(0xFF3498DB),
//               backgroundColor: const Color(0xFFE3F2FD),
//               onTap: () => _showMeasurementDialog(context, 'ضغط الدم', 'mmHg'),
//             ),
//           ),

//           // Temperature (درجة الحرارة)
//           Positioned(
//             top: 300.h,
//             left: 0,
//             child: BiometricMeasurementButton(
//               icon: Icons.thermostat,
//               label: 'درجة الحرارة',
//               color: const Color(0xFFFF9800),
//               backgroundColor: const Color(0xFFFFF3E0),
//               onTap: () =>
//                   _showMeasurementDialog(context, 'درجة الحرارة', '°C'),
//             ),
//           ),

//           // Weight (الوزن)
//           Positioned(
//             bottom: 10.h,
//             left: 0,
//             child: BiometricMeasurementButton(
//               icon: Icons.monitor_weight,
//               label: 'الوزن',
//               color: const Color(0xFF9C27B0),
//               backgroundColor: const Color(0xFFF3E5F5),
//               onTap: () => _showMeasurementDialog(context, 'الوزن', 'kg'),
//             ),
//           ),

//           // Right side buttons
//           // Oxygen Level (مستوى الأكسجين)
//           Positioned(
//             top: 60.h,
//             right: 0,
//             child: BiometricMeasurementButton(
//               icon: Icons.air,
//               label: 'مستوى\nالأكسجين',
//               color: const Color(0xFF00BCD4),
//               backgroundColor: const Color(0xFFE0F2F1),
//               onTap: () =>
//                   _showMeasurementDialog(context, 'مستوى الأكسجين', '%'),
//             ),
//           ),

//           // Random Blood Sugar (سكر عشوائي)
//           Positioned(
//             top: 180.h,
//             right: 0,
//             child: BiometricMeasurementButton(
//               icon: Icons.bloodtype,
//               label: 'سكر\nعشوائي',
//               color: const Color(0xFFFF5722),
//               backgroundColor: const Color(0xFFFBE9E7),
//               onTap: () =>
//                   _showMeasurementDialog(context, 'سكر الدم العشوائي', 'mg/dL'),
//             ),
//           ),

//           // Fasting Blood Sugar (سكر صائم)
//           Positioned(
//             top: 300.h,
//             right: 0,
//             child: BiometricMeasurementButton(
//               icon: Icons.science,
//               label: 'سكر صائم',
//               color: const Color(0xFF795548),
//               backgroundColor: const Color(0xFFEFEBE9),
//               onTap: () =>
//                   _showMeasurementDialog(context, 'سكر الدم الصائم', 'mg/dL'),
//             ),
//           ),

//           // Height (الطول)
//           Positioned(
//             bottom: 10.h,
//             right: 0,
//             child: BiometricMeasurementButton(
//               icon: Icons.height,
//               label: 'الطول',
//               color: const Color(0xFF4CAF50),
//               backgroundColor: const Color(0xFFE8F5E8),
//               onTap: () => _showMeasurementDialog(context, 'الطول', 'cm'),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   void _showMeasurementDialog(
//       BuildContext context, String measurement, String unit) {
//     showDialog(
//       context: context,
//       builder: (context) => BiometricInputDialog(
//         measurement: measurement,
//         unit: unit,
//       ),
//     );
//   }
// }
