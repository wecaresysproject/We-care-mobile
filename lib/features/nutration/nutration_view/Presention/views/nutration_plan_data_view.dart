import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/di/dependency_injection.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/app_logger.dart';
import 'package:we_care/core/global/Helpers/app_toasts.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/custom_app_bar_with_centered_title_widget.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/core/routing/routes.dart';
import 'package:we_care/features/nutration/data/models/nutration_document_model.dart';
import 'package:we_care/features/nutration/nutration_data_entry/Presentation/views/widgets/custom_gradient_button_widget.dart';
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
      child: Stack(
        children: [
          Scaffold(
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
          // --- الزرين في أسفل اليمين ---
          Positioned(
            bottom: 20.h,
            right: 16.w,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              spacing: 24,
              children: [
                GradientButton(
                  text: "تقرير المتابعة",
                  icon: Icons.insert_chart_outlined,
                  onPressed: () async {
                    // TODO: Add your logic here
                    // await context.pushNamed(Routes.followUpReportView);
                  },
                ),
                GradientButton(
                  text: "التأثير على الأعضاء",
                  icon: Icons.person,
                  onPressed: () async {
                    await context.pushNamed(Routes.effectOnBodyOrgans);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Builder(builder: (context) {
      return TabBar(
        onTap: (index) async {
          // Call the cubit method when the tab is tapped
          await context.read<NutrationViewCubit>().updateCurrentTab(index);
        },
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
    });
  }

  Widget _buildMonthlyMealPlanGrid() {
    return BlocBuilder<NutrationViewCubit, NutrationViewState>(
      buildWhen: (previous, current) =>
          previous.monthlyPlanYearsFilter != current.monthlyPlanYearsFilter ||
          previous.monthlyPlanDateRangesFilter !=
              current.monthlyPlanDateRangesFilter ||
          previous.requestStatus != current.requestStatus ||
          previous.monthlyNutrationDocuments !=
              current.monthlyNutrationDocuments,
      builder: (context, state) {
        Widget content;

        switch (state.requestStatus) {
          case RequestStatus.loading:
            content = const Center(
              child: CircularProgressIndicator(),
            );
            break;

          case RequestStatus.success:
            if (state.monthlyNutrationDocuments.isEmpty) {
              content = Center(
                child: Text(
                  "الخطة غير مفعلة أو لا توجد بيانات للعرض.",
                  style: AppTextStyles.font16DarkGreyWeight400,
                ),
              );
            } else {
              content = GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.85,
                  mainAxisExtent: 220.h,
                ),
                itemCount: state.monthlyNutrationDocuments.length,
                itemBuilder: (context, index) {
                  final nutrationDocument =
                      state.monthlyNutrationDocuments[index];
                  return _buildNutrationCard(nutrationDocument);
                },
              );
            }
            break;

          case RequestStatus.failure:
            content = Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("حدث خطأ أثناء تحميل البيانات"),
                  verticalSpacing(10),
                  ElevatedButton(
                    onPressed: () {
                      context
                          .read<NutrationViewCubit>()
                          .getNutrationDocuments();
                    },
                    child: Text(
                      "إعادة المحاولة",
                      style: AppTextStyles.font14whiteWeight600,
                    ),
                  ),
                ],
              ),
            );
            break;

          default:
            content = const SizedBox.shrink();
        }

        return Column(
          children: [
            // Filter row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: DataViewFiltersRow(
                onFilterSelected: (filterTitle, selectedVal) {
                  if (filterTitle == "السنة") {
                    context
                        .read<NutrationViewCubit>()
                        .getAvailableDateRangesForMonthlyPlan(selectedVal);
                  }
                },
                filters: [
                  FilterConfig(
                    title: "السنة",
                    options: state.monthlyPlanYearsFilter,
                  ),
                  FilterConfig(
                    title: "التاريخ",
                    options: state.monthlyPlanDateRangesFilter,
                  ),
                ],
                onApply: (selectedOption) async {
                  if (selectedOption.isNotEmpty &&
                      selectedOption.containsKey("التاريخ") &&
                      selectedOption.containsKey("السنة") &&
                      selectedOption["التاريخ"].toString().isNotEmpty &&
                      selectedOption["السنة"].toString().isNotEmpty) {
                    await context
                        .read<NutrationViewCubit>()
                        .getFilterdNutritionDocuments(
                          rangeDate: selectedOption["التاريخ"],
                          year: selectedOption["السنة"].toString(),
                        );
                  } else {
                    await showError("اختر السنة والتاريخ اولا من فضلك");
                  }
                },
              ),
            ),
            verticalSpacing(20),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: content,
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
              current.weeklyPlanDateRangesFilter ||
          previous.requestStatus != current.requestStatus ||
          previous.weeklyNutrationDocuments != current.weeklyNutrationDocuments,
      builder: (context, state) {
        Widget content;

        switch (state.requestStatus) {
          case RequestStatus.loading:
            content = const Center(
              child: CircularProgressIndicator(),
            );
            break;

          case RequestStatus.success:
            if (state.weeklyNutrationDocuments.isEmpty) {
              content = Center(
                child: Text(
                  "الخطة غير مفعلة أو لا توجد بيانات للعرض.",
                  style: AppTextStyles.font16DarkGreyWeight400,
                ),
              );
            } else {
              content = GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.85,
                  mainAxisExtent: 220.h,
                ),
                itemCount: state.weeklyNutrationDocuments.length,
                itemBuilder: (context, index) {
                  final nutrationElementDocument =
                      state.weeklyNutrationDocuments[index];

                  return _buildNutrationCard(nutrationElementDocument);
                },
              );
            }
            break;

          case RequestStatus.failure:
            content = Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("حدث خطأ أثناء تحميل البيانات"),
                  verticalSpacing(10),
                  ElevatedButton(
                    onPressed: () {
                      context
                          .read<NutrationViewCubit>()
                          .getNutrationDocuments();
                    },
                    child: Text(
                      "إعادة المحاولة",
                      style: AppTextStyles.font14whiteWeight600,
                    ),
                  ),
                ],
              ),
            );
            break;

          default:
            content = const SizedBox.shrink();
        }

        return Column(
          children: [
            // Filter row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: DataViewFiltersRow(
                onFilterSelected: (filterTitle, selectedVal) async {
                  if (filterTitle == "السنة") {
                    AppLogger.info("السنه : $selectedVal");
                    await context
                        .read<NutrationViewCubit>()
                        .getAvailableDateRangesForWeeklyPlan(selectedVal);
                  }
                },
                filters: [
                  FilterConfig(
                    title: "السنة",
                    options: state.weaklyPlanYearsFilter,
                  ),
                  FilterConfig(
                    title: "التاريخ",
                    options: state.weeklyPlanDateRangesFilter,
                  ),
                ],
                onApply: (selectedOption) async {
                  if (selectedOption.isNotEmpty &&
                      selectedOption.containsKey("التاريخ") &&
                      selectedOption.containsKey("السنة") &&
                      selectedOption["التاريخ"].toString().isNotEmpty &&
                      selectedOption["السنة"].toString().isNotEmpty) {
                    await context
                        .read<NutrationViewCubit>()
                        .getFilterdNutritionDocuments(
                          rangeDate: selectedOption["التاريخ"],
                          year: selectedOption["السنة"].toString(),
                        );
                  } else {
                    await showError("اختر السنة والتاريخ اولا من فضلك");
                  }
                },
              ),
            ),
            verticalSpacing(20),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: content,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildNutrationCard(NutrationDocument doc) {
    String shortenedName = doc.nutrient.split(" ").take(2).join(" ");
    final int consumed = doc.accumulativeActual.toInt();
    final int standard = doc.accumulativeStandard.toInt();
    final int difference = doc.difference.toInt();
    final double? percentage = doc.hasPercentage ? doc.percentage : null;

    // Calculate comparison and colors
    bool isConsumedHigher = consumed > standard;
    bool isConsumedEqual = consumed == standard;

    // Color configuration based on comparison
    Color borderColor = isConsumedHigher
        ? AppColorsManager.doneColor // Green when consumed > standard
        : isConsumedEqual
            ? AppColorsManager.mainDarkBlue // Blue when consumed == standard
            : const Color(0xFFE53E3E); // Red when consumed < standard

    Color accentColor = isConsumedHigher
        ? const Color(0xFF00C896) // Green
        : const Color(0xFFE53E3E); // Red

    String statusMessage =
        isConsumedHigher ? 'أعلى من المستهدف' : 'أقل من المستهدف';

    IconData arrowIcon =
        !isConsumedHigher ? Icons.arrow_upward : Icons.arrow_downward;

    return Container(
      padding: EdgeInsets.fromLTRB(2.w, 8.h, 2.w, 0),
      decoration: BoxDecoration(
        color: const Color(0xffF1F3F6),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: borderColor,
          width: doc.hasPercentage ? 3 : 1,
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
                  await context.pushNamed(
                    Routes.foodAlternativesView,
                    arguments: doc.nutrient,
                  );
                },
              ),
              _buildActionButton(
                text: 'توصيات',
                onTap: () async {
                  await context.pushNamed(
                    Routes.foodRecomendationView,
                    arguments: doc.nutrient,
                  );
                },
              ),
            ],
          ),
          !isConsumedEqual ? verticalSpacing(9) : verticalSpacing(20),

          // Title
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: AutoSizeText(
                  shortenedName,
                  textAlign: TextAlign.end,
                  style: AppTextStyles.font18blackWight500.copyWith(
                    color: AppColorsManager.mainDarkBlue,
                    fontSize: 16.sp,
                  ),
                  maxLines: 1, // يخليه سطر واحد
                  minFontSize: 12, // أقل حجم خط ممكن يوصل له
                  overflow:
                      TextOverflow.ellipsis, // يحط ... لو الاسم أطول من كده
                ),
              ),

              horizontalSpacing(8),
              // Percentage indicator (if exists)
              if (doc.hasPercentage && percentage != null)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.h),
                  margin: const EdgeInsets.only(right: 15),
                  decoration: BoxDecoration(
                    color: borderColor,
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${percentage.toStringAsFixed(0)}%',
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
            "(جم)",
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
              _buildNutritionRow('الكمية المستهلكة:', '$consumed'),
              verticalSpacing(8),
              _buildNutritionRow('الكمية المعيارية:', '$standard'),
              verticalSpacing(8),
              if (!isConsumedEqual) ...[
                _buildDifferenceIndicator(
                  label: 'الفرق',
                  value: '$difference',
                  backgroundColor: accentColor,
                ),
                verticalSpacing(3),
                _buildTextWithIcon(
                  backgroundColor: accentColor,
                  icon: arrowIcon,
                  label: statusMessage,
                ),
              ] else ...[
                _buildNutritionRow('الفرق:', '$consumed'),
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
