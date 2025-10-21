import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/x_ray/x_ray_view/Presentation/views/widgets/x_ray_data_filters_row.dart';
import 'package:we_care/features/x_ray/x_ray_view/Presentation/views/widgets/x_ray_data_view_app_bar.dart';

class PhysicalActivityDataView extends StatelessWidget {
  const PhysicalActivityDataView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
    );
  }
}

class PhysicalActivityDataViewBody extends StatelessWidget {
  const PhysicalActivityDataViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {},
      triggerMode: RefreshIndicatorTriggerMode.anywhere,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            ViewAppBar(),
            DataViewFiltersRow(
              filters: [
                FilterConfig(title: 'السنة', options: [], isYearFilter: true),
                FilterConfig(
                    title: 'التاريخ', options: [], isMedicineFilter: true),
              ],
              onApply: (selectedFilters) {},
            ),
            verticalSpacing(24),

            /// 🔹 Section 1: عدد دقائق ممارسة الرياضة لليوم
            _SectionTitle(
              iconPath: 'assets/images/time_icon.png',
              title: 'عدد دقائق ممارسة الرياضة لليوم',
            ),
            verticalSpacing(8),
            _MetricRow(
              todayValue: '200',
              cumulativeValue: '1500',
            ),

            verticalSpacing(28),

            const _SwitchableSections(),
          ],
        ),
      ),
    );
  }
}

/// ---- UI Components ----

class _SectionTitle extends StatelessWidget {
  final String title;
  final String? iconPath;
  final bool hasGradientBackground;
  const _SectionTitle(
      {required this.title, this.iconPath, this.hasGradientBackground = false});

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

class _MetricRow extends StatelessWidget {
  final String todayValue;
  final String cumulativeValue;

  const _MetricRow({
    required this.todayValue,
    required this.cumulativeValue,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _MetricColumn(
          label: 'اليوم (فعلي)',
          value: todayValue,
          isHighlight: true,
        ),
        _MetricColumn(label: 'تراكمي (فعلي)', value: cumulativeValue),
      ],
    );
  }
}

class _MetricRow3 extends StatelessWidget {
  final String todayValue;
  final String cumulativeValue;
  final String standardValue;
  final String subtitle;

  final bool hasGradientBackground;

  const _MetricRow3({
    required this.todayValue,
    required this.cumulativeValue,
    required this.standardValue,
    required this.subtitle,
    this.hasGradientBackground = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _MetricColumn(
                label: 'اليوم (فعلي)',
                value: todayValue,
                isHighlight: true,
                hasGradientBackground: hasGradientBackground),
            _MetricColumn(
                label: 'تراكمي (فعلي)',
                value: cumulativeValue,
                hasGradientBackground: hasGradientBackground),
            _MetricColumn(
                label: 'تراكمي (معياري)',
                value: standardValue,
                hasGradientBackground: hasGradientBackground),
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

class _MetricColumn extends StatelessWidget {
  final String label;
  final String value;
  final bool isHighlight;
  final bool hasGradientBackground;

  const _MetricColumn({
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
            style: AppTextStyles.font14blackWeight400
                .copyWith(color: Colors.white),
          ),
        ),
        verticalSpacing(6),
        Text(
          value,
          style: TextStyle(
            fontSize: 44.sp,
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
  const _SwitchableSections();

  @override
  State<_SwitchableSections> createState() => _SwitchableSectionsState();
}

class _SwitchableSectionsState extends State<_SwitchableSections> {
  final PageController _pageController = PageController();
  int currentPage = 0;

  final List<Widget> _pages = [
    /// Page 1: السعرات المكتسبة
    _SectionPage(
      title: 'السعرات المكتسبة من الغذاء (الطاقة)',
      iconPath: 'assets/images/food_icon.png',
      todayValue: '200',
      cumulativeValue: '800',
      standardValue: '1200',
      subtitle: 'وفقاً لخطة التغذية المفعلة',
    ),

    /// Page 2: الصيانة العضلية والبناء العضلي (صف واحد - مطابق للتصميم)
    Column(
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
                          '50%',
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
                          '40%',
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
                          '50%',
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
                          '40%',
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

        // ⬇️ باقي الصفحة كما هي (الجهد العضلي للبناء والصيانة)
        _SectionTitle(
          title: 'إجمالي الجهد العضلي للبناء عالي التحمل',
          hasGradientBackground: true,
        ),
        verticalSpacing(8),
        _MetricRow3(
          todayValue: '200',
          cumulativeValue: '800',
          standardValue: '1200',
          subtitle: '',
          hasGradientBackground: true,
        ),
        verticalSpacing(8),
        _SectionTitle(
          title: 'إجمالي الجهد العضلي لصيانة الصحة والبناء',
          hasGradientBackground: true,
        ),
        verticalSpacing(8),
        _MetricRow3(
          todayValue: '200',
          cumulativeValue: '800',
          standardValue: '1200',
          subtitle: '',
          hasGradientBackground: true,
        ),
      ],
    ),

    /// Page 3: الوزن المستهدف + BMI
    Column(
      children: [
        _SectionTitle(
          iconPath: 'assets/images/weight_icon.png',
          title: 'وزن الجسم المستهدف',
          hasGradientBackground: true,
        ),
        verticalSpacing(8),
        _MetricRow3(
          todayValue: '80',
          cumulativeValue: '40',
          standardValue: '90',
          subtitle: '',
          hasGradientBackground: true,
        ),
        verticalSpacing(4),
        _SectionTitle(
          iconPath: 'assets/images/pmi_icon.png',
          title: 'مؤشر كتلة الجسم BMI',
          hasGradientBackground: true,
        ),
        verticalSpacing(8),
        _MetricRow3(
          todayValue: '19',
          cumulativeValue: '25',
          standardValue: '35',
          subtitle: '',
          hasGradientBackground: true,
        ),
      ],
    ),
  ];

  void _nextPage() {
    if (currentPage < _pages.length - 1) {
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
                children: _pages,
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
            if (currentPage < _pages.length - 1)
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

/// =====================
/// 📊 صفحة بثلاث أعمدة (اليوم / تراكمي / معياري)
/// =====================
class _SectionPage extends StatelessWidget {
  final String title;
  final String iconPath;
  final String todayValue;
  final String cumulativeValue;
  final String standardValue;
  final String subtitle;

  const _SectionPage({
    required this.title,
    required this.iconPath,
    required this.todayValue,
    required this.cumulativeValue,
    required this.standardValue,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _SectionTitle(
          iconPath: iconPath,
          title: title,
          hasGradientBackground: true,
        ),
        verticalSpacing(8),
        _MetricRow3(
          todayValue: todayValue,
          cumulativeValue: cumulativeValue,
          standardValue: standardValue,
          subtitle: subtitle,
          hasGradientBackground: true,
        ),
        verticalSpacing(16),

        /// 🔹 Section 3: السعرات المحروقة بالنشاط الرياضي
        _SectionTitle(
          iconPath: 'assets/images/fire_icon.png',
          title: 'السعرات المحروقة بالنشاط الرياضي',
          hasGradientBackground: true,
        ),
        verticalSpacing(8),
        _MetricRow(todayValue: '200', cumulativeValue: '1500'),

        verticalSpacing(40),
      ],
    );
  }
}
