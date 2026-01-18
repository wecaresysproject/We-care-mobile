import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/di/dependency_injection.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/app_logger.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/physical_activaty/data/models/physical_activity_metrics_model.dart';
import 'package:we_care/features/physical_activaty/physical_activaty_view/logic/physical_activaty_view_cubit.dart';
import 'package:we_care/features/physical_activaty/physical_activaty_view/widgets/filters_row_bloc_builder_widget.dart'
    show FiltersRowBlocBuilder;
import 'package:we_care/features/physical_activaty/physical_activaty_view/widgets/second_slide_widget.dart';
import 'package:we_care/features/x_ray/x_ray_view/Presentation/views/widgets/x_ray_data_view_app_bar.dart';

class PhysicalActivityDataView extends StatelessWidget {
  const PhysicalActivityDataView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PhysicalActivityViewCubit>(
      create: (context) =>
          getIt<PhysicalActivityViewCubit>()..getIntialRequests(),
      child: Scaffold(
        appBar: AppBar(toolbarHeight: 0),
        body: Stack(
          children: [
            Center(
              child: Image.asset(
                'assets/images/blue_gradiant.png',
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Image.asset(
                'assets/images/physical_activity_view_background_1.png',
                fit: BoxFit.cover,
                width: MediaQuery.of(context).size.width * 0.85,
                height: MediaQuery.of(context).size.height * 0.6,
              ),
            ),
            Center(
              child: Image.asset(
                'assets/images/shadow.png',
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),
            ),
            const PhysicalActivityDataViewBody(),
          ],
        ),
      ),
    );
  }
}

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

  const MetricRow({
    super.key,
    required this.todayValue,
    required this.cumulativeValue,
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
        ),
        MetricColumn(label: 'تراكمي (فعلي)', value: cumulativeValue),
      ],
    );
  }
}

class MetricRow3 extends StatelessWidget {
  final String todayValue;
  final String cumulativeValue;
  final String standardValue;
  final String subtitle;

  final bool hasGradientBackground;
  final bool isWightDetailsSlide;

  const MetricRow3({
    super.key,
    required this.todayValue,
    required this.cumulativeValue,
    required this.standardValue,
    required this.subtitle,
    this.hasGradientBackground = false,
    this.isWightDetailsSlide = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            MetricColumn(
                label: 'اليوم (فعلي)',
                value: todayValue,
                isHighlight: true,
                hasGradientBackground: hasGradientBackground),
            MetricColumn(
                label: isWightDetailsSlide ? '( الحد الأدنى )' : 'تراكمي فعلي',
                value: cumulativeValue,
                hasGradientBackground: hasGradientBackground),
            MetricColumn(
              label: isWightDetailsSlide ? '( الحد الأقصى )' : 'تراكمي معياري',
              value: standardValue,
              hasGradientBackground: hasGradientBackground,
            ),
          ],
        ),
        verticalSpacing(8),
        Text(
          subtitle,
          style:
              AppTextStyles.font14blackWeight400.copyWith(color: Colors.white),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class MetricColumn extends StatelessWidget {
  final String label;
  final String value;
  final bool isHighlight;
  final bool hasGradientBackground;

  const MetricColumn({
    super.key,
    required this.label,
    required this.value,
    this.isHighlight = false,
    this.hasGradientBackground = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
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
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: isHighlight ? Colors.cyanAccent : Colors.white,
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

      // 2nd slide البناء العضلي ، الصيانة العضلية
      if (hasMuscularGoals) {
        return SecondSlideWidget(slide: slide);
      }

      // Default slide with metrics only
      return Column(
        children: slide.metrics.map((metric) {
          AppLogger.info("metric.metricName ${metric.metricName}");
          return Column(
            children: [
              SectionTitle(
                title: metric.metricName,
                hasGradientBackground: true,
              ),
              verticalSpacing(8),
              MetricRow3(
                isWightDetailsSlide: isWeightDetailsSlide,
                todayValue: metric.todayActual?.toInt().toString() ?? '0',
                cumulativeValue:
                    metric.accumulativeActual?.toInt().toString() ?? '0',
                standardValue: metric.standardTarget?.toInt().toString() ?? '0',
                subtitle: '',
                hasGradientBackground: true,
              ),
              verticalSpacing(16),
            ],
          );
        }).toList(),
      );
    }).toList();
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
