import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_care/core/global/Helpers/app_dialogs.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/features/nutration/nutration_data_entry/Presentation/views/widgets/meal_card_widget.dart';
import 'package:we_care/features/nutration/nutration_data_entry/logic/cubit/nutration_data_entry_cubit.dart';

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
    return BlocBuilder<NutrationDataEntryCubit, NutrationDataEntryState>(
      builder: (context, state) {
        if (state.submitNutrationDataStatus == RequestStatus.loading) {
          return const Center(child: CircularProgressIndicator());
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
              return MealCard.planNotActivated(
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
              return MealCard.planActivatedandHaveDocument(
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
