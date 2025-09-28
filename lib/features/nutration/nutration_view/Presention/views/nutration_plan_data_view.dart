import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/di/dependency_injection.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/custom_app_bar_with_centered_title_widget.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/core/routing/routes.dart';
import 'package:we_care/features/nutration/nutration_view/logic/nutration_view_cubit.dart';
import 'package:we_care/features/x_ray/x_ray_view/Presentation/views/widgets/x_ray_data_filters_row.dart';

class NutrationPlanDataView extends StatefulWidget {
  const NutrationPlanDataView({super.key});

  @override
  NutrationPlanDataViewState createState() => NutrationPlanDataViewState();
}

class NutrationPlanDataViewState extends State<NutrationPlanDataView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

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

  @override
  Widget build(BuildContext context) {
    return BlocProvider<NutrationViewCubit>(
      create: (context) => getIt<NutrationViewCubit>()..getIntialRequests(),
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
        ),
        body: Column(
          children: [
            // Tab Bar Section
            Container(
              color: Colors.white,
              child: Column(
                children: [
                  AppBarWithCenteredTitle(
                    title: 'خطة المتابعة',
                    showActionButtons: false,
                  ).paddingSymmetricHorizontal(16),
                  verticalSpacing(5),
                  _buildTabBar().paddingSymmetricHorizontal(16),
                  verticalSpacing(24),
                ],
              ),
            ),
            // Tab View Content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // Weekly Plan
                  _buildWeeklyMealPlanGrid(),
                  // Monthly Plan
                  _buildMonthlyMealPlanGrid(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    return TabBar(
      labelStyle: AppTextStyles.font16DarkGreyWeight400.copyWith(
        color: AppColorsManager.mainDarkBlue,
        fontFamily: 'Cairo',
      ),
      tabs: const [
        Tab(
          text: 'خطة أسبوعية',
        ),
        Tab(
          text: 'خطة شهرية',
        ),
      ],
      controller: _tabController,
      indicatorSize: TabBarIndicatorSize.tab,
      indicatorColor: AppColorsManager.mainDarkBlue,
    );
  }

  Widget _buildMonthlyMealPlanGrid() {
    return BlocBuilder<NutrationViewCubit, NutrationViewState>(
      buildWhen: (previous, current) =>
          previous.monthlyPlanYearsFilter != current.monthlyPlanYearsFilter ||
          previous.monthlyPlanDateRangesFilter !=
              current.monthlyPlanDateRangesFilter,
      builder: (context, state) {
        return Column(
          children: [
            // Filter row for this tab
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: DataViewFiltersRow(
                filters: [
                  FilterConfig(
                    title: "السنة",
                    options: state.monthlyPlanYearsFilter,
                  ), // state.yearsFilter ?? []),
                  FilterConfig(
                    title: "التاريخ",
                    options: state.monthlyPlanDateRangesFilter,
                  ), // state.procedureTypeFilter ?? []),
                ],
                onApply: (selectedOption) {
                  // context
                  //     .read<DentalViewCubit>()
                  //     .getFilteredToothDocuments(
                  //       year: selectedOption['السنة'] as int?,
                  //       procedureType:
                  //           selectedOption["نوع الاجراء الطبي"]
                  //               as String?,
                  //       toothNumber:
                  //           selectedOption['رقم السن'] as String?,
                  //     );
                },
              ),
            ),
            verticalSpacing(20),
            // Grid content
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.85,
                    mainAxisExtent: 220.h,
                  ),
                  itemCount: 3,
                  itemBuilder: (context, index) {
                    return _buildMealCard(index);
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildWeeklyMealPlanGrid() {
    return BlocBuilder<NutrationViewCubit, NutrationViewState>(
      buildWhen: (previous, current) =>
          previous.weaklyPlanYearsFilter != current.weaklyPlanYearsFilter ||
          previous.weeklyPlanDateRangesFilter !=
              current.weeklyPlanDateRangesFilter,
      builder: (context, state) {
        return Column(
          children: [
            // Filter row for this tab
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: DataViewFiltersRow(
                filters: [
                  FilterConfig(
                    title: "السنة",
                    options: state.weaklyPlanYearsFilter,
                  ), // state.yearsFilter ?? []),
                  FilterConfig(
                    title: "التاريخ",
                    options: state.weeklyPlanDateRangesFilter,
                  ), // state.procedureTypeFilter ?? []),
                ],
                onApply: (selectedOption) {
                  // context
                  //     .read<DentalViewCubit>()
                  //     .getFilteredToothDocuments(
                  //       year: selectedOption['السنة'] as int?,
                  //       procedureType:
                  //           selectedOption["نوع الاجراء الطبي"]
                  //               as String?,
                  //       toothNumber:
                  //           selectedOption['رقم السن'] as String?,
                  //     );
                },
              ),
            ),
            verticalSpacing(20),
            // Grid content
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.85,
                    mainAxisExtent: 220.h,
                  ),
                  itemCount: 3,
                  itemBuilder: (context, index) {
                    return _buildMealCard(index);
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildMealCard(int index) {
    List<Map<String, dynamic>> mealData = [
      {
        'name': 'الألياف',
        'subtitle': '(جم)',
        'consumed': 50,
        'standard': 100,
        'difference': 50,
        'percentage': 15,
        'hasPercentage': true,
      },
      {
        'name': 'الألياف',
        'subtitle': '(جم)',
        'consumed': 120,
        'standard': 80,
        'difference': 40,
        'percentage': 50,
        'hasPercentage': true,
      },
      {
        'name': 'الألياف',
        'subtitle': '(جم)',
        'consumed': 120,
        'standard': 120,
        'difference': 0,
        'percentage': null,
        'hasPercentage': false,
      },
    ];

    Map<String, dynamic> meal = mealData[index % mealData.length];
    // Calculate comparison and colors
    int consumed = meal['consumed'];
    int standard = meal['standard'];
    bool isConsumedHigher = consumed > standard;
    bool isConsumedEqual = consumed == standard;

    // Color configuration based on comparison
    Color borderColor = isConsumedHigher
        ? AppColorsManager.doneColor // Green when consumed > standard
        : isConsumedEqual
            ? AppColorsManager.mainDarkBlue // Amber when consumed == standard
            : Color(0xFFE53E3E); // Red when consumed < standard

    Color accentColor = isConsumedHigher
        ? Color(0xFF00C896) // Green
        : Color(0xFFE53E3E); // Red

    String statusMessage =
        isConsumedHigher ? 'أعلى من المستهدف' : 'أقل من المستهدف';

    IconData arrowIcon =
        !isConsumedHigher ? Icons.arrow_upward : Icons.arrow_downward;

    return Container(
      padding: EdgeInsets.fromLTRB(2.w, 8.h, 2.w, 0),
      decoration: BoxDecoration(
        color: Color(0xffF1F3F6),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: borderColor,
          width: meal['hasPercentage'] ? 3 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Header with buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildActionButton(
                text: 'بدائل غذائية',
                onTap: () async {
                  await context.pushNamed(Routes.foodAlternativesView);
                },
              ),
              _buildActionButton(
                text: 'توصيات',
                onTap: () {},
              ),
            ],
          ),
          !isConsumedEqual ? verticalSpacing(9) : verticalSpacing(20),

          // Title
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                meal['name'],
                textAlign: TextAlign.end,
                style: AppTextStyles.font18blackWight500.copyWith(
                  color: AppColorsManager.mainDarkBlue,
                  fontSize: 16.sp,
                ),
              ),
              horizontalSpacing(8),
              // Percentage indicator (if exists)
              if (meal['hasPercentage'])
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.h),
                  margin: EdgeInsets.only(right: 15),
                  decoration: BoxDecoration(
                    color: borderColor,
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${meal['percentage']}%',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14.sp,
                        ),
                      ),
                      horizontalSpacing(4),
                      Icon(
                        arrowIcon,
                        color: Colors.white,
                        size: 16,
                      ),
                    ],
                  ),
                ),
            ],
          ),
          Text(
            meal['subtitle'],
            style: AppTextStyles.font18blackWight500.copyWith(
              color: AppColorsManager.mainDarkBlue,
              fontSize: 16.sp,
            ),
            textAlign: TextAlign.center,
          ),

          isConsumedEqual ? verticalSpacing(40) : verticalSpacing(20),

          // Nutrition Info
          Column(
            children: [
              _buildNutritionRow('الكمية المستهلكة:', '${meal['consumed']}'),
              verticalSpacing(8),
              _buildNutritionRow('الكمية المعيارية:', '${meal['standard']}'),
              verticalSpacing(8),
              if (!isConsumedEqual) ...[
                _buildDifferenceIndicator(
                  label: 'الفرق',
                  value: '${meal['difference']}',
                  backgroundColor: accentColor,
                ),
                verticalSpacing(3),
                _buildTextWithIcon(
                  backgroundColor: accentColor,
                  icon: arrowIcon,
                  label: statusMessage,
                ),
              ] else ...[
                _buildNutritionRow('الفرق:', '${meal['consumed']}'),
              ],
            ],
          ).paddingSymmetricHorizontal(4),
        ],
      ),
    );
  }

  Widget _buildDifferenceIndicator({
    required String label,
    required String value,
    required Color backgroundColor,
  }) {
    return Container(
      height: 22.h,
      padding: EdgeInsets.fromLTRB(8, 2, 8, 2),
      margin: EdgeInsets.zero,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTextStyles.font14BlueWeight700.copyWith(
              color: Colors.white,
              fontSize: 13.sp,
            ),
          ),
          Text(
            value,
            style: AppTextStyles.font14BlueWeight700.copyWith(
              color: Colors.white,
              fontSize: 13.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextWithIcon({
    required String label,
    required IconData icon,
    required Color backgroundColor,
  }) {
    return Container(
      height: 22.h,
      padding: EdgeInsets.fromLTRB(8, 2, 0, 2),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: Colors.white,
            size: 14,
          ),
          Spacer(),
          Text(
            label,
            style: AppTextStyles.font14BlueWeight700.copyWith(
              color: Colors.white,
              fontSize: 13.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required String text,
    required void Function()? onTap,
  }) {
    return GestureDetector(
      onTap: () => onTap?.call(),
      child: Container(
        height: 28.h,
        padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 4.h),
        margin: EdgeInsets.only(left: 3.w, right: 0.w),
        decoration: BoxDecoration(
          color: AppColorsManager.mainDarkBlue,
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text,
              textAlign: TextAlign.center,
              style: AppTextStyles.font12blackWeight400.copyWith(
                fontWeight: FontWeight.w700,
                color: Colors.white,
                fontSize: 11.sp,
              ),
            ),
            horizontalSpacing(4),
            Icon(
              Icons.arrow_forward,
              color: Colors.white,
              size: 14,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNutritionRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTextStyles.font14whiteWeight600.copyWith(
            color: AppColorsManager.mainDarkBlue,
            fontSize: 13.sp,
          ),
        ),
        Text(
          value,
          style: AppTextStyles.font14whiteWeight600.copyWith(
            color: AppColorsManager.mainDarkBlue,
            fontSize: 13.sp,
          ),
        ),
      ],
    );
  }
}
