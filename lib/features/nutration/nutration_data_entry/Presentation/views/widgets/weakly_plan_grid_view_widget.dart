// Weekly Meal Grid (7 days)
import 'package:flutter/material.dart';
import 'package:we_care/features/nutration/nutration_data_entry/Presentation/views/widgets/meal_card_widget.dart';

class WeeklyMealGrid extends StatelessWidget {
  WeeklyMealGrid({super.key});

  final List<String> days = [
    'السبت',
    'الأحد',
    'الاثنين',
    'الثلاثاء',
    'الأربعاء',
    'الخميس',
    'الجمعة'
  ];

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1,
        ),
        itemCount: 7,
        itemBuilder: (context, index) {
          return MealCard(
            day: days[index],
            isEmpty: true,
            haveAdocument: index % 3 == 0, // Some cards have documents
          );
        },
      ),
    );
  }
}
