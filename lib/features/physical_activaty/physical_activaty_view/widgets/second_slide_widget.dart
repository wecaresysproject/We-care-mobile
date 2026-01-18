import 'package:flutter/material.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/features/physical_activaty/data/models/physical_activity_metrics_model.dart';
import 'package:we_care/features/physical_activaty/physical_activaty_view/widgets/physical_activity_view_body_widget.dart';

class SecondSlideWidget extends StatelessWidget {
  const SecondSlideWidget({
    super.key,
    required this.slide,
  });

  final Slide slide;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        verticalSpacing(12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            /// البناء العضلي
            Column(
              children: [
                Text(
                  'البناء العضلي',
                  style: AppTextStyles.font22WhiteWeight600,
                ),
                verticalSpacing(6),
                Row(
                  children: [
                    Column(
                      children: [
                        Text(
                          '${slide.muscularGoalsBuilding?.target?.toStringAsFixed(1) ?? '0'}%',
                          style: AppTextStyles.font22WhiteWeight600,
                        ),
                        verticalSpacing(4),
                        Text(
                          'معياري',
                          style: AppTextStyles.font22WhiteWeight600,
                        ),
                      ],
                    ),
                    horizontalSpacing(12),
                    Column(
                      children: [
                        Text(
                          '${slide.muscularGoalsBuilding?.actual?.toStringAsFixed(1) ?? '0'}%',
                          style: AppTextStyles.font22WhiteWeight600.copyWith(
                            color: Colors.cyanAccent,
                          ),
                        ),
                        verticalSpacing(4),
                        Text(
                          'فعلي',
                          style: AppTextStyles.font22WhiteWeight600,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),

            /// الصيانة العضلية
            Column(
              children: [
                Text(
                  'الصيانة العضلية',
                  style: AppTextStyles.font22WhiteWeight600,
                ),
                verticalSpacing(6),
                Row(
                  children: [
                    Column(
                      children: [
                        Text(
                          '${slide.muscularGoalsMaintenance?.target?.toStringAsFixed(1) ?? '0'}%',
                          style: AppTextStyles.font22WhiteWeight600,
                        ),
                        verticalSpacing(4),
                        Text(
                          'معياري',
                          style: AppTextStyles.font22WhiteWeight600,
                        ),
                      ],
                    ),
                    horizontalSpacing(12),
                    Column(
                      children: [
                        Text(
                          '${slide.muscularGoalsMaintenance?.actual?.toStringAsFixed(1) ?? '0'}%',
                          style: AppTextStyles.font22WhiteWeight600.copyWith(
                            color: Colors.cyanAccent,
                          ),
                        ),
                        verticalSpacing(4),
                        Text(
                          'فعلي',
                          style: AppTextStyles.font22WhiteWeight600,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        verticalSpacing(24),
        // Display metrics for this slide
        ...slide.metrics.asMap().entries.map(
          (entry) {
            final slide = entry.value;
            return Column(
              children: [
                SectionTitle(
                  title: entry.value.metricName,
                  hasGradientBackground: true,
                ),
                verticalSpacing(8),
                MetricRow3(
                  todayValue: slide.todayActual?.toInt().toString() ?? '0',
                  cumulativeValue:
                      slide.accumulativeActual?.toInt().toString() ?? '0',
                  standardValue:
                      '(${slide.minimumStandard?.toInt() ?? 0}) → (${slide.maximumStandard?.toInt() ?? 0})',
                  //  slide.standardTarget?.toInt().toString() ?? '0',
                  subtitle: '',
                  hasGradientBackground: true,
                ),
                verticalSpacing(8),
              ],
            );
          },
        ),
      ],
    );
  }
}
