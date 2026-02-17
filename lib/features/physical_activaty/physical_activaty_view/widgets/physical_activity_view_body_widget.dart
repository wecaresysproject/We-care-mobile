import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/core/routing/routes.dart';
import 'package:we_care/features/physical_activaty/data/models/physical_activity_metrics_model.dart';
import 'package:we_care/features/physical_activaty/physical_activaty_view/widgets/filters_row_bloc_builder_widget.dart';
import 'package:we_care/features/physical_activaty/physical_activaty_view/widgets/second_slide_widget.dart';
import 'package:we_care/features/x_ray/x_ray_view/Presentation/views/widgets/x_ray_data_view_app_bar.dart';

import '../logic/physical_activaty_view_cubit.dart';

class PhysicalActivityDataViewBody extends StatelessWidget {
  const PhysicalActivityDataViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PhysicalActivityViewCubit, PhysicalActivatyViewState>(
      buildWhen: (previous, current) =>
          previous.requestStatus != current.requestStatus ||
          previous.physicalActivitySLides != current.physicalActivitySLides,
      builder: (context, state) {
        if (state.requestStatus == RequestStatus.loading) {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.white,
            ),
          );
        }

        if (state.requestStatus == RequestStatus.failure) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  state.responseMessage.isNotEmpty
                      ? state.responseMessage
                      : 'حدث خطأ ما، حاول مرة أخرى',
                  style: AppTextStyles.font18blackWight500
                      .copyWith(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
                verticalSpacing(16),
                ElevatedButton(
                  onPressed: () {
                    context
                        .read<PhysicalActivityViewCubit>()
                        .getIntialRequests();
                  },
                  child: const Text('إعادة المحاولة'),
                ),
              ],
            ),
          );
        }

        final data = state.physicalActivitySLides?.data;
        final sportMinutes = data?.sportPracticeMinutes;
        final slides = data?.slides ?? [];

        return RefreshIndicator(
          onRefresh: () async {
            await context.read<PhysicalActivityViewCubit>().getIntialRequests();
          },
          triggerMode: RefreshIndicatorTriggerMode.anywhere,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                ViewAppBar(),
                FiltersRowBlocBuilder(),
                verticalSpacing(24),

                /// 🔹 Section 1: عدد دقائق ممارسة الرياضة لليوم
                SectionTitle(
                  iconPath: 'assets/images/time_icon.png',
                  title: 'عدد دقائق ممارسة الرياضة',
                ),
                verticalSpacing(8),
                MetricRow(
                  todayValue: sportMinutes?.todayActual?.toString() ?? '0',
                  cumulativeValue:
                      sportMinutes?.accumulativeActual?.toString() ?? '0',
                  valueFontSize: 50,
                ),

                verticalSpacing(28),

                _SwitchableSections(slides: slides),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// ---- UI Components ----

class SectionTitle extends StatelessWidget {
  final String title;
  final String? iconPath;
  final bool hasGradientBackground;
  const SectionTitle(
      {super.key,
      required this.title,
      this.iconPath,
      this.hasGradientBackground = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: hasGradientBackground
          ? BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF5998CD),
                  Color(0xFF03508F),
                  Color(0xff2B2B2B),
                ],
              ),
              borderRadius: BorderRadius.circular(14.r),
            )
          : null,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          iconPath != null
              ? Row(
                  children: [
                    Image.asset(iconPath!, height: 20.h, width: 20.w),
                    horizontalSpacing(8),
                  ],
                )
              : SizedBox.shrink(),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              title,
              style: AppTextStyles.font18blackWight500.copyWith(
                color: hasGradientBackground
                    ? Colors.white
                    : AppColorsManager.mainDarkBlue,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MetricRow extends StatelessWidget {
  final String todayValue;
  final String cumulativeValue;
  final double valueFontSize;

  const MetricRow({
    super.key,
    required this.todayValue,
    required this.cumulativeValue,
    this.valueFontSize = 16,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        MetricColumn(
          label: 'اليوم (فعلي)',
          value: todayValue,
          isHighlight: true,
          valueFontSize: valueFontSize,
        ),
        MetricColumn(
          label: 'تراكمي (فعلي)',
          value: cumulativeValue,
          valueFontSize: valueFontSize,
        ),
      ],
    );
  }
}

class MetricRow3 extends StatelessWidget {
  final String todayValue;
  final String cumulativeValue;
  final String standardValue;

  final bool hasGradientBackground;
  final bool isWightDetailsSlide;
  final bool isBMILabel;
  final bool isCaloriesSlide;
  final double valueFontSize;

  const MetricRow3({
    super.key,
    required this.todayValue,
    required this.cumulativeValue,
    required this.standardValue,
    this.hasGradientBackground = false,
    this.isWightDetailsSlide = false,
    this.isBMILabel = false,
    this.isCaloriesSlide = false,
    this.valueFontSize = 16,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        MetricColumn(
            label: handleLabelNaming(
              isWightDetailsSlide: isWightDetailsSlide,
              isBMILabel: isBMILabel,
            ),
            valueFontSize: valueFontSize,
            value: todayValue,
            isHighlight: true,
            hasGradientBackground: hasGradientBackground),
        MetricColumn(
            label: isWightDetailsSlide ? '( الحد الأدنى )' : 'تراكمي فعلي',
            value: cumulativeValue,
            valueFontSize: valueFontSize,
            hasGradientBackground: hasGradientBackground),
        MetricColumn(
          label: handle3rdLabelNaming(
              isCaloriesSlide: isCaloriesSlide,
              isWightDetailsSlide: isWightDetailsSlide),
          value: standardValue,
          hasGradientBackground: hasGradientBackground,
          valueFontSize: valueFontSize,
        ),
      ],
    );
  }
}

String handleLabelNaming(
    {bool isBMILabel = false, bool isWightDetailsSlide = false}) {
  if (isBMILabel) {
    return 'BMI (الفعلي)';
  } else if (isWightDetailsSlide) {
    return 'الوزن (الفعلي)';
  } else {
    return 'اليوم (فعلي)';
  }
}

String handle3rdLabelNaming(
    {bool isCaloriesSlide = false, bool isWightDetailsSlide = false}) {
  if (isCaloriesSlide) {
    return 'تراكمي مستهدف';
  } else if (isWightDetailsSlide) {
    return '( الحد الأقصى )';
  } else {
    return 'تراكمي معياري';
  }
}

class MetricColumn extends StatelessWidget {
  final String label;
  final String value;
  final bool isHighlight;
  final bool hasGradientBackground;
  final double valueFontSize;

  const MetricColumn({
    super.key,
    required this.label,
    required this.value,
    this.isHighlight = false,
    this.hasGradientBackground = false,
    this.valueFontSize = 16,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: hasGradientBackground
              ? BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF5998CD),
                      Color(0xFF03508F),
                      Color(0xff2B2B2B),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12.r),
                )
              : null,
          child: Text(
            label,
            style: AppTextStyles.font14blackWeight400.copyWith(
              color: Colors.white,
            ),
          ),
        ),
        verticalSpacing(6),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.visible,
            style: AppTextStyles.font20blackWeight600.copyWith(
              color: isHighlight ? Colors.cyanAccent : Colors.white,
              fontSize: valueFontSize.sp,
            ),
          ),
        ),
      ],
    );
  }
}

/// =====================
/// 🔄 Switchable Sections Controller
/// =====================
class _SwitchableSections extends StatefulWidget {
  final List<Slide> slides;

  const _SwitchableSections({required this.slides});

  @override
  State<_SwitchableSections> createState() => _SwitchableSectionsState();
}

class _SwitchableSectionsState extends State<_SwitchableSections> {
  final PageController _pageController = PageController();
  int currentPage = 0;

  List<Widget> _buildPages() {
    if (widget.slides.isEmpty) {
      return [
        Center(
          child: Text(
            'لا توجد بيانات متاحة',
            style:
                AppTextStyles.font18blackWight500.copyWith(color: Colors.white),
          ),
        ),
      ];
    }

    return widget.slides.asMap().entries.map((entry) {
      final index = entry.key;
      final slide = entry.value;
      // Check if this slide has muscular goals
      final hasMuscularGoals = slide.muscularGoalsMaintenance != null ||
          slide.muscularGoalsBuilding != null;
      final isWeightDetailsSlide = index == 2; // slide الثالثة (0-based)
      final isFirstSlide = index == 0;
      final thirdSlide = index == 2;
      // 2nd slide البناء العضلي ، الصيانة العضلية
      if (hasMuscularGoals) {
        return SecondSlideWidget(slide: slide);
      }

      // Default slide with metrics only
      return Column(
        children: slide.metrics.map((metric) {
          final secondSection = metric.metricName.contains("السعرات المحروقة");

          return Column(
            children: [
              if (slide.metrics.first == metric &&
                  metric.metricName
                      .contains("السعرات")) //* show in first slide only
                Text(
                  "وفقا لخطة التغذية المفعلة",
                  style: AppTextStyles.font18blackWight500.copyWith(
                    color: AppColorsManager.backGroundColor,
                    fontSize: 16.sp,
                  ),
                ),
              verticalSpacing(8),
              SectionTitle(
                title: formatMetricTitle(metric.metricName),
                hasGradientBackground: true,
              ),
              verticalSpacing(8),
              MetricRow3(
                isCaloriesSlide: metric.metricName
                    .contains("السعرات المحروقة بالنشاط الرياضي"),
                isBMILabel: metric.metricName.contains("BMI"),
                isWightDetailsSlide: isWeightDetailsSlide,
                todayValue: metric.todayActual?.toInt().toString() ?? '0',
                cumulativeValue:
                    metric.accumulativeActual?.toInt().toString() ?? '0',
                standardValue: metric.standardTarget?.toInt().toString() ?? '0',
                hasGradientBackground: true,
                valueFontSize: thirdSlide ? 50 : 16,
              ),
              if (isFirstSlide && secondSection) ...[
                verticalSpacing(16),
                Align(
                  alignment: AlignmentGeometry.centerRight,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColorsManager.mainDarkBlue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24.r),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 24.w,
                        vertical: 12.h,
                      ),
                    ),
                    onPressed: () async {
                      await context
                          .pushNamed(Routes.caloriesFollowUpReportView);
                    },
                    child: Text(
                      'تقرير المتابعة',
                      style: AppTextStyles.font14whiteWeight600,
                    ),
                  ),
                ),
              ],
            ],
          );
        }).toList(),
      );
    }).toList();
  }

  String formatMetricTitle(String name) {
    if (name == "السعرات المحروقة بالنشاط الرياضي") {
      return "🔥 $name";
    }
    return name;
  }

  void _nextPage() {
    final pages = _buildPages();
    if (currentPage < pages.length - 1) {
      setState(() => currentPage++);
      _pageController.animateToPage(currentPage,
          duration: const Duration(milliseconds: 400), curve: Curves.easeInOut);
    }
  }

  void _previousPage() {
    if (currentPage > 0) {
      setState(() => currentPage--);
      _pageController.animateToPage(currentPage,
          duration: const Duration(milliseconds: 400), curve: Curves.easeInOut);
    }
  }

  @override
  Widget build(BuildContext context) {
    final pages = _buildPages();

    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.7,
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: pages,
              ),
            ),

            /// =====================
            /// ➡️ السهم اليمين (للصفحة السابقة)
            /// =====================
            if (currentPage > 0)
              Positioned(
                right: 0,
                top: 275.h,
                child: ClipOval(
                  child: Material(
                    color: Colors.white,
                    child: InkWell(
                      splashColor:
                          AppColorsManager.mainDarkBlue.withOpacity(0.2),
                      onTap: _previousPage,
                      child: const SizedBox(
                        width: 38,
                        height: 38,
                        child: Icon(
                          Icons.arrow_back_ios_outlined,
                          color: AppColorsManager.mainDarkBlue,
                          size: 28,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

            /// =====================
            /// ⬅️ السهم الشمال (للصفحة التالية)
            /// =====================
            if (currentPage < pages.length - 1)
              Positioned(
                left: 0,
                top: 275.h,
                child: ClipOval(
                  child: Material(
                    color: Colors.white,
                    child: InkWell(
                      splashColor:
                          AppColorsManager.mainDarkBlue.withOpacity(0.2),
                      onTap: _nextPage,
                      child: const SizedBox(
                        width: 38,
                        height: 38,
                        child: Icon(
                          Icons.arrow_forward_ios_outlined,
                          color: AppColorsManager.mainDarkBlue,
                          size: 28,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}
