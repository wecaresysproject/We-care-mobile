import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/features/doctor/statistics/logic/doctor_statistics_cubit.dart';
import 'package:we_care/features/online_doctor/data/models/booking_model.dart';

const _navy = Color(0xFF0E2A5E);
const _border = Color(0xFFD6E6F7);

/// "الشهر" · "السنة" · "عرض".
class StatisticsFiltersRow extends StatelessWidget {
  const StatisticsFiltersRow({super.key, required this.state});

  final DoctorStatisticsState state;

  /// This year and the four before it, newest first.
  static List<int> _years() {
    final now = DateTime.now().year;
    return [for (var year = now; year > now - 5; year--) year];
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<DoctorStatisticsCubit>();
    final isLoading = state.status == RequestStatus.loading;
    return SizedBox(
      height: 62.h,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: _PickerBox<int>(
              label: "الشهر",
              value: state.selectedMonth,
              options: const [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12],
              optionLabel: arabicMonthName,
              onChanged: cubit.selectMonth,
            ),
          ),
          horizontalSpacing(10),
          Expanded(
            child: _PickerBox<int>(
              label: "السنة",
              value: state.selectedYear,
              options: _years(),
              optionLabel: (year) => '$year',
              onChanged: cubit.selectYear,
            ),
          ),
          horizontalSpacing(10),
          Expanded(
            child: Material(
              color: const Color(0xFFDDEBFB),
              borderRadius: BorderRadius.circular(16.r),
              child: InkWell(
                onTap: isLoading ? null : cubit.load,
                borderRadius: BorderRadius.circular(16.r),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(color: const Color(0xFFBFD9F5)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.filter_alt_rounded, size: 24.r, color: _navy),
                      horizontalSpacing(6),
                      Text(
                        "عرض",
                        style: AppTextStyles.font16BlackSemiBold.copyWith(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                          color: _navy,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// A white box with a small label on top, the picked value and a down
/// arrow; tapping opens the options.
class _PickerBox<T> extends StatelessWidget {
  const _PickerBox({
    required this.label,
    required this.value,
    required this.options,
    required this.optionLabel,
    required this.onChanged,
  });

  final String label;
  final T value;
  final List<T> options;
  final String Function(T) optionLabel;
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<T>(
      initialValue: value,
      onSelected: onChanged,
      color: Colors.white,
      constraints: BoxConstraints(maxHeight: 320.h),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      itemBuilder: (_) => [
        for (final option in options)
          PopupMenuItem(value: option, child: Text(optionLabel(option))),
      ],
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: _border),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    label,
                    style: AppTextStyles.font14blackWeight400.copyWith(
                      fontSize: 11.sp,
                      color: const Color(0xFF51637E),
                    ),
                  ),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      optionLabel(value),
                      style: AppTextStyles.font16BlackSemiBold.copyWith(
                        fontSize: 17.sp,
                        fontWeight: FontWeight.w700,
                        color: _navy,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.keyboard_arrow_down_rounded, size: 22.r, color: _navy),
          ],
        ),
      ),
    );
  }
}
