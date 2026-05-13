import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/app_toasts.dart' as toasts;
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/home_tab/Presentation/views/medicines_combitability_reesults_view.dart';
import 'package:we_care/features/home_tab/Presentation/views/medicines_compatibility/logic/medicines_compatibility_cubit.dart';
import 'package:we_care/features/home_tab/Presentation/views/medicines_compatibility/logic/medicines_compatibility_state.dart';

class SimulatedMedicinesCombitabilityLoader extends StatefulWidget {
  const SimulatedMedicinesCombitabilityLoader({super.key});

  @override
  State<SimulatedMedicinesCombitabilityLoader> createState() =>
      _SimulatedMedicinesCombitabilityLoaderState();
}

class _SimulatedMedicinesCombitabilityLoaderState
    extends State<SimulatedMedicinesCombitabilityLoader> {
  final List<String> _modules = [
    "البيانات الديموغرافية الأساسية",
    "الأدوية الحالية",
    "الأدوية المنتهية خلال الثلاث أشهر الماضية",
    "القياسات الحيوية",
    "التحاليل الطبية",
    "العمليات الجراحية",
    "الأمراض المزمنة",
    "الشكاوى المرضية",
    "الأمراض الوراثية المتوقعة",
    "الحساسية",
    "التطعيمات",
    "الصحة النفسية والقياس السلوكي",
    "العيون",
    "الأسنان والفكين",
    "النظام الغذائي",
    "الفيتامينات والمكملات الغذائية",
    "النشاط الرياضي",
  ];
  int _currentIndex = -1;
  Timer? _timer;
  bool _isAnimationFinished = false;
  bool _isNavigating = false;

  @override
  void initState() {
    super.initState();
    _startAnimation();
  }

  void _startAnimation() {
    _timer = Timer.periodic(
      const Duration(milliseconds: 450),
      (timer) {
        if (!mounted) {
          timer.cancel();
          return;
        }
        if (_currentIndex < _modules.length - 1) {
          setState(() {
            _currentIndex++;
          });
        } else {
          timer.cancel();
          setState(() {
            _isAnimationFinished = true;
          });
          _checkStatusAndNavigate();
        }
      },
    );
  }

  void _checkStatusAndNavigate() {
    if (!mounted || _isNavigating) return;
    final cubit = context.read<MedicinesCompatibilityCubit>();
    final state = cubit.state;
    if (_isAnimationFinished && state.analysisStatus == RequestStatus.success) {
      _isNavigating = true;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: cubit,
            child: const MedicinesCombitabilityReesultsView(),
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<MedicinesCompatibilityCubit,
        MedicinesCompatibilityState>(
      listenWhen: (previous, current) =>
          previous.analysisStatus != current.analysisStatus,
      listener: (context, state) {
        if (!mounted) return;
        if (state.analysisStatus == RequestStatus.success &&
            _isAnimationFinished) {
          _checkStatusAndNavigate();
        } else if (state.analysisStatus == RequestStatus.failure) {
          _timer?.cancel();
          if (!_isNavigating) {
            _isNavigating = true;
            Navigator.pop(context);
            toasts.showError(state.message);
          }
        }
      },
      child: Scaffold(
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

                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.h),
                        child: Row(
                          children: [
                            _buildIcon(isCompleted),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Text(
                                _modules[index],
                                style:
                                    AppTextStyles.font16BlackSemiBold.copyWith(
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
      ),
    );
  }

  Widget _buildIcon(bool isCompleted) {
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
