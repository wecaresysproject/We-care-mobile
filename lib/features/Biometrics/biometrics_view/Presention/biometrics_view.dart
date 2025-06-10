import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/Biometrics/biometrics_view/logic/biometrics_view_cubit.dart';
import 'package:we_care/features/Biometrics/biometrics_view/logic/biometrics_view_state.dart';
import 'package:we_care/features/x_ray/x_ray_view/Presentation/views/widgets/x_ray_data_filters_row.dart';
import 'package:we_care/features/x_ray/x_ray_view/Presentation/views/widgets/x_ray_data_view_app_bar.dart';
import 'package:fl_chart/fl_chart.dart';

// Dummy data models
class BiometricData {
  final String date;
  final double value;
  final double? secondaryValue; // For blood pressure (diastolic)
  
  BiometricData({
    required this.date,
    required this.value,
    this.secondaryValue,
  });
}

class BiometricType {
  final String id;
  final String name;
  final String icon;
  final Color color;
  final bool hasSecondaryValue;
  
  BiometricType({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
    this.hasSecondaryValue = false,
  });
}

class BiometricsView extends StatefulWidget {
  const BiometricsView({super.key});

  @override
  State<BiometricsView> createState() => _BiometricsViewState();
}

class _BiometricsViewState extends State<BiometricsView> {
  final Set<String> selectedMetrics = {};
  int currentGraphIndex = 0;
  bool showBottomSheet = false; // Control bottom sheet visibility
  
  // Theme colors for modern styling
  final Color primaryColor = AppColorsManager.mainDarkBlue;
  final Color secondaryColor = AppColorsManager.secondaryColor;
  final Color accentColor = const Color(0xFF50E3C2);
  final Color backgroundColor = const Color(0xFFF8FAFC);
  final Color cardColor = Colors.white;
  final Color textColor = const Color(0xFF2D3748);
  final Color subtitleColor = const Color(0xFF718096);
  
  // Dummy data
  final List<BiometricType> biometricTypes = [
    BiometricType(
      id: 'heart_rate',
      name: 'نبضات القلب',
      icon: '❤️',
      color:AppColorsManager.mainDarkBlue,
    ),
    BiometricType(
      id: 'temperature',
      name: 'درجة الحرارة',
      icon: '🌡️',
      color:AppColorsManager.mainDarkBlue,
    ),
    BiometricType(
      id: 'oxygen',
      name: 'مستوى الأكسجين',
      icon: '🫁',
      color:AppColorsManager.mainDarkBlue,
    ),
    BiometricType(
      id: 'blood_pressure',
      name: 'ضغط الدم',
      icon: '🩺',
      color:AppColorsManager.mainDarkBlue,
      hasSecondaryValue: true,
    ),
    BiometricType(
      id: 'blood_sugar',
      name: 'سكر عشوائي',
      icon: '🩸',
      color:AppColorsManager.mainDarkBlue,
    ),
    BiometricType(
      id: 'weight',
      name: 'الوزن',
      icon: '⚖️',
      color:AppColorsManager.mainDarkBlue,
    ),
    BiometricType(
      id: 'height',
      name: 'الطول',
      icon: '📏',
      color:AppColorsManager.mainDarkBlue,

    ),
    BiometricType(
      id: 'blood_pressure_monitor',
      name: 'سكر صائم',
      icon: '🩸',
       color:AppColorsManager.mainDarkBlue,

    ),
  ];

  Map<String, List<BiometricData>> getDummyData() {
    return {
      'heart_rate': [
        BiometricData(date: '13/6', value: 72),
        BiometricData(date: '15/5', value: 80),
        BiometricData(date: '15/6', value: 75),
        BiometricData(date: '17/8', value: 85),
        BiometricData(date: '22/10', value: 78),
        BiometricData(date: '22/11', value: 82),
        BiometricData(date: '22/12', value: 76),
      ],
      'temperature': [
        BiometricData(date: '13/6', value: 36.5),
        BiometricData(date: '15/5', value: 37.2),
        BiometricData(date: '15/6', value: 36.8),
        BiometricData(date: '17/8', value: 37.0),
        BiometricData(date: '22/10', value: 36.9),
        BiometricData(date: '22/11', value: 36.7),
        BiometricData(date: '22/12', value: 36.6),
      ],
      'blood_pressure': [
        BiometricData(date: '13/6', value: 120, secondaryValue: 80),
        BiometricData(date: '15/5', value: 110, secondaryValue: 70),
        BiometricData(date: '15/6', value: 140, secondaryValue: 90),
        BiometricData(date: '17/8', value: 130, secondaryValue: 85),
        BiometricData(date: '22/10', value: 125, secondaryValue: 82),
        BiometricData(date: '22/11', value: 115, secondaryValue: 75),
        BiometricData(date: '22/12', value: 135, secondaryValue: 88),
      ],
      'oxygen': [
        BiometricData(date: '13/6', value: 98),
        BiometricData(date: '15/5', value: 97),
        BiometricData(date: '15/6', value: 99),
        BiometricData(date: '17/8', value: 96),
        BiometricData(date: '22/10', value: 98),
        BiometricData(date: '22/11', value: 97),
        BiometricData(date: '22/12', value: 99),
      ],
    };
  }

  void _dismissBottomSheet() {
    setState(() {
      showBottomSheet = false;
      selectedMetrics.clear();
      currentGraphIndex = 0;
    });
  }

  void _showBottomSheetModal() {
    if (selectedMetrics.isEmpty) return;
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => DraggableScrollableSheet(
          snap: true,
          initialChildSize: 0.6,
          minChildSize: 0.3,
          maxChildSize: 0.9,
          builder: (context, scrollController) {
            return Container(
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Handle bar
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 12),
                    height: 4,
                    width: 40,
                    decoration: BoxDecoration(
                      color: subtitleColor.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  // Header with navigation
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 35,
                          height: 35,
                          decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: IconButton(
                              iconSize: 20,
                              onPressed: currentGraphIndex > 0
                                  ? () {
                                      setModalState(() {
                                        currentGraphIndex--;
                                      });
                                    }
                                  : null,
                              icon: Icon(
                                Icons.arrow_back_ios,
                                color: currentGraphIndex > 0 ? Colors.white : subtitleColor,
                              ),
                            ),
                          ),
                        ),
                        Column(
                          children: [
                            Text(
                              biometricTypes
                                  .firstWhere((b) => b.id == selectedMetrics.elementAt(currentGraphIndex))
                                  .name,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: textColor,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'ديسمبر 2024 حتى الآن',
                              style: TextStyle(
                                fontSize: 14,
                                color: subtitleColor,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          width: 35,
                          height: 35,
                          decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: IconButton(
                              iconSize: 20,
                              onPressed: currentGraphIndex < selectedMetrics.length - 1
                                  ? () {
                                      setModalState(() {
                                        currentGraphIndex++;
                                      });
                                    }
                                  : null,
                              icon: Icon(
                                Icons.arrow_forward_ios,
                                color: currentGraphIndex < selectedMetrics.length - 1
                                    ? Colors.white
                                    : subtitleColor,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Chart
                  Expanded(
                    child: SingleChildScrollView(
                      controller: scrollController,
                      child: _buildChart(
                        getDummyData(),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<BiometricsViewCubit>(
      create: (context) => BiometricsViewCubit(),
      child: RefreshIndicator(
        onRefresh: () async {
          // BlocProvider.of<BiometricsViewCubit>(context).init();
        },
        triggerMode: RefreshIndicatorTriggerMode.anywhere,
        child: Scaffold(
          backgroundColor: backgroundColor,
          appBar: AppBar(
            toolbarHeight: 0,
            backgroundColor: backgroundColor,
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                ViewAppBar(),
                buildFiltersRow(),
                verticalSpacing(24),
                buildMetricsGridView(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Expanded buildMetricsGridView() {
    return Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 1.2,
                  ),
                  itemCount: biometricTypes.length,
                  itemBuilder: (context, index) {
                    final biometric = biometricTypes[index];
                    final isSelected = selectedMetrics.contains(biometric.id);
                    
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          if (isSelected) {
                            selectedMetrics.remove(biometric.id);
                          } else if (selectedMetrics.length < 4) {
                            selectedMetrics.add(biometric.id);
                          } else {
                            // Show message that only 4 metrics can be selected
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text('يمكن اختيار 4 مقاييس كحد أقصى'),
                                backgroundColor: biometric.color,
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            );
                          }
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        decoration: BoxDecoration(
                          color: cardColor,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isSelected ? biometric.color : Colors.grey[200]!,
                            width: isSelected ? 2.5 : 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: isSelected 
                                  ? biometric.color.withOpacity(0.2)
                                  : Colors.grey.withOpacity(0.08),
                              spreadRadius: isSelected ? 2 : 1,
                              blurRadius: isSelected ? 8 : 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: biometric.color.withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Text(
                                biometric.icon,
                                style: const TextStyle(fontSize: 28),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              biometric.name,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: isSelected ? biometric.color : textColor,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            if (isSelected)
                              Container(
                                margin: const EdgeInsets.only(top: 8),
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: biometric.color,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.check,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
  }

  BlocBuilder<BiometricsViewCubit, BiometricsViewState> buildFiltersRow() {
    return BlocBuilder<BiometricsViewCubit, BiometricsViewState>(
                buildWhen: (previous, current) =>
                    previous.yearsFilter != current.yearsFilter ||
                    previous.daysFilter != current.daysFilter || 
                    previous.monthFilter != current.monthFilter,
                builder: (context, state) {
                  return DataViewFiltersRow(
                    filters: [
                      FilterConfig(
                          title: 'السنة',
                          options: state.yearsFilter,
                          isYearFilter: true),
                      FilterConfig(
                          title: 'الشهر',
                          options: state.monthFilter,
                          isYearFilter: false),
                      FilterConfig(
                          title: 'اليوم',
                          options: state.daysFilter,
                          isYearFilter: false),
                    ],
                    onApply: (selectedFilters) {
                      // Show bottom sheet only after applying filters
                      if (selectedMetrics.isNotEmpty) {
                        _showBottomSheetModal();
                      }
                    },
                  );
                },
              );
  }

  Widget _buildChart( Map<String, List<BiometricData>> biometricdata) {
    if (selectedMetrics.isEmpty) return const SizedBox();
    
    final currentMetricId = selectedMetrics.elementAt(currentGraphIndex);
    final currentMetric = biometricTypes.firstWhere((b) => b.id == currentMetricId);
    final data = biometricdata[currentMetricId] ?? [];
    
    if (data.isEmpty) return const SizedBox();

    return Container(
      height: 320,
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: LineChart(
        LineChartData(
          gridData: FlGridData(
            show: true,
            drawVerticalLine: true,
            horizontalInterval: currentMetric.hasSecondaryValue ? 20 : null,
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: subtitleColor.withOpacity(0.2),
                strokeWidth: 1,
                dashArray: [3, 3],
              );
            },
            getDrawingVerticalLine: (value) {
              return FlLine(
                color: subtitleColor.withOpacity(0.2),
                strokeWidth: 1,
                dashArray: [3, 3],
              );
            },
          ),
          titlesData: FlTitlesData(
            show: true,
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 50,
                interval: 1,
                getTitlesWidget: (double value, TitleMeta meta) {
                  if (value.toInt() >= 0 && value.toInt() < data.length) {
                    return SideTitleWidget(
                      meta: meta,
                      child: Container(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          data[value.toInt()].date,
                          style: TextStyle(
                            color: subtitleColor,
                            fontWeight: FontWeight.w500,
                            fontSize: 11,
                          ),
                        ),
                      ),
                    );
                  }
                  return const Text('');
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: currentMetric.hasSecondaryValue ? 20 : null,
                reservedSize: 45,
                getTitlesWidget: (double value, TitleMeta meta) {
                  return Text(
                    value.toInt().toString(),
                    style: TextStyle(
                      color: subtitleColor,
                      fontWeight: FontWeight.w500,
                      fontSize: 11,
                    ),
                  );
                },
              ),
            ),
          ),
          borderData: FlBorderData(
            show: true,
            border: Border.all(
              color: subtitleColor.withOpacity(0.2),
              width: 1,
            ),
          ),
          minX: 0,
          maxX: (data.length - 1).toDouble(),
          minY: currentMetric.hasSecondaryValue ? 60 : data.map((e) => e.value).reduce((a, b) => a < b ? a : b) - 10,
          maxY: currentMetric.hasSecondaryValue ? 180 : data.map((e) => e.value).reduce((a, b) => a > b ? a : b) + 10,
          lineBarsData: [
            // Primary line
            LineChartBarData(
              spots: data.asMap().entries.map((entry) {
                return FlSpot(entry.key.toDouble(), entry.value.value);
              }).toList(),
              isCurved: true,
              curveSmoothness: 0.3,
              gradient: LinearGradient(
                colors: [
                  currentMetric.color.withOpacity(0.9),
                  currentMetric.color,
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              barWidth: 2,
              dotData: FlDotData(
                show: true,
                getDotPainter: (spot, percent, barData, index) {
                  return FlDotCirclePainter(
                    radius: 4,
                    color: currentMetric.color,
                    strokeWidth: 3,
                    strokeColor: cardColor,
                  );
                },
              ),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  colors: [
                    currentMetric.color.withOpacity(0.2),
                    currentMetric.color.withOpacity(0.05),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
            // Secondary line for blood pressure (diastolic)
            if (currentMetric.hasSecondaryValue)
              LineChartBarData(
                color: primaryColor,
                spots: data.asMap().entries.map((entry) {
                  return FlSpot(entry.key.toDouble(), entry.value.secondaryValue ?? 0);
                }).toList(),
                isCurved: true,
                curveSmoothness: 0.3,
           
                barWidth: 2,
                isStrokeCapRound: true,
                dotData: FlDotData(
                  show: true,
                  getDotPainter: (spot, percent, barData, index) {
                    return FlDotCirclePainter(
                      radius: 4,
                      color: primaryColor,
                      strokeWidth: 3,
                      strokeColor: cardColor,
                    );
                  },
                ),
                belowBarData: BarAreaData(
                  show: true,
                  gradient: LinearGradient(
                    colors: [
                      secondaryColor.withOpacity(0.2),
                      secondaryColor.withOpacity(0.05),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
          ],
          
          lineTouchData: LineTouchData(
            enabled: true,
            touchTooltipData: LineTouchTooltipData(
              tooltipRoundedRadius: 12,
              tooltipPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
                return touchedBarSpots.map((barSpot) {
                  final flSpot = barSpot;
                  if (currentMetric.hasSecondaryValue) {
                    final dataPoint = data[flSpot.x.toInt()];
                    if (barSpot.barIndex == 0) {
                      return LineTooltipItem(
                        'الكبرى: ${dataPoint.value.toInt()}',
                        const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      );
                    } else {
                      return LineTooltipItem(
                        'الصغرى: ${dataPoint.secondaryValue?.toInt()}',
                        const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      );
                    }
                  } else {
                    return LineTooltipItem(
                      '${flSpot.y.toInt()}',
                      const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    );
                  }
                }).toList();
              },
            ),
            touchCallback: (FlTouchEvent event, LineTouchResponse? touchResponse) {
              // Add haptic feedback on touch
              if (event is FlTapUpEvent) {
                // HapticFeedback.lightImpact();
              }
            },
          ),
        ),
      ),
    );
  }
}