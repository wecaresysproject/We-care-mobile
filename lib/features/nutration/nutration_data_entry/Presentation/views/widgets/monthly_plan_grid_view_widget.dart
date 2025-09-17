// Monthly Meal Grid (30 days)
import 'package:flutter/material.dart';
import 'package:we_care/features/nutration/nutration_data_entry/Presentation/views/widgets/meal_card_widget.dart';

class MonthlyMealGrid extends StatefulWidget {
  const MonthlyMealGrid({super.key});

  @override
  State<MonthlyMealGrid> createState() => _MonthlyMealGridState();
}

class _MonthlyMealGridState extends State<MonthlyMealGrid> {
  final Map<String, String> dayToDate = {
    'السبت': '5/7/2025',
    'الأحد': '6/7/2025',
    'الاثنين': '7/7/2025',
    'الثلاثاء': '8/7/2025',
    'الأربعاء': '9/7/2025',
    'الخميس': '10/7/2025',
    'الجمعة': '11/7/2025',
  };
  String? selectedDay;

  @override
  Widget build(BuildContext context) {
    final days = dayToDate.keys.toList();

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1,
      ),
      itemCount: 4,
      itemBuilder: (context, index) {
        final day = days[index];
        final date = dayToDate[day] ?? '--/--/----';
        final bool isSelected = selectedDay == day; // متعلم ولا لأ

        return MealCard(
          day: day,
          date: date,
          onTap: () {
            setState(() {
              selectedDay = day;
            });
          },
          backgroundColor:
              isSelected ? Color(0xffDAE9FA) : const Color(0xffF1F3F6),
          haveAdocument: index % 2 == 0, // Some cards have documents
        );
      },
    );
  }
}
