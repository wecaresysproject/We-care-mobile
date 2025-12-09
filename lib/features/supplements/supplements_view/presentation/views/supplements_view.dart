import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/custom_app_bar_with_centered_title_widget.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/x_ray/x_ray_view/Presentation/views/widgets/x_ray_data_filters_row.dart';

class SupplementsView extends StatefulWidget {
  const SupplementsView({super.key});

  @override
  State<SupplementsView> createState() => _SupplementsViewState();
}

class _SupplementsViewState extends State<SupplementsView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final mockData = [
    "حديد",
    "صوديوم",
    "فيتامين د",
    "فيتامين سي",
    "زنك",
    "ماغنسيوم",
    "كالسيوم",
    "صوديوم",
    "فوليك اسيد",
    "زنك",
    "فوليك اسيد",
    "حديد",
  ];
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
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        toolbarHeight: 0.h,
      ),
      body: Column(
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
                _buildTabContent(tabNumber: 1),
                _buildTabContent(tabNumber: 2),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabContent({required int tabNumber}) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(18.0),
      child: Column(
        children: [
          DataViewFiltersRow(
            onFilterSelected: (filter, _) {},
            onApply: (_) {},
            filters: [
              FilterConfig(
                  title: 'التاريخ',
                  options: ['من 1/7/2025 الي 8/7/2025', 'من 1/7/2025 الي 8/7/2025', 'من 1/7/2025 الي 8/7/2025', 'من 1/7/2025 الي 8/7/2025'])
            ],
          ),
          verticalSpacing(16),
          if (tabNumber == 1)
            _buildVitaminsAndSupplementsTable(elements: mockData)
          else
            _buildEffectsOnNutrientsTable(
              elements: mockData,
            )
        ],
      ),
    );
  }

  Widget _buildVitaminsAndSupplementsTable({required List<String> elements}) {
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
          DataColumn(
            label: SizedBox(
              width: 70.w,
              child: const Center(
                child: Text(
                  "Centrum",
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          DataColumn(
            label: SizedBox(
              width: 70.w,
              child: const Center(
                child: Text(
                  "Omega-3\nPlus",
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          DataColumn(
            label: SizedBox(
              width: 70.w,
              child: const Center(
                child: Text(
                  "Redoxon\nVitamin C",
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          DataColumn(
            label: SizedBox(
              width: 70.w,
              child: const Center(
                child: Text(
                  "Calci\nMax",
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
                  "Feroglobin",
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ],
        rows: elements.map((item) {
          return DataRow(
            cells: [
              _cell(item, isElementNameCell: true),
              _cell("1200"),
              _cell("1200"),
              _cell("1200"),
              _cell("200"),
              _cell("200"),
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

  Widget _buildEffectsOnNutrientsTable({required List<String> elements}) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      headingRowColor: WidgetStateProperty.all(AppColorsManager.mainDarkBlue),
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
      rows: elements.map((item) {
        return DataRow(
          cells: [
            _cell(item, isElementNameCell: true),
            _cell("1200"),
            _cell("1200"),
            _cell("1200"),
            _cell("200"),
            _cell("200"),
          ],
        );
      }).toList(),
    ) );
  }
}
