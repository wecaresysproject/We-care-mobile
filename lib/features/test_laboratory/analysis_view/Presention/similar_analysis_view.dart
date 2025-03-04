import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/details_view_app_bar.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';

class SimilarAnalysisView extends StatelessWidget {
  SimilarAnalysisView({super.key});

  final List<AnalysisData> chartData = [
    AnalysisData(x: 1, y: 100, label: "الأول"),
    AnalysisData(x: 2, y: 50, label: "الثاني"),
    AnalysisData(x: 3, y: 140, label: "الثالث"),
    AnalysisData(x: 4, y: 180, label: "الرابع"),
    AnalysisData(x: 5, y: 100, label: "الخامس"),
    AnalysisData(x: 6, y: 100, label: "السادس"),
    AnalysisData(x: 7, y: 145, label: "السابع"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            children: [
              DetailsViewAppBar(title: 'التحاليل المماثلة'),
              verticalSpacing(24),
              CustomAnalysisContainer(
                  iconPath: 'assets/images/noto_test-tube.png',
                  label: 'Na',
                  title: 'ًصوديوم',
                  description:
                      'يقيس نسبة الصوديوم في الدم ، وهو أحد المعادن الأساسية فى الجسم والمسئول عن توازن السوائل ووظائف الأعصاب والعضلات .'),
              verticalSpacing(16),
              //TODO create list view.builder
              AnalysisCard(
                date: ["20/12/2025"],
                names: [
                  "MCV",
                  "HB",
                  "PTL",
                  "WBC",
                ],
                ranges: ["4.2 - 5.4", "100 - 200", "50 - 100", "25 - 33"],
                results: ["4.4", "100", "50", "25"],
                interpretation:
                    "تشير النسبة المرتفعة للبوتاسيوم إلى مشاكل في وظيفة الكلى أو تناول بعض الأدوية التي ترفع مستويات البوتاسيوم.",
              ),
              AnalysisCard(
                  date: [
                    "20/12/2025"
                  ],
                  names: [
                    "NA",
                  ],
                  ranges: [
                    "4.2 - 5.4"
                  ],
                  results: [
                    "4.4"
                  ],
                  interpretation:
                      "تشير النسبة المرتفعة للبوتاسيوم إلى مشاكل في وظيفة الكلى أو تناول بعض الأدوية التي ترفع مستويات البوتاسيوم."),
              verticalSpacing(12),
              AnalysisLineChart(
                data: chartData,
                title: 'راقب نسب التغيرات',
                normalMax: 130,
                normalMin: 100,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class CustomAnalysisContainer extends StatelessWidget {
  final String iconPath; // e.g., 'assets/icons/test_icon.png'
  final String label; // e.g., 'NA'
  final String title; // e.g., 'صوديوم'
  final String description; // e.g., 'يقيس نسبة الصوديوم في الدم ...'

  const CustomAnalysisContainer({
    super.key,
    required this.iconPath,
    required this.label,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title, Icon, and Label Row ABOVE the container
        Row(
          children: [
            Image.asset(
              iconPath,
              width: 24.w,
              height: 24.h,
            ),
            horizontalSpacing(8),
            Text(
              title,
              style: AppTextStyles.font20blackWeight600.copyWith(
                color: AppColorsManager.mainDarkBlue,
              ),
            ),
            horizontalSpacing(24),
            Text(
              label,
              style: AppTextStyles.font20blackWeight600.copyWith(
                color: AppColorsManager.mainDarkBlue,
              ),
            ),
          ],
        ),

        verticalSpacing(16),

        // The Container with border & background
        Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          decoration: BoxDecoration(
            // If you want a gradient background
            gradient: const LinearGradient(
              colors: [Color(0xFFECF5FF), Color(0xFFFBFDFF)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppColorsManager.mainDarkBlue,
              width: 1,
            ),
          ),
          child: Text(
            description,
            style: AppTextStyles.font12blackWeight400,
          ),
        ),
      ],
    );
  }
}

class AnalysisCard extends StatelessWidget {
  final List<String> date; // e.g. "13/11/2025"
  final List<String> names; // e.g. ["MCV", "HB", "PTL", "WBC", ...]
  final List<String> ranges; // e.g. ["4.2 - 5.4", "100 - 200", ...]
  final List<String> results;
  final String interpretation; // e.g. "تشير النسبة المرتفعة ..."

  const AnalysisCard({
    super.key,
    required this.date,
    required this.names,
    required this.ranges,
    required this.results,
    required this.interpretation,
  });

  @override
  Widget build(BuildContext context) {
    // Colors & Dimensions (change as needed)
    const Color borderColor = Color(0xFF014C8A);
    const Color backgroundStart = Color(0xFFECF5FF);
    const Color backgroundEnd = Color(0xFFFBFDFF);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
      margin: EdgeInsets.symmetric(vertical: 12.h),
      decoration: BoxDecoration(
        // Optional gradient background
        gradient: const LinearGradient(
          colors: [backgroundStart, backgroundEnd],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Row: date, name, code, range, result
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // التاريخ + أيقونة
              _buildColumnItem(
                icon: Icons.calendar_today,
                label: 'التاريخ',
                value: date,
                context: context,
              ),

              // الاسم + أيقونة
              _buildColumnItem(
                icon: Icons.text_fields,
                label: 'الاسم',
                value: names,
                context: context,
                isHighlightValue: true, // e.g. "NA"
              ),

              // المعيار + أيقونة
              _buildColumnItem(
                icon: Icons.linear_scale,
                label: 'المعيار',
                value: ranges,
                context: context,
              ),

              // النتيجة + أيقونة
              _buildColumnItem(
                icon: Icons.receipt_long,
                label: 'النتيجة',
                value: results,
                context: context,
              ),
            ],
          ),
          // تفسير (التفسير) + أيقونة
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.info_outline, color: borderColor, size: 20),
              const SizedBox(width: 4),
              Text(
                'التفسير',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: borderColor,
                ),
              ),
            ],
          ),

          verticalSpacing(8),

          // Interpretation Text
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.transparent, // a slightly different background
              borderRadius: BorderRadius.circular(8),
              border:
                  Border.all(color: AppColorsManager.mainDarkBlue, width: 0.5),
            ),
            child: Text(
              interpretation,
              style: AppTextStyles.font12blackWeight400,
              //textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  /// A helper widget that builds each item in the top row
  /// with an icon, label, and value. If `highlightValue` is given,
  /// it displays a colored box next to the main value.
  Widget _buildColumnItem({
    required IconData icon,
    required String label,
    required List<String> value,
    bool isHighlightValue = false,
    required BuildContext context,
  }) {
    const Color borderColor = AppColorsManager.mainDarkBlue;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      //  mainAxisSize: MainAxisSize.max,
      children: [
        // Label Row: Icon + label
        Row(
          children: [
            Icon(icon, size: 16, color: borderColor),
            horizontalSpacing(4),
            Text(
              label,
              style: AppTextStyles.font16DarkGreyWeight400
                  .copyWith(color: borderColor),
            ),
          ],
        ),
        verticalSpacing(4), // Main Value Row
        SizedBox(
          height: value.length > 1
              ? MediaQuery.of(context).size.height * 0.17
              : MediaQuery.of(context).size.height * 0.05,
          width: MediaQuery.of(context).size.width * 0.2,
          child: ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: value.length,
            itemBuilder: (context, index) => Container(
              margin: EdgeInsets.symmetric(vertical: 2.w),
              padding: label == 'الاسم' || label == 'النتيجة'
                  ? EdgeInsets.symmetric(horizontal: 16.w, vertical: 2.h)
                  : EdgeInsets.symmetric(
                      horizontal: 4.w,
                      vertical: 2.h), //TODO: Apply localization
              decoration: BoxDecoration(
                color: isHighlightValue ? borderColor : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: borderColor, width: 1),
              ),
              child: Text(
                value[index],
                style: AppTextStyles.font14whiteWeight600.copyWith(
                  color: isHighlightValue ? Colors.white : Colors.black,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                //    overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class AnalysisData {
  final int x; // e.g. 1, 2, 3, ...
  final double y; // e.g. 100, 140, 180, ...
  final String label; // e.g. "الأول", "الثاني", ...

  AnalysisData({required this.x, required this.y, required this.label});
}

class AnalysisLineChart extends StatelessWidget {
  final List<AnalysisData> data;
  final String title; // "راقب تغيرات النسب"

  // ADD: Normal Range
  final double normalMin; // e.g. 80
  final double normalMax; // e.g. 120

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
