import 'package:flutter/material.dart';
import 'package:we_care/features/x_ray/x_ray_view/Presentation/views/widgets/x_ray_data_filters_row.dart';

class QualityOfLifeFiltersRow extends StatelessWidget {
  const QualityOfLifeFiltersRow({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy dates for demonstration
    final List<String> dummyDates = [
      "من 18/12/2025 إلى 16/01/2026",
      "من 01/11/2025 إلى 30/11/2025",
      "من 01/10/2025 إلى 31/10/2025",
      "من 01/09/2025 إلى 30/09/2025",
      "من 01/08/2025 إلى 31/08/2025",
      "من 01/07/2025 إلى 31/07/2025",
      "من 01/06/2025 إلى 30/06/2025",
    ];

    return DataViewFiltersRow(
      onApply: (selectedFilters) {
        // Placeholder for filtering logic
      },
      filters: [
        FilterConfig(
          title: 'التاريخ',
          options: dummyDates,
          isYearFilter: false,
        ),
      ],
    );
  }
}
