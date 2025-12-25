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
import 'package:we_care/features/nutration/nutration_data_entry/Presentation/views/system_prompt_view.dart';
import 'package:we_care/features/nutration/nutration_data_entry/Presentation/views/widgets/instruction_text_widget.dart';
import 'package:we_care/features/nutration/nutration_data_entry/Presentation/views/widgets/message_input_section_widget.dart';
import 'package:we_care/features/nutration/nutration_data_entry/Presentation/views/widgets/monthly_plan_grid_view_widget.dart';
import 'package:we_care/features/nutration/nutration_data_entry/Presentation/views/widgets/plan_activation_toggle_switch_widget.dart';
import 'package:we_care/features/nutration/nutration_data_entry/Presentation/views/widgets/success_dialog_with_confetti_widget.dart';
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
      create: (context) {
        final cubit =
            NutrationDataEntryCubit(getIt<NutrationDataEntryRepo>(), context);
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          await cubit.getAnyActivePlanStatus();
          await cubit.getPlanActivationStatus();
          await cubit.loadExistingPlans();
        });
        return cubit;
      },
      child: BlocListener<NutrationDataEntryCubit, NutrationDataEntryState>(
        listenWhen: (prev, curr) =>
            prev.followUpNutrationViewCurrentTabIndex !=
            curr.followUpNutrationViewCurrentTabIndex,
        listener: (context, state) {
          if (_tabController.index !=
              state.followUpNutrationViewCurrentTabIndex) {
            _tabController.animateTo(
              state.followUpNutrationViewCurrentTabIndex,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          }
        },
        child: Builder(builder: (context) {
          return Scaffold(
            floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                // Navigate to SystemPromptView
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => BlocProvider.value(
                      value: context.read<NutrationDataEntryCubit>(),
                      child: const SystemPromptView(),
                    ),
                  ),
                );
              },
              backgroundColor: AppColorsManager.mainDarkBlue,
              child: const Icon(
                Icons.download,
                color: Colors.white,
              ),
            ),
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
        }),
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

              BlocConsumer<NutrationDataEntryCubit, NutrationDataEntryState>(
                listenWhen: (previous, current) =>
                    previous.isFoodAnalysisSuccess !=
                    current.isFoodAnalysisSuccess,
                listener: (context, state) async {
                  if (state.submitNutrationDataStatus ==
                          RequestStatus.success &&
                      state.isFoodAnalysisSuccess) {
                    await showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) => SuccessDialogWithConfetti(
                        message: "تم إدخال جميع وجبات اليوم بنجاح 🎉",
                      ),
                    );
                  }
                },
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
                      await context
                          .read<NutrationDataEntryCubit>()
                          .analyzeDietPlan();
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
