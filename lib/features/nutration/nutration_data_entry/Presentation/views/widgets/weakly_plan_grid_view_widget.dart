import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:we_care/core/global/Helpers/app_dialogs.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/features/nutration/nutration_data_entry/Presentation/views/widgets/meal_card_widget.dart';
import 'package:we_care/features/nutration/nutration_data_entry/logic/cubit/nutration_data_entry_cubit.dart';

class WeeklyMealGridBLocBuilder extends StatefulWidget {
  const WeeklyMealGridBLocBuilder({super.key});

  @override
  State<WeeklyMealGridBLocBuilder> createState() =>
      _WeeklyMealGridBLocBuilderState();
}

class _WeeklyMealGridBLocBuilderState extends State<WeeklyMealGridBLocBuilder> {
  String? selectedDay;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NutrationDataEntryCubit, NutrationDataEntryState>(
      builder: (context, state) {
        if (state.submitNutrationDataStatus == RequestStatus.loading) {
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
              itemCount: 7,
              itemBuilder: (context, index) {
                return MealCard(
                  day: 'اليوم',
                  date: '--/--/----',
                  onTap: () {},
                );
              },
            ),
          );
        }

        final days = state.days; // دي اللي راجعة من API
        // Add debug information
        if (days.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.calendar_month, size: 48, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  state.weeklyActivationStatus
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
            if (state.weeklyActivationStatus == false) {
              // لو الخطة مش مفعلة خالص
              return MealCard.planNotActivated(
                day: day.dayOfWeek,
                date: day.date,
                onTap: () async {
                  await showWarningDialog(
                    context,
                    message: 'يجب تفعيل الخطة أولاً',
                  );
                  return;
                },
                backgroundColor: isSelected
                    ? const Color(0xffDAE9FA)
                    : const Color(0xffF1F3F6),
              );
            } else if (state.weeklyActivationStatus && day.hasDocument) {
              // لو اليوم له تقرير
              return MealCard.planActivatedandHaveDocument(
                day: day.dayOfWeek,
                date: day.date,
                onTap: () {},
              );
            } else {
              // لو اليوم مفعل بس مفيش تقرير
              return MealCard.planActivatedandHaveNoDocument(
                day: day.dayOfWeek,
                date: day.date,
                onTap: () {
                  setState(() {
                    selectedDay = day.date;
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
