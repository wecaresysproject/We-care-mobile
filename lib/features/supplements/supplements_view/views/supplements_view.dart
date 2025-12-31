import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/di/dependency_injection.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/custom_app_bar_with_centered_title_widget.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/supplements/supplements_view/logic/supplements_view_cubit.dart';
import 'package:we_care/features/supplements/supplements_view/logic/supplements_view_state.dart';
import 'package:we_care/features/x_ray/x_ray_view/Presentation/views/widgets/x_ray_data_filters_row.dart';

class SupplementsView extends StatefulWidget {
  const SupplementsView({super.key});

  @override
  State<SupplementsView> createState() => _SupplementsViewState();
}

class _SupplementsViewState extends State<SupplementsView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: 0,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final cubit = getIt<SupplementsViewCubit>();
        cubit.getAvailableDateRanges();
        cubit.fetchEffectsOnNutrients();
        cubit.fetchVitaminsAndSupplements();
        return cubit;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          toolbarHeight: 0.h,
        ),
        body: BlocBuilder<SupplementsViewCubit, SupplementsViewState>(
          builder: (context, state) {
            return Column(
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: const AppBarWithCenteredTitle(
                    title: 'المكملات الغذائية',
                    showActionButtons: false,
                    hasVideoIcon: true,
                  ),
                ),

                // Custom Tab Bar
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16.0),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.grey[300]!,
                        width: 1,
                      ),
                    ),
                  ),
                  child: TabBar(
                    controller: _tabController,
                    labelColor: AppColorsManager.mainDarkBlue,
                    unselectedLabelColor: AppColorsManager.placeHolderColor,
                    labelStyle: AppTextStyles.font16DarkGreyWeight400.copyWith(
                      fontWeight: FontWeight.w400,
                      fontFamily: "Cairo",
                      fontSize: 13.sp,
                    ),
                    unselectedLabelStyle:
                        AppTextStyles.font16DarkGreyWeight400.copyWith(
                      fontWeight: FontWeight.w400,
                      fontFamily: "Cairo",
                      fontSize: 13.sp,
                    ),
                    indicatorColor: AppColorsManager.mainDarkBlue,
                    indicatorWeight: 3,
                    indicatorSize: TabBarIndicatorSize.tab,
                    tabs: const [
                      Tab(text: 'الفيتامينات والمكملات'),
                      Tab(text: 'التأثير على العناصر الغذائية'),
                    ],
                  ),
                ),

                // Tab Content
                Expanded(
                  child: TabBarView(
                    physics: const BouncingScrollPhysics(),
                    controller: _tabController,
                    children: [
                      _buildTabContent(tabNumber: 1, state: state),
                      _buildTabContent(tabNumber: 2, state: state),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildTabContent(
      {required int tabNumber, required SupplementsViewState state}) {
    return Builder(
      builder: (context) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            children: [
              DataViewFiltersRow(
                onFilterSelected: (filter, _) {},
                onApply: (selectedFilter) {
                  if (tabNumber == 1) {
                    context
                        .read<SupplementsViewCubit>()
                        .fetchVitaminsAndSupplements(
                            range: selectedFilter["التاريخ"]);
                  } else {
                    context
                        .read<SupplementsViewCubit>()
                        .fetchEffectsOnNutrients(
                          range: selectedFilter["التاريخ"],
                        );
                  }
                },
                filters: [
                  FilterConfig(
                    title: 'التاريخ',
                    options: state.availableDateRanges.isNotEmpty
                        ? state.availableDateRanges
                        : [],
                  )
                ],
              ),
              verticalSpacing(16),
              if (tabNumber == 1)
                _buildVitaminsAndSupplementsTable(state: state)
              else
                _buildEffectsOnNutrientsTable(state: state)
            ],
          ),
        );
      },
    );
  }

  Widget _buildVitaminsAndSupplementsTable(
      {required SupplementsViewState state}) {
    // Loading state
    if (state.vitaminsAndSupplementsStatus == RequestStatus.loading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32.0),
          child: CircularProgressIndicator(),
        ),
      );
    }

    // Error state
    if (state.vitaminsAndSupplementsStatus == RequestStatus.failure) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 48.sp,
              ),
              const SizedBox(height: 16),
              Text(
                state.responseMessage.isNotEmpty
                    ? state.responseMessage
                    : "حدث خطأ أثناء تحميل البيانات",
                style: AppTextStyles.font14BlueWeight700.copyWith(
                  color: Colors.red,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    // Empty state or no data
    if (state.vitaminsAndSupplementsData == null ||
        state.vitaminsAndSupplementsData!.supplements.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Text(
            "لا يوجد بيانات ادخال",
            style: AppTextStyles.font16DarkGreyWeight400.copyWith(
              color: AppColorsManager.placeHolderColor,
            ),
          ),
        ),
      );
    }

    // Success state with data - build dynamic table
    final data = state.vitaminsAndSupplementsData!;
    final supplements = data.supplements;
    final elements = data.elements;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        headingRowColor: WidgetStateProperty.all(AppColorsManager.mainDarkBlue),
        columnSpacing: 12.w,
        dataRowMaxHeight: 50,
        horizontalMargin: 12.w,
        dividerThickness: 0.83,
        headingTextStyle: AppTextStyles.font16DarkGreyWeight400.copyWith(
          color: AppColorsManager.backGroundColor,
          fontWeight: FontWeight.w600,
          fontSize: 13.sp,
        ),
        headingRowHeight: 70,
        showBottomBorder: true,
        border: TableBorder.all(
          style: BorderStyle.solid,
          borderRadius: BorderRadius.circular(8),
          color: AppColorsManager.mainDarkBlue,
          width: 0.3,
        ),
        columns: [
          DataColumn(
            label: SizedBox(
              width: 80.w,
              child: const Center(
                child: Text(
                  "العنصر",
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          ...supplements.map(
            (supplement) => DataColumn(
              label: SizedBox(
                width: 70.w,
                child: Center(
                  child: Text(
                    supplement.name,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),
          ),
        ],
        rows: elements.map((element) {
          // Create value lookup map
          final valueMap = {
            for (var value in element.values) value.name: value.amount
          };

          return DataRow(
            cells: [
              _cell(element.elementName, isElementNameCell: true),
              ...supplements.map(
                (supplement) => _cell(valueMap[supplement.name] ?? "--"),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  DataCell _cell(String text, {bool isElementNameCell = false}) {
    return DataCell(
      Center(
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: AppTextStyles.font12blackWeight400.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: 13.sp,
            color: isElementNameCell
                ? AppColorsManager.mainDarkBlue
                : Colors.black,
          ),
        ),
      ),
    );
  }

  Widget _buildEffectsOnNutrientsTable({
    required SupplementsViewState state,
  }) {
    // Loading state
    if (state.effectsOnNutrientsStatus == RequestStatus.loading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32.0),
          child: CircularProgressIndicator(),
        ),
      );
    }

    // Error state
    if (state.effectsOnNutrientsStatus == RequestStatus.failure) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 48.sp,
              ),
              const SizedBox(height: 16),
              Text(
                state.responseMessage.isNotEmpty
                    ? state.responseMessage
                    : "حدث خطأ أثناء تحميل البيانات",
                style: AppTextStyles.font14BlueWeight700.copyWith(
                  color: Colors.red,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    // Empty state
    if (state.effectsOnNutrientsList.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Text(
            "لا يوجد بيانات ادخال",
            style: AppTextStyles.font16DarkGreyWeight400.copyWith(
              color: AppColorsManager.placeHolderColor,
            ),
          ),
        ),
      );
    }

    // Success state with data
    return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          clipBehavior: Clip.antiAliasWithSaveLayer,
          headingRowColor:
              WidgetStateProperty.all(AppColorsManager.mainDarkBlue),
          columnSpacing: 14.w,
          dataRowMaxHeight: 50,
          horizontalMargin: 14.w,
          dividerThickness: 0.83,
          headingTextStyle: AppTextStyles.font16DarkGreyWeight400.copyWith(
            color: AppColorsManager.backGroundColor,
            fontWeight: FontWeight.w600,
            fontSize: 13.sp,
          ),
          headingRowHeight: 70,
          showBottomBorder: true,
          border: TableBorder.all(
            style: BorderStyle.solid,
            borderRadius: BorderRadius.circular(8),
            color: AppColorsManager.mainDarkBlue,
            width: 0.3,
          ),
          columns: [
            DataColumn(
              label: SizedBox(
                width: 80.w,
                child: const Center(
                  child: Text(
                    "العنصر",
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            DataColumn(
              label: SizedBox(
                width: 80.w,
                child: const Center(
                  child: Text(
                    "متوسط  \nالكمية \n عبر الغذاء",
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            DataColumn(
              label: SizedBox(
                width: 75.w,
                child: const Center(
                  child: Text(
                    "الكمية  \nالمعيارية",
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            DataColumn(
              label: SizedBox(
                width: 75.w,
                child: const Center(
                  child: Text(
                    "الزيادة\n (النقص)",
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            DataColumn(
              label: SizedBox(
                width: 75.w,
                child: const Center(
                  child: Text(
                    "الكمية من \n الفايتمين",
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            DataColumn(
              label: SizedBox(
                width: 85.w,
                child: const Center(
                  child: Text(
                    "الزيادة/النقص \n بعد الفايتمين",
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ],
          rows: state.effectsOnNutrientsList.map((item) {
            return DataRow(
              cells: [
                _cell(item.nutrient ?? "N/A", isElementNameCell: true),
                _cell(item.standard?.toStringAsFixed(2) ?? "N/A"),
                _cell(item.accumulativeStandard?.toStringAsFixed(2) ?? "N/A"),
                _cell(item.difference?.toStringAsFixed(2) ?? "N/A"),
                _cell(item.value?.toStringAsFixed(2) ?? "N/A"),
                _cell(
                    item.differenceAfterVitamins?.toStringAsFixed(2) ?? "N/A"),
              ],
            );
          }).toList(),
        ));
  }
}
