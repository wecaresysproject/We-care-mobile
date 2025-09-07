// Monthly Meal Grid (30 days)
import 'package:flutter/material.dart';
import 'package:we_care/features/nutration/nutration_data_entry/Presentation/views/widgets/meal_card_widget.dart';

class MonthlyMealGrid extends StatelessWidget {
  MonthlyMealGrid({super.key});

  final List<String> weeks = [
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
        itemCount: 4,
        itemBuilder: (context, index) {
          return MealCard(
            day: weeks[index],
            isEmpty: true,
            haveAdocument: index % 2 == 0, // Some cards have documents
          );
        },
      ),
    );
  }
}
