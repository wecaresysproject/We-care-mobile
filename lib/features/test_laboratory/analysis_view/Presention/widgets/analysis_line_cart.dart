import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';

class AnalysisData {
  final int x; // e.g. 1, 2, 3, ...
  final double y; // e.g. 100, 140, 180, ...
  final String label; // e.g. "الأول", "الثاني", ...

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
    // ADD: Normal Range
    required this.normalMin,
    required this.normalMax,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Sort data by x if needed:
    final sortedData = data..sort((a, b) => a.x.compareTo(b.x));

    return Column(
      children: [
        // Title row
        Row(
          children: [
            Icon(Icons.remove_red_eye, color: Colors.blue.shade900),
            horizontalSpacing(8),
            Text(
              title,
              style: AppTextStyles.font16DarkGreyWeight400
                  .copyWith(color: AppColorsManager.mainDarkBlue),
            ),
          ],
        ),
        verticalSpacing(16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            // Optional gradient background
            gradient: const LinearGradient(
              colors: [Color(0xFFECF5FF), Color(0xFFFBFDFF)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            children: [
              // Chart
              SizedBox(
                width: MediaQuery.of(context).size.width - 24.w,
                height: MediaQuery.of(context).size.height * 0.3,
                child: LineChart(
                  LineChartData(
                    minX: sortedData.first.x.toDouble(),
                    maxX: sortedData.last.x.toDouble(),
                    minY: 0, // or compute dynamically
                    maxY: 300, // or compute dynamically
                    backgroundColor: Colors.transparent,
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: true,
                      drawHorizontalLine: true,
                      getDrawingHorizontalLine: (value) {
                        return FlLine(
                          color: Colors.grey.withOpacity(0.3),
                          strokeWidth: 1,
                        );
                      },
                      getDrawingVerticalLine: (value) {
                        return FlLine(
                          color: Colors.grey.withOpacity(0.3),
                          strokeWidth: 1,
                        );
                      },
                    ),
                    borderData: FlBorderData(
                      show: false,
                    ),
                    titlesData: FlTitlesData(
                      show: true,
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 35,
                          getTitlesWidget: (value, meta) {
                            // Show some Y-axis labels if they make sense
                            if (value % 50 == 0) {
                              return Text(
                                value.toInt().toString(),
                                style: const TextStyle(fontSize: 12),
                                textAlign: TextAlign.center,
                              );
                            }
                            return const SizedBox.shrink();
                          },
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 40,
                          getTitlesWidget: (value, meta) {
                            // Find the matching label in sortedData
                            final matchedData = sortedData.firstWhere(
                              (d) => d.x.toDouble() == value,
                              orElse: () => AnalysisData(x: 0, y: 0, label: ''),
                            );
                            if (matchedData.label.isNotEmpty) {
                              return Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Text(
                                  matchedData.label,
                                  style: const TextStyle(fontSize: 12),
                                ),
                              );
                            }
                            return const SizedBox.shrink();
                          },
                        ),
                      ),
                      rightTitles:
                          AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      topTitles:
                          AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    ),
                    lineTouchData: LineTouchData(
                      enabled: false,
                    ),
                    lineBarsData: [
                      // Main curved line
                      LineChartBarData(
                        spots: data
                            .map((d) => FlSpot(d.x.toDouble(), d.y))
                            .toList(),
                        isCurved: true,
                        barWidth: 1, // line thickness
                        color: Colors.blue.shade900,
                        dotData: FlDotData(
                          show: true,
                        ),
                        belowBarData: BarAreaData(
                          show: false,
                          color: Colors.blue.shade900.withOpacity(0.1),
                        ),
                      ),
                      // Invisible lower bound line for normal range
                      LineChartBarData(
                        spots: sortedData
                            .map((d) => FlSpot(d.x.toDouble(), normalMin))
                            .toList(),
                        isCurved: false,
                        color: Colors.transparent,
                        barWidth: 0,
                      ),
                      // Invisible upper bound line for normal range
                      LineChartBarData(
                        spots: sortedData
                            .map((d) => FlSpot(d.x.toDouble(), normalMax))
                            .toList(),
                        isCurved: false,
                        color: Colors.transparent,
                        barWidth: 0,
                      ),
                    ],
                    // Fill the area between the two invisible lines with a color
                    betweenBarsData: [
                      BetweenBarsData(
                        fromIndex: 1, // index of the lower bound line
                        toIndex: 2, // index of the upper bound line
                        color: AppColorsManager.mainDarkBlue.withOpacity(0.15),
                      ),
                    ],
                  ),
                ),
              ),
              // Optional X-axis label, e.g. "المعيار"
              Text(
                "المعيار",
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
