import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/SharedWidgets/custom_app_bar_with_centered_title_widget.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/supplements/supplements_data_entry/views/widgets/supplements_grid_view.dart';

class SupplementsPlansView extends StatefulWidget {
  const SupplementsPlansView({super.key});

  @override
  State<SupplementsPlansView> createState() => _SupplementsPlansViewState();
}

class _SupplementsPlansViewState extends State<SupplementsPlansView>
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
              ),
              unselectedLabelStyle:
                  AppTextStyles.font16DarkGreyWeight400.copyWith(
                fontWeight: FontWeight.w400,
                fontFamily: "Cairo",
              ),
              indicatorColor: AppColorsManager.mainDarkBlue,
              indicatorWeight: 3,
              indicatorSize: TabBarIndicatorSize.tab,
              tabs: const [
                Tab(text: 'خطة أسبوعية'),
                Tab(text: 'خطة شهرية'),
              ],
            ),
          ),

          // Tab Content
          Expanded(
            child: TabBarView(
              physics: const BouncingScrollPhysics(),
              controller: _tabController,
              children: [
                // Weekly Plan Tab
                _buildTabContent(itemCount: 7),
                // Monthly Plan Tab
                _buildTabContent(itemCount: 30),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabContent({required int itemCount}) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Supplements Grid
          SupplementsGridView(itemCount: itemCount),
        ],
      ),
    );
  }
}
