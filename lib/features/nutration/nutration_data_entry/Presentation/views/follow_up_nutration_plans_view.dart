import 'dart:math';
import 'dart:ui';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
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
import 'package:we_care/features/nutration/nutration_data_entry/Presentation/views/widgets/message_input_section_widget.dart';
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
                          await showSuccessDialog(
                            context,
                            "تم إدخال جميع وجبات اليوم بنجاح 🎉",
                          );
                          // showSuccessDialog(context, state.message);
                          // ScaffoldMessenger.of(context).showSnackBar(
                          //   SnackBar(
                          //     content: Text(state.message),
                          //     backgroundColor:
                          //         state.submitNutrationDataStatus ==
                          //                 RequestStatus.success
                          //             ? Colors.green
                          //             : Colors.red,
                          //   ),
                          // );
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

Future<void> showSuccessDialog(BuildContext context, String message) async {
  final confettiController =
      ConfettiController(duration: const Duration(seconds: 3));

  // نشغل الكونفيتي أول ما يفتح الدايلوج
  confettiController.play();

  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return Stack(
        alignment: Alignment.center,
        children: [
          // خلفية شفافة + blur
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
            child: Container(color: Colors.black.withOpacity(0.3)),
          ),

          // Confetti فوق الدايلوج 🎊
          // Confetti من أعلى الشاشة
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: confettiController,
              blastDirection: pi / 2, // اتجاه لتحت ⬇️
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              colors: const [
                Colors.green,
                Colors.blue,
                Colors.orange,
                Colors.purple,
                Colors.red,
              ],
              numberOfParticles: 20,
              emissionFrequency: 0.05,
              gravity: 0.4,
            ),
          ),

          // Centered fancy dialog
          Dialog(
            elevation: 0,
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Success Animation
                  SizedBox(
                    height: 160,
                    child: Lottie.asset(
                      'assets/images/success_state.json',
                      repeat: false,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Title
                  const Text(
                    "أحسنت 👏",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Message
                  Text(
                    message,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Continue button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        confettiController.stop();
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 4,
                        shadowColor: Colors.greenAccent,
                      ),
                      child: const Text(
                        "استمر",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    },
  );
}
