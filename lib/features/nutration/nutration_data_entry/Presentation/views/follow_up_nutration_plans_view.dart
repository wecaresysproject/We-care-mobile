import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/app_custom_button.dart';
import 'package:we_care/core/global/SharedWidgets/custom_app_bar_with_centered_title_widget.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/core/routing/routes.dart';
import 'package:we_care/features/nutration/nutration_data_entry/Presentation/views/widgets/instruction_text_widget.dart';

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

  // Controllers for each tab
  final TextEditingController _weeklyMessageController =
      TextEditingController();
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
    _weeklyMessageController.dispose();
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
                  messageController: _weeklyMessageController,
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

// Components
class MealPlanTabSelector extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTabChanged;

  const MealPlanTabSelector({
    super.key,
    required this.selectedIndex,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TabButton(
            title: 'خطة أسبوعية',
            isSelected: selectedIndex == 0,
            onTap: () => onTabChanged(0),
          ),
        ),
        horizontalSpacing(8),
        Expanded(
          child: TabButton(
            title: 'خطة شهرية',
            isSelected: selectedIndex == 1,
            onTap: () => onTabChanged(1),
          ),
        ),
      ],
    );
  }
}

class TabButton extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const TabButton({
    super.key,
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isSelected
                  ? AppColorsManager.mainDarkBlue
                  : AppColorsManager.placeHolderColor,
              width: 2,
            ),
          ),
        ),
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: AppTextStyles.font16DarkGreyWeight400.copyWith(
            color: isSelected
                ? AppColorsManager.mainDarkBlue
                : AppColorsManager.placeHolderColor,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

// Updated Plan Activation Toggle with plan type
class PlanActivationToggle extends StatelessWidget {
  final bool isActive;
  final Function(bool) onToggle;

  const PlanActivationToggle({
    super.key,
    required this.isActive,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Switch(
          value: isActive,
          onChanged: onToggle,
          activeColor: Colors.white,
          activeTrackColor: Colors.grey[400],
          inactiveThumbColor: Colors.white,
          inactiveTrackColor: Colors.grey[300],
        ),
        horizontalSpacing(10),
        Text(
          'تفعيل الخطة',
          style: AppTextStyles.font16DarkGreyWeight400.copyWith(
            color: AppColorsManager.mainDarkBlue,
          ),
        ),
      ],
    );
  }
}

// Weekly Meal Grid (7 days)
class WeeklyMealGrid extends StatelessWidget {
  WeeklyMealGrid({super.key});

  final List<String> days = [
    'السبت',
    'الأحد',
    'الاثنين',
    'الثلاثاء',
    'الأربعاء',
    'الخميس',
    'الجمعة'
  ];

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1,
        ),
        itemCount: 7,
        itemBuilder: (context, index) {
          return MealCard(
            day: days[index],
            isEmpty: true,
            haveAdocument: index % 3 == 0, // Some cards have documents
          );
        },
      ),
    );
  }
}

// Monthly Meal Grid (30 days)
class MonthlyMealGrid extends StatelessWidget {
  MonthlyMealGrid({super.key});

  final List<String> weeks = [
    'السبت',
    'الأحد',
    'الاثنين',
    'الثلاثاء',
    'الأربعاء',
    'الخميس',
    'الجمعة'
  ];

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1,
        ),
        itemCount: 4,
        itemBuilder: (context, index) {
          return MealCard(
            day: weeks[index],
            isEmpty: true,
            haveAdocument: index % 2 == 0, // Some cards have documents
          );
        },
      ),
    );
  }
}

class MealCard extends StatelessWidget {
  final String day;
  final bool isEmpty;
  final bool haveAdocument;

  const MealCard({
    super.key,
    required this.day,
    required this.isEmpty,
    this.haveAdocument = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      padding: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Color(0xffF1F3F6),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          width: 1,
          color: AppColorsManager.placeHolderColor,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            day,
            style: AppTextStyles.font16DarkGreyWeight400.copyWith(
              color: AppColorsManager.mainDarkBlue,
              // fontWeight: FontWeight.w700,
            ),
          ),
          verticalSpacing(8),
          Text(
            '--/--/----',
            style: AppTextStyles.font16DarkGreyWeight400.copyWith(
              color: AppColorsManager.mainDarkBlue,
            ),
          ),
          verticalSpacing(6),
          haveAdocument
              ? Container(
                  width: 69.w,

                  // margin: EdgeInsets.only(bottom: 6.h),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColorsManager.mainDarkBlue,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.file_present,
                        color: Colors.white,
                        size: 20,
                      ),
                      horizontalSpacing(4),
                      Text(
                        'التقرير',
                        style: AppTextStyles.font12blackWeight400.copyWith(
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                )
              : SizedBox.shrink(),
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
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            // TODO: Implement voice recording functionality
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
              Icons.mic,
              color: AppColorsManager.mainDarkBlue,
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
  }
}
