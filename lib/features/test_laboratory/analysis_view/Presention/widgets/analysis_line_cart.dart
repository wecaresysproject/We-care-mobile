import 'dart:math';

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
    final double minY = 0; // Force starting from 0
    final double maxY = data.map((d) => d.y).reduce((a, b) => a > b ? a : b);

    // Calculate y-axis padding (10% of range or fixed value for very small ranges)
    final double yAxisPadding = max((maxY - minY) * 0.1, 0.5);
    final double dynamicMaxY = maxY + yAxisPadding;

    // Calculate optimal integer interval
    final double yRange = dynamicMaxY - minY;
    final double rawInterval = yRange / 5; // Aim for about 5 labels
    final int niceInterval = _calculateNiceInterval(rawInterval);

    // Adjust max to align with nice intervals
    final int alignedMaxY = (dynamicMaxY / niceInterval).ceil() * niceInterval;

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
                    minY: 0,
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
                    borderData: FlBorderData(
                      show: true,
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.grey,
                          width: 1.5,
                        ),
                        left: BorderSide(
                          color: Colors.grey,
                          width: 1.5,
                        ),
                        right: BorderSide.none,
                        top: BorderSide.none,
                      ),
                    ),
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
                            interval: 1,
                            reservedSize: 65, // more space for vertical labels
                            getTitlesWidget: (value, meta) {
                              final matchedData = sortedData.firstWhere(
                                (d) => d.x.toDouble() == value,
                                orElse: () =>
                                    AnalysisData(x: 0, y: 0, label: ''),
                              );

                              return Transform.rotate(
                                angle: -90 * (pi / 180), 
                                origin: const Offset(18, -10),

                                child: Text(
                                  matchedData.label,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(fontSize: 11),
                                ),
                              );
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
                            FlDotData(show: true),
                          );
                        }).toList();
                      },
                      touchTooltipData: LineTouchTooltipData(
                        // tooltipPadding: EdgeInsets.zero,
                        getTooltipColor: (touchedSpot) => Colors.transparent,
                        tooltipMargin: 8,
                        getTooltipItems: (spots) => spots.map((spot) {
                          return LineTooltipItem(
                              spot.y == spot.y.truncate() ? spot.y.toInt().toString() : spot.y.toString(),

                            const TextStyle(
                              color: Colors.brown,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
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
              Padding(
                padding: const EdgeInsets.only(top:16),
                child: const Text(
                  "المعيار",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

int _calculateNiceInterval(double rawInterval) {
  if (rawInterval <= 0) return 1;

  // Calculate magnitude (power of 10)
  final double magnitude =
      pow(10, (log(rawInterval) / ln10).floor()).toDouble();
  final double normalized = rawInterval / magnitude;

  // Find the nearest "nice" number (1, 2, 5, 10)
  if (normalized <= 2) return 1 * magnitude.toInt();
  if (normalized <= 5) return 2 * magnitude.toInt();
  if (normalized <= 10) return 5 * magnitude.toInt();
  return 10 * magnitude.toInt();
}
