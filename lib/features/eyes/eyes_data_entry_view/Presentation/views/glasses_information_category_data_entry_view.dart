import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/custom_app_bar.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/eyes/eyes_data_entry_view/Presentation/views/essential_glasses_informations_data_entry_tab_view.dart';
import 'package:we_care/features/eyes/eyes_data_entry_view/Presentation/views/right_and_left_tab_view_bar_widget.dart';

class GlassesInformationCategoryDataEntryView extends StatefulWidget {
  const GlassesInformationCategoryDataEntryView({
    super.key,
  });

  @override
  State<GlassesInformationCategoryDataEntryView> createState() =>
      _GlassesInformationCategoryDataEntryViewState();
}

class _GlassesInformationCategoryDataEntryViewState
    extends State<GlassesInformationCategoryDataEntryView>
    with TickerProviderStateMixin {
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
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                CustomAppBarWidget(
                  haveBackArrow: true,
                ),
                verticalSpacing(20),
              ],
            ),
          ),
          // Tab Bar using single TabController instance
          Expanded(
            child: Column(
              children: [
                TabBar(
                  dividerColor: Color(0xff555555),
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicatorPadding: const EdgeInsets.symmetric(horizontal: 16),
                  automaticIndicatorColorAdjustment: false,
                  indicatorWeight: 2.5,
                  tabs: const [
                    Tab(
                      text: 'البيانات الأساسية للنظارة',
                    ),
                    Tab(
                      text: 'بيانات لكل عدسة',
                    ),
                  ],
                  controller: _tabController,
                  labelStyle: AppTextStyles.font18blackWight500.copyWith(
                    fontSize: 16.sp,
                    fontFamily: "Cairo",
                    color: AppColorsManager.mainDarkBlue,
                  ),
                  unselectedLabelStyle:
                      AppTextStyles.font18blackWight500.copyWith(
                    fontSize: 16.sp,
                    fontFamily: "Cairo",
                    color: Color(0xff555555),
                  ),
                  indicatorColor: AppColorsManager.mainDarkBlue,
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 16.h,
                        ),
                        child:
                            const EssenstialGlassesInformationsDataDataEntryTabBar(),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 16.h,
                        ),
                        child: const RightAndLeftLensTabBarView(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
