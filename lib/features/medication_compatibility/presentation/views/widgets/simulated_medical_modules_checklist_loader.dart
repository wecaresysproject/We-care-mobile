import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/medication_compatibility/presentation/views/medication_compatibility_result_view.dart';
import 'package:we_care/features/medicine/medicines_data_entry/logic/cubit/medicines_data_entry_cubit.dart';

class SimulatedMedicalModulesChecklistLoader extends StatefulWidget {
  const SimulatedMedicalModulesChecklistLoader({super.key});

  @override
  State<SimulatedMedicalModulesChecklistLoader> createState() =>
      _SimulatedMedicalModulesChecklistLoaderState();
}

class _SimulatedMedicalModulesChecklistLoaderState
    extends State<SimulatedMedicalModulesChecklistLoader> {
  final List<String> _modules = [
    "البيانات الأساسية",
    "العلامات الحيوية",
    "الأدوية",
    "الأمراض المزمنة",
    "الشكاوى",
    "التوصيات الطبية",
    "الفحوصات الطبية",
    "الأشعة",
    "العمليات الجراحية",
    "الأمراض الوراثية",
    "الحساسية",
    "العيون",
    "الأسنان",
    "الأمراض النفسية",
    "متابعة التغذية",
    "النشاط البدني",
    "المكملات الغذائية",
  ];

  int _currentIndex = -1;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startAnimation();
  }

  void _startAnimation() {
    _timer = Timer.periodic(
      const Duration(milliseconds: 350),
      (timer) {
        if (_currentIndex < _modules.length - 1) {
          setState(() {
            _currentIndex++;
          });
        } else {
          _timer?.cancel();
          final cubit = context.read<MedicinesDataEntryCubit>();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => BlocProvider.value(
                value: cubit,
                child: const MedicationCompatibilityResultView(),
              ),
            ),
          );
        }
      },
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(toolbarHeight: 0.h),
      body: Stack(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Opacity(
              opacity: 0.1,
              child: Image.asset(
                "assets/images/skeleton_image.png",
                width: 300.w,
                fit: BoxFit.contain,
              ),
            ),
          ),
          Column(
            children: [
              Text(
                "جاري تجهيز ملفك الطبي",
                style: AppTextStyles.font20blackWeight600.copyWith(
                  color: AppColorsManager.mainDarkBlue,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                "يتم الآن تحميل بياناتك الطبية وتحليلها",
                style: AppTextStyles.font14blackWeight400.copyWith(
                  color: AppColorsManager.placeHolderColor,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              Expanded(
                child: ListView.builder(
                  itemCount: _modules.length,
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  itemBuilder: (context, index) {
                    bool isCompleted = index <= _currentIndex;
                    bool isProcessing = index == _currentIndex;

                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.h),
                      child: Row(
                        children: [
                          _buildIcon(isCompleted, isProcessing),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              _modules[index],
                              style: AppTextStyles.font16BlackSemiBold.copyWith(
                                color: isCompleted
                                    ? AppColorsManager.textColor
                                    : AppColorsManager.placeHolderColor,
                                fontWeight: isCompleted
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildIcon(bool isCompleted, bool isProcessing) {
    if (isCompleted) {
      return const Icon(
        Icons.check_circle,
        color: AppColorsManager.doneColor,
        size: 24,
      );
    }

    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: AppColorsManager.placeHolderColor.withOpacity(0.5),
          width: 2,
        ),
      ),
    );
  }
}
