import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_care/core/di/dependency_injection.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/custom_app_bar.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/Biometrics/biometrics_view/Presention/current_biometrics_results_view.dart';
import 'package:we_care/features/Biometrics/biometrics_view/logic/biometrics_view_cubit.dart';
import 'package:we_care/features/Biometrics/biometrics_view/logic/biometrics_view_state.dart';
import 'package:we_care/features/Biometrics/data/models/biometrics_dataset_model.dart';
import 'package:we_care/features/x_ray/x_ray_view/Presentation/views/widgets/x_ray_data_filters_row.dart';
import 'package:fl_chart/fl_chart.dart';

class BiometricsView extends StatefulWidget {
  const BiometricsView({super.key});

  @override
  State<BiometricsView> createState() => _BiometricsViewState();
}

class _BiometricsViewState extends State<BiometricsView>
    with SingleTickerProviderStateMixin {
  final Set<String> selectedMetrics = {};
  int currentGraphIndex = 0;
  bool showBottomSheet = false;
  late TabController _tabController;

  // Theme colors for modern styling
  final Color primaryColor = AppColorsManager.mainDarkBlue;
  final Color secondaryColor = AppColorsManager.secondaryColor;
  final Color accentColor = const Color(0xFF50E3C2);
  final Color backgroundColor = const Color(0xFFF8FAFC);
  final Color cardColor = Colors.white;
  final Color textColor = const Color(0xFF2D3748);
  final Color subtitleColor = const Color(0xFF718096);

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _showBottomSheetModal(dynamic selectedFilters) {
    if (selectedMetrics.isEmpty) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => BlocProvider(
          create: (context) => getIt<BiometricsViewCubit>()
            ..getFilteredBiometrics(
                year: selectedFilters['السنة'],
                month: selectedFilters['الشهر'],
                day: selectedFilters['اليوم'],
                biometricCategories: biometricTypes
                    .where((b) => selectedMetrics.contains(b.id))
                    .map((b) => b.name)
                    .toList()),
          child: DraggableScrollableSheet(
            snap: true,
            initialChildSize: 0.6,
            minChildSize: 0.3,
            maxChildSize: 0.9,
            builder: (context, scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(20)),
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
                              color: AppColorsManager.mainDarkBlue,
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
                                  color: currentGraphIndex > 0
                                      ? Colors.white
                                      : subtitleColor,
                                ),
                              ),
                            ),
                          ),
                          Column(
                            children: [
                              Text(
                                biometricTypes
                                    .firstWhere((b) =>
                                        b.id ==
                                        selectedMetrics
                                            .elementAt(currentGraphIndex))
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
                              color: AppColorsManager.mainDarkBlue,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Center(
                              child: IconButton(
                                iconSize: 20,
                                onPressed: currentGraphIndex <
                                        selectedMetrics.length - 1
                                    ? () {
                                        setModalState(() {
                                          currentGraphIndex++;
                                        });
                                      }
                                    : null,
                                icon: Icon(
                                  Icons.arrow_forward_ios,
                                  color: currentGraphIndex <
                                          selectedMetrics.length - 1
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
                    BlocBuilder<BiometricsViewCubit, BiometricsViewState>(
                      builder: (context, state) {
                        if (state.requestStatus == RequestStatus.loading) {
                          return const Center(
                            child: CircularProgressIndicator(
                              color: AppColorsManager.mainDarkBlue,
                            ),
                          );
                        }
                        if (state.biometricsData.isEmpty &&
                            state.requestStatus == RequestStatus.success) {
                          return Center(
                            child: Text(
                              'لا توجد بيانات متاحة',
                              style: AppTextStyles.font22MainBlueWeight700,
                            ),
                          );
                        }
                        if (state.requestStatus == RequestStatus.failure) {
                          return Center(
                            child: Text(
                              state.responseMessage.isNotEmpty
                                  ? state.responseMessage
                                  : 'حدث خطأ ما',
                              style: AppTextStyles.font22MainBlueWeight700,
                            ),
                          );
                        }
                        return Expanded(
                          child: SingleChildScrollView(
                            controller: scrollController,
                            child: _buildChart(
                              state.biometricsData,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<BiometricsViewCubit>(
      create: (context) => getIt<BiometricsViewCubit>()
        ..getAllAvailableBiometrics()
        ..getAllFilters(),
      child: RefreshIndicator(
        onRefresh: () async {
          await getIt<BiometricsViewCubit>().getAllAvailableBiometrics();
          await getIt<BiometricsViewCubit>().getAllFilters();
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
                CustomAppBarWidget(
                  haveBackArrow: true,
                ),
                verticalSpacing(12),
                _buildTabBar(),
                verticalSpacing(6),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      buildBiometricsHistoryTab(),
                      CurrentBiometricsResultsTab(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    return TabBar(
      tabs: const [
        Tab(
          text: 'المقاييس الحيوية',
        ),
        Tab(
          text: 'المقاييس الحيوية الحالية',
        ),
      ],
      controller: _tabController,
      indicatorColor: AppColorsManager.mainDarkBlue,
    );
  }

  Widget buildBiometricsHistoryTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        verticalSpacing(16),
        buildFiltersRow(),
        verticalSpacing(24),
        buildMetricsGridView(),
      ],
    );
  }

  Widget buildMetricsGridView() {
    return BlocBuilder<BiometricsViewCubit, BiometricsViewState>(
      buildWhen: (previous, current) =>
          previous.availableBiometricNames != current.availableBiometricNames,
      builder: (context, state) {
        if (state.requestStatus == RequestStatus.loading) {
          return Expanded(
            child: const Center(
              child: CircularProgressIndicator(
                color: AppColorsManager.mainDarkBlue,
              ),
            ),
          );
        }
        if (state.availableBiometricNames.isEmpty) {
          return Expanded(
            child: Center(
              child: Text('لا توجد مقاييس حيوية متاحة',
                  style: AppTextStyles.font22MainBlueWeight700),
            ),
          );
        }
        return Expanded(
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 1.2,
            ),
            itemCount: state.availableBiometricNames.length,
            itemBuilder: (context, index) {
              final biometric = biometricTypes.firstWhere(
                (b) => b.name == state.availableBiometricNames[index],
                orElse: () => BiometricType(
                  id: '',
                  name: 'غير معروف',
                  icon: '❓',
                  color: Colors.grey,
                ),
              );
              final isSelected = selectedMetrics.contains(biometric.id);

              return buildMetricGridItem(isSelected, biometric, context);
            },
          ),
        );
      },
    );
  }

  Widget buildMetricGridItem(
      bool isSelected, BiometricType biometric, BuildContext context) {
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
          color: Colors.white,
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
  }

  Widget buildFiltersRow() {
    return BlocBuilder<BiometricsViewCubit, BiometricsViewState>(
      buildWhen: (previous, current) =>
          previous.yearsFilter != current.yearsFilter ||
          previous.daysFilter != current.daysFilter ||
          previous.monthFilter != current.monthFilter,
      builder: (context, state) {
        return DataViewFiltersRow(
          filters: [
            FilterConfig(
                title: 'السنة', options: state.yearsFilter, isYearFilter: true),
            FilterConfig(
              title: 'الشهر',
              options: state.monthFilter,
            ),
            FilterConfig(title: 'اليوم', options: state.daysFilter),
          ],
          onApply: (selectedFilters) {
            if (selectedMetrics.isNotEmpty) {
              _showBottomSheetModal(
                selectedFilters,
              );
            }
          },
        );
      },
    );
  }

  Widget _buildChart(List<BiometricsDatasetModel> biometricdata) {
    if (selectedMetrics.isEmpty) return const SizedBox();

    final currentMetricId = selectedMetrics.elementAt(currentGraphIndex);
    final currentMetric =
        biometricTypes.firstWhere((b) => b.id == currentMetricId);
    final data = biometricdata
        .firstWhere((d) => d.type == currentMetric.name,
            orElse: () =>
                BiometricsDatasetModel(type: currentMetricId, data: []))
        .data;

    final double minY = 0; // Force starting from 0
    final double maxDataY = data.map((d) => d.value.toInt.toDouble()).reduce((a, b) => a > b ? a : b);
    
    // Consider all relevant values for determining the chart's max Y
    //final double effectiveMaxY = [maxDataY, normalMax].reduce(max);

    // Calculate y-axis padding (10% of range or fixed value for very small ranges)
    final double yAxisPadding = max((maxDataY - minY) * 0.1, 0.5);
    final double dynamicMaxY = maxDataY + yAxisPadding;

    // Calculate optimal integer interval based on all relevant values
    final double yRange = dynamicMaxY - minY;
    final int niceInterval = _calculateNiceInterval(yRange);

    if (data.isEmpty) return const SizedBox();

    return Container(
      height: 330,
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 16),
      padding: const EdgeInsets.only(
        left: 0,
        right: 16,
        top: 16,
        bottom: 8,
      ),
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
            getDrawingHorizontalLine: (value) => FlLine(
              color: subtitleColor.withOpacity(0.2),
              strokeWidth: 1,
              dashArray: [3, 3],
            ),
            getDrawingVerticalLine: (value) => FlLine(
              color: subtitleColor.withOpacity(0.2),
              strokeWidth: 1,
              dashArray: [3, 3],
            ),
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
                          padding: const EdgeInsets.only(top: 12, bottom: 4),
                          child: Transform.rotate(
                            angle: -90 * (pi / 180),
                            child: Text(
                              data[value.toInt()].date,
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 11),
                            ),
                          )),
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
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      value.toInt().toString(),
                      style: TextStyle(
                        color: subtitleColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 11,
                      ),
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
          minY: minY,
          maxY:
 data.map((e) => e.value.toInt).reduce((a, b) => a > b ? a : b) +
                  10,
          lineBarsData: [
            // Primary line
            LineChartBarData(
              spots: data.asMap().entries.map((entry) {
                return FlSpot(
                    entry.key.toDouble(), entry.value.value.toInt.toDouble());
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
              showingIndicators: List.generate(data.length, (index) => index),
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

            // Secondary line if available
            if (currentMetric.hasSecondaryValue)
              LineChartBarData(
                color: primaryColor,
                spots: data.asMap().entries.map((entry) {
                  return FlSpot(entry.key.toDouble(),
                      entry.value.secondaryValue.toInt.toDouble() ?? 0);
                }).toList(),
                isCurved: true,
                curveSmoothness: 0.3,
                barWidth: 2,
                isStrokeCapRound: true,
                showingIndicators: List.generate(data.length, (index) => index),
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
              getTooltipColor: (touchedSpot) => AppColorsManager.secondaryColor,
              tooltipMargin: 12,
              tooltipPadding: EdgeInsets.all(5),
              getTooltipItems: (spots) => spots.map((spot) {
                final index = spot.x.toInt();
                final primary = spot.y;
                final secondary =
                    currentMetric.hasSecondaryValue && data.length > index
                        ? data[index].secondaryValue
                        : null;

                final tooltipText = secondary != null
                    ? '${primary.toInt()}/${secondary}'
                    : (primary == primary.truncate()
                        ? primary.toInt().toString()
                        : primary.toString());
                return LineTooltipItem(
                  tooltipText,
                  const TextStyle(
                    color: AppColorsManager.mainDarkBlue,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                );
              }).toList(),
            ),
          ),
          showingTooltipIndicators: data
              .asMap()
              .entries
              .map((spot) => ShowingTooltipIndicators([
                    LineBarSpot(
                      LineChartBarData(
                          spots: data
                              .asMap()
                              .entries
                              .map((e) => FlSpot(e.key.toDouble(),
                                  e.value.value.toInt.toDouble()))
                              .toList()),
                      0,
                      FlSpot(
                        spot.key.toDouble(),
                        spot.value.value.toInt.toDouble(),
                      ),
                    ),
                  ]))
              .toList(),
        ),
      ),
    );
  }
}
int _calculateNiceInterval(double yRange) {
  if (yRange <= 0) return 1;

  // Aim for 4-7 divisions on the y-axis for readability
  final int targetDivisions = 5;
  double rawInterval = yRange / targetDivisions;
  
  // Calculate magnitude (power of 10)
  final double magnitude = pow(10, (log(rawInterval) / ln10).floor()).toDouble();
  final double normalized = rawInterval / magnitude;

  // Find the nearest "nice" number (1, 2, 2.5, 5, 10)
  if (normalized < 1.5) return (1 * magnitude).toInt();
  if (normalized < 2.3) return (2 * magnitude).toInt();
  if (normalized < 3.5) return (2.5 * magnitude).toInt();
  if (normalized < 7.5) return (5 * magnitude).toInt();
  return (10 * magnitude).toInt();
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

final List<BiometricType> biometricTypes = [
  BiometricType(
    id: 'heart_rate',
    name: 'نبضات القلب',
    icon: '❤️',
    color: AppColorsManager.mainDarkBlue,
  ),
  BiometricType(
    id: 'temperature',
    name: 'درجة الحرارة',
    icon: '🌡️',
    color: AppColorsManager.mainDarkBlue,
  ),
  BiometricType(
    id: 'oxygen',
    name: 'مستوى الأكسجين',
    icon: '🫁',
    color: AppColorsManager.mainDarkBlue,
  ),
  BiometricType(
    id: 'blood_pressure',
    name: 'ضغط الدم',
    icon: '🩺',
    color: AppColorsManager.mainDarkBlue,
    hasSecondaryValue: true,
  ),
  BiometricType(
    id: 'blood_sugar',
    name: 'سكر عشوائي',
    icon: '🩸',
    color: AppColorsManager.mainDarkBlue,
  ),
  BiometricType(
    id: 'weight',
    name: 'الوزن',
    icon: '⚖️',
    color: AppColorsManager.mainDarkBlue,
  ),
  BiometricType(
    id: 'height',
    name: 'الطول',
    icon: '📏',
    color: AppColorsManager.mainDarkBlue,
  ),
  BiometricType(
    id: 'blood_pressure_monitor',
    name: 'سكر صائم',
    icon: '🩸',
    color: AppColorsManager.mainDarkBlue,
  ),
];
