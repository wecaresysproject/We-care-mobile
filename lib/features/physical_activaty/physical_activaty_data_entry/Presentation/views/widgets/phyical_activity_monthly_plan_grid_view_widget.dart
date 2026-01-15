import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:we_care/core/global/Helpers/app_dialogs.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/routing/routes.dart';
import 'package:we_care/features/physical_activaty/physical_activaty_data_entry/Presentation/views/widgets/day_card_widget.dart';
import 'package:we_care/features/physical_activaty/physical_activaty_data_entry/logic/cubit/physical_activaty_data_entry_cubit.dart';

class MonthlyMealGridBlocBuilder extends StatefulWidget {
  const MonthlyMealGridBlocBuilder({super.key});

  @override
  State<MonthlyMealGridBlocBuilder> createState() =>
      _MonthlyMealGridBlocBuilderState();
}

class _MonthlyMealGridBlocBuilderState
    extends State<MonthlyMealGridBlocBuilder> {
  String? selectedDay;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PhysicalActivatyDataEntryCubit,
        PhysicalActivatyDataEntryState>(
      builder: (context, state) {
        final cubit = context.read<PhysicalActivatyDataEntryCubit>();
        if (state.submitPhysicalActivityDataStatus == RequestStatus.loading) {
          return Skeletonizer(
            enabled: true,
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1,
              ),
              itemCount: 15,
              itemBuilder: (context, index) {
                return DayCardWidget(
                  day: 'اليوم',
                  date: '--/--/----',
                  onTap: () {},
                );
              },
            ),
          );
        }

        final days = state.days; // البيانات الراجعة من API

        // Add debug information
        if (days.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.calendar_month, size: 48, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  state.monthlyActivationStatus
                      ? 'لا توجد أيام متاحة في الخطة'
                      : 'يجب تفعيل الخطة أولاً',
                  style: TextStyle(color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        return GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1,
          ),
          itemCount: days.length,
          itemBuilder: (context, index) {
            final day = days[index];
            final isSelected = selectedDay == day.date;

            // اختر الـ constructor المناسب
            if (state.monthlyActivationStatus == false) {
              // لو الخطة مش مفعلة خالص
              return DayCardWidget.planNotActivated(
                day: day.dayOfWeek,
                date: day.date,
                onTap: () async {
                  await showWarningDialog(
                    context,
                    message: 'يجب تفعيل الخطة أولاً',
                  );
                },
                backgroundColor: isSelected
                    ? const Color(0xffDAE9FA)
                    : const Color(0xffF1F3F6),
              );
            } else if (state.monthlyActivationStatus && day.hasDocument) {
              // لو اليوم له تقرير
              return DayCardWidget.planActivatedandHaveDocument(
                day: day.dayOfWeek,
                date: day.date,
                onTap: () async {
                  setState(() {
                    selectedDay = day.date;
                  });
                  await context.pushNamed(
                    Routes.dailyActivityLogger,
                    arguments: {
                      'day': day.date,
                    },
                  ).then((value) {
                    cubit.loadExistingPlans();
                  });
                },
                backgroundColor: isSelected
                    ? const Color(0xffDAE9FA)
                    : const Color(0xffF1F3F6),
              );
            } else {
              // لو اليوم مفعل بس مفيش تقرير
              return DayCardWidget.planActivatedandHaveNoDocument(
                day: day.dayOfWeek,
                date: day.date,
                onTap: () async {
                  setState(() {
                    selectedDay = day.date;
                  });
                  await context.pushNamed(
                    Routes.dailyActivityLogger,
                    arguments: {
                      'day': day.date,
                    },
                  ).then((value) {
                    cubit.loadExistingPlans();
                  });
                },
                backgroundColor: isSelected
                    ? const Color(0xffDAE9FA)
                    : const Color(0xffF1F3F6),
              );
            }
          },
        );
      },
    );
  }
}
