import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/di/dependency_injection.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/app_custom_button.dart';
import 'package:we_care/core/global/SharedWidgets/custom_app_bar_with_centered_title_widget.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/core/routing/routes.dart';
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

  final TextEditingController _monthlyMessageController =
      TextEditingController();

  // State for each tab
  bool _weeklyPlanActive = false;
  bool _monthlyPlanActive = false;

  // Current tab index
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: 0,
    );

    // Listen to tab changes
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() {
          _currentIndex = _tabController.index;
        });
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _monthlyMessageController.dispose();
    super.dispose();
  }

  // Toggle plan active state for current tab
  void _togglePlanActive(bool value) {
    setState(() {
      if (_currentIndex == 0) {
        _weeklyPlanActive = value;
      } else {
        _monthlyPlanActive = value;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<NutrationDataEntryCubit>(
      create: (context) => getIt<NutrationDataEntryCubit>(),
      child: Builder(
        builder: (BuildContext context) {
          return Scaffold(
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
                      fontWeight: FontWeight.bold,
                    ),
                    unselectedLabelStyle:
                        AppTextStyles.font16DarkGreyWeight400.copyWith(
                      fontWeight: FontWeight.w500,
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
                    controller: _tabController,
                    children: [
                      // Weekly Plan Tab
                      _buildTabContent(
                        isWeeklyPlan: true,
                        isActive: _weeklyPlanActive,
                        messageController: context
                            .read<NutrationDataEntryCubit>()
                            .weeklyMessageController,
                      ),
                      // Monthly Plan Tab
                      _buildTabContent(
                        isWeeklyPlan: false,
                        isActive: _monthlyPlanActive,
                        messageController: _monthlyMessageController,
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
    required bool isActive,
    required TextEditingController messageController,
  }) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          verticalSpacing(24),

          // Plan activation toggle
          PlanActivationToggle(
            isActive: isActive,
            onToggle: _togglePlanActive,
          ),

          verticalSpacing(24),

          // Meal grid (different for weekly vs monthly)
          Expanded(
            child: isWeeklyPlan ? WeeklyMealGrid() : MonthlyMealGrid(),
          ),

          verticalSpacing(25),

          // Instruction text
          const InstructionText(),

          verticalSpacing(16),

          // Message input and voice button
          MessageInputSection(controller: messageController),

          verticalSpacing(12),

          AppCustomButton(
            title: 'حفظ',
            isEnabled: true,
            onPressed: () async {
              await context.pushNamed(Routes.nutritionFollowUpReportView);
            },
          ).paddingFrom(
            right: 200,
          )
        ],
      ),
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
              onTap: () async {
                // Handle voice input tap
                await context.read<NutrationDataEntryCubit>().toggleListening();
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
                  decoration: const InputDecoration(
                    hintText: 'رسالة نصية أو تسجيل صوتي',
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
