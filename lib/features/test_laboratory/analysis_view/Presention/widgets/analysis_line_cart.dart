import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';

class AnalysisData {
  final int x;
  final double y;
  final String label;

  AnalysisData({required this.x, required this.y, required this.label});
}

class AnalysisLineChart extends StatelessWidget {
  final List<AnalysisData> data;
  final String title;
  final double normalMin;
  final double normalMax;
  const AnalysisLineChart({
    Key? key,
    required this.data,
    required this.title,
    required this.normalMin,
    required this.normalMax,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final sortedData = data..sort((a, b) => a.x.compareTo(b.x));
    final double minY = data.map((d) => d.y).reduce((a, b) => a < b ? a : b);
    final double maxY = data.map((d) => d.y).reduce((a, b) => a > b ? a : b);

    final double yAxisPadding = 10;
    final double dynamicMinY = (minY - yAxisPadding).clamp(0, double.infinity);
    final double dynamicMaxY = maxY + yAxisPadding;

    final yRange = dynamicMaxY - dynamicMinY;
    final targetStepCount = data.length;
    final rawInterval = yRange / targetStepCount;
    final niceInterval = rawInterval <= 10
        ? 5
        : rawInterval <= 20
            ? 10
            : rawInterval <= 50
                ? 20
                : 50;

    final spots = sortedData.map((d) => FlSpot(d.x.toDouble(), d.y)).toList();

    return Column(
      children: [
        Row(
          children: [
            Icon(Icons.remove_red_eye, color: Colors.blue.shade900),
            horizontalSpacing(8),
            Text(
              title,
              style: AppTextStyles.font16DarkGreyWeight400.copyWith(
                color: AppColorsManager.mainDarkBlue,
              ),
            ),
          ],
        ),
        verticalSpacing(16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: const LinearGradient(
              colors: [Color(0xFFECF5FF), Color(0xFFFBFDFF)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width - 24.w,
                height: MediaQuery.of(context).size.height * 0.3,
                child: LineChart(
                  LineChartData(
                    minX: sortedData.first.x.toDouble(),
                    maxX: sortedData.last.x.toDouble(),
                    minY: dynamicMinY,
                    maxY: dynamicMaxY,
                    backgroundColor: Colors.transparent,
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: true,
                      drawHorizontalLine: true,
                      getDrawingHorizontalLine: (value) => FlLine(
                        color: Colors.grey.withOpacity(0.3),
                        strokeWidth: 1,
                      ),
                      getDrawingVerticalLine: (value) => FlLine(
                        color: Colors.grey.withOpacity(0.3),
                        strokeWidth: 1,
                      ),
                    ),
                    borderData: FlBorderData(show: false),
                    titlesData: FlTitlesData(
                      show: true,
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 35,
                          maxIncluded: false,
                          interval: niceInterval.toDouble(),
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 60, // more space for vertical labels
                            getTitlesWidget: (value, meta) {
                              final matchedData = sortedData.firstWhere(
                                (d) => d.x.toDouble() == value,
                                orElse: () =>
                                    AnalysisData(x: 0, y: 0, label: ''),
                              );

                              if (matchedData.label.isNotEmpty) {
                                int spacingFactor = data.length > 8 ? 2 : 1;
                                if (matchedData.x % spacingFactor != 0) {
                                  return const SizedBox.shrink();
                                }

                                final verticalDate =
                                    matchedData.label.split('/').join('\n');

                                return Padding(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: Text(
                                    verticalDate,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(fontSize: 10),
                                  ),
                                );
                              }

                              return const SizedBox.shrink();
                            }),
                      ),
                      rightTitles:
                          AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      topTitles:
                          AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    ),
                    lineTouchData: LineTouchData(
                      enabled: false,
                      getTouchedSpotIndicator: (_, indicators) {
                        return indicators.map((index) {
                          return TouchedSpotIndicatorData(
                            FlLine(color: Colors.transparent),
                            FlDotData(show: false),
                          );
                        }).toList();
                      },
                      touchTooltipData: LineTouchTooltipData(
                        // tooltipPadding: EdgeInsets.zero,
                        getTooltipColor: (touchedSpot) => Colors.transparent,
                        tooltipMargin: 8,
                        getTooltipItems: (spots) => spots.map((spot) {
                          return LineTooltipItem(
                            '${spot.y.toStringAsFixed(0)}',
                            const TextStyle(
                              color: Colors.brown,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    showingTooltipIndicators: spots
                        .map((spot) => ShowingTooltipIndicators([
                              LineBarSpot(
                                LineChartBarData(spots: spots),
                                0,
                                spot,
                              ),
                            ]))
                        .toList(),
                    lineBarsData: [
                      LineChartBarData(
                        spots: spots,
                        isCurved: true,
                        barWidth: 1,
                        color: Colors.blue.shade900,
                        dotData: FlDotData(show: true),
                        belowBarData: BarAreaData(
                          show: false,
                          color: Colors.blue.shade900.withOpacity(0.1),
                        ),
                      ),
                      LineChartBarData(
                        spots: sortedData
                            .map((d) => FlSpot(d.x.toDouble(), normalMin))
                            .toList(),
                        isCurved: false,
                        color: Colors.transparent,
                        barWidth: 0,
                      ),
                      LineChartBarData(
                        spots: sortedData
                            .map((d) => FlSpot(d.x.toDouble(), normalMax))
                            .toList(),
                        isCurved: false,
                        color: Colors.transparent,
                        barWidth: 0,
                      ),
                    ],
                    betweenBarsData: [
                      BetweenBarsData(
                        fromIndex: 1,
                        toIndex: 2,
                        color: AppColorsManager.mainDarkBlue.withOpacity(0.15),
                      ),
                    ],
                  ),
                ),
              ),
              const Text(
                "المعيار",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
