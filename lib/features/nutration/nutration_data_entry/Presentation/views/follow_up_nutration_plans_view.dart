import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/di/dependency_injection.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/app_custom_button.dart';
import 'package:we_care/core/global/SharedWidgets/custom_app_bar_with_centered_title_widget.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/nutration/data/repos/nutration_data_entry_repo.dart';
import 'package:we_care/features/nutration/nutration_data_entry/Presentation/views/widgets/instruction_text_widget.dart';
import 'package:we_care/features/nutration/nutration_data_entry/Presentation/views/widgets/monthly_plan_grid_view_widget.dart';
import 'package:we_care/features/nutration/nutration_data_entry/Presentation/views/widgets/plan_activation_toggle_switch_widget.dart';
import 'package:we_care/features/nutration/nutration_data_entry/Presentation/views/widgets/weakly_plan_grid_view_widget.dart';
import 'package:we_care/features/nutration/nutration_data_entry/logic/cubit/nutration_data_entry_cubit.dart';

class FollowUpNutrationPlansView extends StatefulWidget {
  const FollowUpNutrationPlansView({super.key});

  @override
  State<FollowUpNutrationPlansView> createState() =>
      _FollowUpNutrationPlansViewState();
}

class _FollowUpNutrationPlansViewState extends State<FollowUpNutrationPlansView>
    with SingleTickerProviderStateMixin {
  // TabController for managing tabs
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
    return BlocProvider<NutrationDataEntryCubit>(
      create: (context) =>
          NutrationDataEntryCubit(getIt<NutrationDataEntryRepo>(), context)
            ..getPlanActivationStatus()
            ..loadExistingPlans(),
      child: Builder(
        builder: (BuildContext context) {
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
                    title: 'خطة المتابعة',
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
                    onTap: (index) async {
                      // Call the cubit method when the tab is tapped
                      await context
                          .read<NutrationDataEntryCubit>()
                          .updateCurrentTab(index);
                    },
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
                      _buildTabContent(
                        isWeeklyPlan: true,
                        messageController: context
                            .read<NutrationDataEntryCubit>()
                            .weeklyMessageController,
                      ),
                      // Monthly Plan Tab
                      _buildTabContent(
                        isWeeklyPlan: false,
                        messageController: context
                            .read<NutrationDataEntryCubit>()
                            .monthlyMessageController,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTabContent({
    required bool isWeeklyPlan,
    required TextEditingController messageController,
  }) {
    return Column(
      children: [
        // Scrollable content area
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16),
            child: Column(
              children: [
                // Plan activation toggle
                PlanActivationToggleBlocBuilder(),

                verticalSpacing(24),

                // Meal grid (different for weekly vs monthly)
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.34,
                  child: isWeeklyPlan
                      ? WeeklyMealGridBLocBuilder()
                      : MonthlyMealGridBlocBuilder(),
                ),

                // Instruction text
                const InstructionText(),

                verticalSpacing(16),
              ],
            ),
          ),
        ),

        // Fixed bottom section that stays above keyboard
        Container(
          padding: EdgeInsets.fromLTRB(
            16.0,
            8.0,
            16.0,
            16.0 + MediaQuery.of(context).viewInsets.bottom,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              top: BorderSide(
                color: Colors.grey[200]!,
                width: 1,
              ),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              // Message input and voice button
              MessageInputSection(controller: messageController),

              verticalSpacing(12),

              BlocBuilder<NutrationDataEntryCubit, NutrationDataEntryState>(
                builder: (context, state) {
                  if (state.submitNutrationDataStatus ==
                      RequestStatus.loading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    ).paddingFrom(right: 200);
                  }

                  return AppCustomButton(
                    title: 'حفظ',
                    isEnabled: true,
                    onPressed: () async {
                      // Call the new analyzeDietPlan method
                      await context
                          .read<NutrationDataEntryCubit>()
                          .analyzeDietPlan();

                      // Show result message
                      if (context.mounted) {
                        if (state.message.isNotEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(state.message),
                              backgroundColor:
                                  state.submitNutrationDataStatus ==
                                          RequestStatus.success
                                      ? Colors.green
                                      : Colors.red,
                            ),
                          );
                        }
                      }
                    },
                  ).paddingFrom(right: 200);
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// Updated Message Input Section
class MessageInputSection extends StatelessWidget {
  final TextEditingController controller;

  const MessageInputSection({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NutrationDataEntryCubit, NutrationDataEntryState>(
      builder: (context, state) {
        return Row(
          children: [
            GestureDetector(
              onTap: () {
                // Handle voice input tap
                context.read<NutrationDataEntryCubit>().toggleListening();
              },
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColorsManager.mainDarkBlue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: AppColorsManager.mainDarkBlue.withOpacity(0.3),
                  ),
                ),
                child: Icon(
                  state.isListening ? Icons.stop : Icons.mic,
                  color: state.isListening
                      ? Colors.red
                      : AppColorsManager.mainDarkBlue,
                  size: 24,
                ),
              ),
            ),
            horizontalSpacing(12),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Colors.grey[300]!),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: TextField(
                  controller: controller,
                  textAlign: TextAlign.right,
                  maxLines: 3,
                  minLines: 1,
                  decoration: InputDecoration(
                    hintText: state.isListening
                        ? 'جاري الاستماع...'
                        : (state.selectedPlanDate.isEmpty
                            ? 'اكتب او سجل غذائك'
                            : 'اكتب او سجل غذائك ليوم ${state.selectedPlanDate}'),
                    hintStyle: TextStyle(color: Colors.grey),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
