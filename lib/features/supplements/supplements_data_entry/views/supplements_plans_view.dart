import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/di/dependency_injection.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/appbar_with_centered_title_with_guidance.dart';
import 'package:we_care/core/global/SharedWidgets/module_guidance_alert_dialog.dart';
import 'package:we_care/core/global/SharedWidgets/shared_app_bar_widget.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/supplements/supplements_data_entry/logic/supplements_data_entry_cubit.dart';
import 'package:we_care/features/supplements/supplements_data_entry/logic/supplements_data_entry_state.dart';
import 'package:we_care/features/supplements/supplements_data_entry/views/widgets/monthly_supplements_plan_grid_view_widget.dart';
import 'package:we_care/features/supplements/supplements_data_entry/views/widgets/supplements_plan_activation_switcher_widget.dart';
import 'package:we_care/features/supplements/supplements_data_entry/views/widgets/weekly_supplemnets_plan_grid_view_widget.dart';

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
    return BlocProvider<SupplementsDataEntryCubit>(
      create: (context) {
        final cubit = getIt<SupplementsDataEntryCubit>();
        WidgetsBinding.instance.addPostFrameCallback(
          (_) async {
            await cubit.getAnyActivePlanStatus();
            await cubit.getPlanActivationStatus();
            await cubit.loadExistingPlans();
            await cubit.getTrackedSupplementsAndVitamins();
          },
        );
        return cubit;
      },
      child: BlocListener<SupplementsDataEntryCubit, SupplementsDataEntryState>(
        listenWhen: (prev, curr) =>
            prev.supplementFollowUpCurrentTabIndex !=
            curr.supplementFollowUpCurrentTabIndex,
        listener: (context, state) {
          if (_tabController.index != state.supplementFollowUpCurrentTabIndex) {
            _tabController.animateTo(
              state.supplementFollowUpCurrentTabIndex,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          }
        },
        child: Builder(
          builder: (context) {
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
                    child: BlocBuilder<SupplementsDataEntryCubit,
                        SupplementsDataEntryState>(
                      buildWhen: (previous, current) =>
                          previous.moduleGuidanceData !=
                          current.moduleGuidanceData,
                      builder: (context, state) {
                        return CustomAppBarWithCenteredTitleWithGuidance(
                          title: 'خطة متابعة المكملات',
                          trailingActions: [
                            CircleIconButton(
                              icon: Icons.play_arrow,
                              color: state.moduleGuidanceData?.videoLink
                                          ?.isNotEmpty ==
                                      true
                                  ? AppColorsManager.mainDarkBlue
                                  : Colors.grey,
                              onTap: () {
                                if (state.moduleGuidanceData?.videoLink
                                        ?.isNotEmpty ==
                                    true) {
                                  launchYouTubeVideo(
                                      state.moduleGuidanceData!.videoLink!);
                                }
                              },
                            ),
                            horizontalSpacing(8),
                            CircleIconButton(
                              icon: Icons.menu_book_outlined,
                              color: state.moduleGuidanceData
                                          ?.moduleGuidanceText?.isNotEmpty ==
                                      true
                                  ? AppColorsManager.mainDarkBlue
                                  : Colors.grey,
                              onTap: () {
                                if (state.moduleGuidanceData?.moduleGuidanceText
                                        ?.isNotEmpty ==
                                    true) {
                                  showDialog(
                                    context: context,
                                    builder: (context) =>
                                        ModuleGuidanceAlertDialog(
                                      title: "مكملاتك الغذائية",
                                      description: state.moduleGuidanceData!
                                          .moduleGuidanceText!,
                                    ),
                                  );
                                }
                              },
                            ),
                          ],
                        );
                      },
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
                      labelStyle:
                          AppTextStyles.font16DarkGreyWeight400.copyWith(
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
                      onTap: (index) async {
                        // Call the cubit method when the tab is tapped
                        await context
                            .read<SupplementsDataEntryCubit>()
                            .updateCurrentTab(index);
                      },
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
                        _buildTabContent(isWeeklyPlan: true),
                        // Monthly Plan Tab
                        _buildTabContent(isWeeklyPlan: false),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildTabContent({
    required bool isWeeklyPlan,
  }) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Plan activation toggle
          SupplementsPlanActivationToggleBlocBuilder(),

          verticalSpacing(24),

          // Meal grid (different for weekly vs monthly)
          Expanded(
            child: isWeeklyPlan
                ? WeeklySupplemnetsPlanGridViewWidgt()
                : MonthlySupplementsPlanGridViewWidget(),
          ),
        ],
      ),
    );
  }
}
