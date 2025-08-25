import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/app_custom_button.dart';
import 'package:we_care/core/global/SharedWidgets/custom_app_bar_with_centered_title_widget.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/core/routing/routes.dart';

class FollowUpNutrationPlansView extends StatefulWidget {
  const FollowUpNutrationPlansView({super.key});

  @override
  State<FollowUpNutrationPlansView> createState() =>
      _FollowUpNutrationPlansViewState();
}

class _FollowUpNutrationPlansViewState
    extends State<FollowUpNutrationPlansView> {
  int selectedTabIndex = 0; // Default to weekly plan
  bool isPlanActive = false;
  final TextEditingController messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Header with play button
              const AppBarWithCenteredTitle(
                title: 'خطة المتابعة',
                showActionButtons: false,
              ),

              verticalSpacing(24),

              // Tab selector
              MealPlanTabSelector(
                selectedIndex: selectedTabIndex,
                onTabChanged: (index) {
                  setState(() {
                    selectedTabIndex = index;
                  });
                },
              ),

              verticalSpacing(16),

              // Plan activation toggle
              PlanActivationToggle(
                isActive: isPlanActive,
                onToggle: (value) {
                  setState(() {
                    isPlanActive = value;
                  });
                },
              ),

              verticalSpacing(24),

              // Meal grid
              Expanded(
                child: MealGrid(),
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
        ),
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

class MealGrid extends StatelessWidget {
  MealGrid({super.key});

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
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 29,
        mainAxisSpacing: 20,
        childAspectRatio: 1,
      ),
      itemCount: 7,
      itemBuilder: (context, index) {
        return MealCard(
          day: days[index % days.length],
          isEmpty: true,
        );
      },
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

class InstructionText extends StatelessWidget {
  const InstructionText({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      'يرجى إدخال جميع الوجبات والمشروبات التي تم تناولها خلال فترات اليوم بالكامل بأكبر قدر من الدقة والتفصيل، مع مراعاة توضيح المقادير بالملعقة أو الطبق أو القطع أو الجرام أو رشة صغيرة',
      textAlign: TextAlign.center,
      style: AppTextStyles.font18blackWight500.copyWith(
        fontSize: 15.sp,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

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
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(24),
          ),
          child: Icon(
            Icons.mic,
            color: Colors.grey[600],
            size: 24,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: TextField(
              controller: controller,
              textAlign: TextAlign.right,
              decoration: const InputDecoration(
                hintText: 'رسالة نصية',
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
