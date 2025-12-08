import 'package:flutter/material.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/routing/app_router.dart';
import 'package:we_care/core/routing/routes.dart';
import 'package:we_care/features/nutration/nutration_data_entry/Presentation/views/widgets/meal_card_widget.dart';

class SupplementsGridView extends StatelessWidget {
  final int itemCount;

  const SupplementsGridView({
    super.key,
    required this.itemCount,
  });

  @override
  Widget build(BuildContext context) {
    // Generate mock days based on itemCount
    final List<Map<String, dynamic>> days = List.generate(itemCount, (index) {
      final date = DateTime.now().add(Duration(days: index));
      return {
        'day': _getDayName(date.weekday),
        'date': '${date.day}/${date.month}/${date.year}',
        'hasReport': index % 3 == 0, // Mock: every 3rd day has a report
      };
    });

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1,
      ),
      itemCount: days.length,
      itemBuilder: (context, index) {
        final dayData = days[index];
        final bool hasReport = dayData['hasReport'];

        if (hasReport) {
          return MealCard.planActivatedandHaveDocument(
            day: dayData['day'],
            date: dayData['date'],
            dietPlan: "mock_plan", // Mock plan ID
            showDietPlan: false,
            dialogTitle: "هل تريد مراجعة تقرير الفايتمينات الخاص باليوم؟",
            onTap: () {},
            onViewReport: (date) {
              context.pushNamed(Routes.supplementsReportTableView,
                  arguments: date);
            },
            onDelete: (date) {
              // Handle delete
            },
          );
        } else {
          return MealCard.planActivatedandHaveNoDocument(
            day: dayData['day'],
            date: dayData['date'],
            showDietPlan: false,
            dialogTitle: "هل تريد مراجعة تقرير الفايتمينات الخاص باليوم؟",
            onTap: () {},
            onViewReport: (date) {
              context.pushNamed(Routes.supplementsReportTableView,
                  arguments: date);
            },
            onDateSelected: (date) {
              // Handle date selection
            },
          );
        }
      },
    );
  }

  String _getDayName(int weekday) {
    switch (weekday) {
      case 1:
        return 'الاثنين';
      case 2:
        return 'الثلاثاء';
      case 3:
        return 'الأربعاء';
      case 4:
        return 'الخميس';
      case 5:
        return 'الجمعة';
      case 6:
        return 'السبت';
      case 7:
        return 'الأحد';
      default:
        return '';
    }
  }
}
