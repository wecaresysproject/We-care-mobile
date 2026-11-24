import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart' show NumberFormat;
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/features/doctor/statistics/data/models/doctor_statistics_model.dart';
import 'package:we_care/features/doctor/statistics/logic/doctor_statistics_cubit.dart';
import 'package:we_care/features/doctor/statistics/presentation/views/widgets/statistics_card_widget.dart';
import 'package:we_care/features/doctor/statistics/presentation/views/widgets/statistics_filter_widgets.dart';

const statisticsNavy = Color(0xFF0E2A5E);
const statisticsBackground = Color(0xFFF3F8FE);

/// "إحصائيات" — from the doctor home's quick actions. The doctor picks a
/// month and a year, taps "عرض", and sees that month's numbers. Opens on
/// the current month. Expects a [DoctorStatisticsCubit] above it that is
/// already loading (see `AppRouter`).
class DoctorStatisticsView extends StatelessWidget {
  const DoctorStatisticsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: statisticsBackground,
      body: SafeArea(
        child: BlocBuilder<DoctorStatisticsCubit, DoctorStatisticsState>(
          builder: (context, state) {
            final statistics = state.statistics;
            final isLoading = state.status == RequestStatus.loading;
            return Column(
              children: [
                const _Header(),
                Padding(
                  padding: EdgeInsets.fromLTRB(16.w, 4.h, 16.w, 12.h),
                  child: StatisticsFiltersRow(state: state),
                ),
                if (isLoading && statistics != null)
                  const LinearProgressIndicator(minHeight: 2),
                Expanded(
                  child: switch (state.status) {
                    _ when statistics != null =>
                      _StatisticsGrid(statistics: statistics),
                    RequestStatus.failure => _LoadError(
                        message: state.message,
                        onRetry: context.read<DoctorStatisticsCubit>().load,
                      ),
                    _ => const Center(child: CircularProgressIndicator()),
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56.h,
      width: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Text(
            "إحصائيات",
            style: AppTextStyles.font20blackWeight700.copyWith(
              fontSize: 22.sp,
              color: statisticsNavy,
            ),
          ),
          // Back on the left, like the design — not mirrored for Arabic.
          Positioned(
            left: 8.w,
            child: Directionality(
              // Keeps the arrow pointing left.
              textDirection: TextDirection.ltr,
              child: IconButton(
                tooltip: "رجوع",
                onPressed: () => Navigator.of(context).pop(),
                icon: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: 22.r,
                  color: statisticsNavy,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatisticsGrid extends StatelessWidget {
  const _StatisticsGrid({required this.statistics});

  final DoctorStatisticsModel statistics;

  static final _count = NumberFormat('#,##0', 'en');
  static final _decimal = NumberFormat('#,##0.#', 'en');

  static String _percent(num value) => "${_decimal.format(value)}%";

  @override
  Widget build(BuildContext context) {
    final s = statistics;
    Widget pair(Widget start, Widget end) => IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(child: start),
              horizontalSpacing(12),
              Expanded(child: end),
            ],
          ),
        );

    final rows = <Widget>[
      pair(
        StatisticsCardWidget(
          icon: 'consultation_value',
          title: "قيمة الكشوفات",
          value: _count.format(s.consultationsValue),
          unit: s.currency,
        ),
        StatisticsCardWidget(
          icon: 'total_bookings',
          title: "عدد الحجوزات الاجمالية",
          value: _count.format(s.totalBookings),
        ),
      ),
      pair(
        StatisticsCardWidget(
          icon: 'paid_consultations',
          title: "عدد الكشوفات المدفوعة",
          value: _count.format(s.paidConsultations),
        ),
        StatisticsCardWidget(
          icon: 'follow_ups',
          title: "عدد المتابعات",
          value: _count.format(s.followUps),
        ),
      ),
      StatisticsCardWidget(
        icon: 'followup_ratio',
        title: "نسبة المتابعات للكشوفات",
        value: _percent(s.followUpRatio),
        isWide: true,
      ),
      pair(
        StatisticsCardWidget(
          icon: 'repeat_patients',
          title: "عدد المرضى المكررين بدون المتابعات",
          value: _count.format(s.repeatPatientsWithoutFollowUp),
        ),
        StatisticsCardWidget(
          icon: 'repeat_patient_ratio',
          title: "نسبة المرضى المكررين لإجمالي المرضى",
          value: _percent(s.repeatPatientRatio),
        ),
      ),
      pair(
        StatisticsCardWidget(
          icon: 'consultation_days',
          title: "عدد أيام الكشوفات",
          value: _count.format(s.consultationDays),
        ),
        StatisticsCardWidget(
          icon: 'consultation_hours',
          title: "عدد ساعات الكشوفات",
          value: _decimal.format(s.consultationHours),
          unit: "ساعة",
        ),
      ),
      StatisticsCardWidget(
        icon: 'average_consultation_duration',
        title: "متوسط مدة الكشف",
        value: _decimal.format(s.averageConsultationMinutes),
        unit: "min",
        isWide: true,
      ),
      StatisticsCardWidget(
        icon: 'waiting_patients',
        title: "عدد مرضى الانتظار الذين لم يتم الكشف عليهم",
        value: _count.format(s.unexaminedWaitingPatients),
        isWide: true,
      ),
    ];

    return RefreshIndicator(
      onRefresh: context.read<DoctorStatisticsCubit>().load,
      child: ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 24.h),
        itemCount: rows.length,
        separatorBuilder: (_, __) => verticalSpacing(12),
        itemBuilder: (_, index) => rows[index],
      ),
    );
  }
}

class _LoadError extends StatelessWidget {
  const _LoadError({required this.message, required this.onRetry});

  final String? message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message ?? "تعذر تحميل الإحصائيات",
              textAlign: TextAlign.center,
              style: AppTextStyles.font16BlackSemiBold.copyWith(
                color: statisticsNavy,
              ),
            ),
            verticalSpacing(8),
            TextButton(
              onPressed: onRetry,
              child: const Text("إعادة المحاولة"),
            ),
          ],
        ),
      ),
    );
  }
}
