import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/custom_app_bar.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/core/routing/routes.dart';
import 'package:we_care/features/medical_illnesses/medical_illnesses_data_entry_view/Presentation/views/widgets/custom_image_with_text_medical_illnesses_module_widget.dart';

class MedicalIllnessOrMindUmbrellaView extends StatelessWidget {
  const MedicalIllnessOrMindUmbrellaView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: DecoratedBox(
          decoration: ShapeDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            shape: RoundedRectangleBorder(),
          ),
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              children: [
                CustomAppBarWidget(
                  haveBackArrow: true,
                ),
                verticalSpacing(113),
                CustomImageWithTextMedicalIllnessModuleWidget(
                  onTap: () async {
                    await context.pushNamed(Routes.mentalIllnessesRecordsView);
                  },
                  imagePath: "assets/images/medical_illnesses_icon.png",
                  text: "الأمراض النفسية",
                  textStyle: AppTextStyles.font22WhiteWeight600.copyWith(
                    fontSize: 24.sp,
                  ),
                  isTextFirst: false,
                ),
                verticalSpacing(88),
                CustomImageWithTextMedicalIllnessModuleWidget(
                  onTap: () async {
                    await context.pushNamed(Routes.mentalIlnesssUmbrellaView);
                  },
                  imagePath:
                      "assets/images/medical_illnesses_umbrella_icon.png",
                  text: "المظلة النفسية",
                  textStyle: AppTextStyles.font22WhiteWeight600.copyWith(
                    fontSize: 24.sp,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MentalIllnessesUmbrellaView extends StatefulWidget {
  const MentalIllnessesUmbrellaView({super.key});

  @override
  MentalHealthScreenUmbrellaState createState() =>
      MentalHealthScreenUmbrellaState();
}

class MentalHealthScreenUmbrellaState
    extends State<MentalIllnessesUmbrellaView> {
  // Track expanded state for each category
  Set<int> expandedCards = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        toolbarHeight: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            CustomAppBarWidget(
              haveBackArrow: true,
            ),
            verticalSpacing(40),
            _buildActionButtons(),
            verticalSpacing(36),
            _buildSeverityIndicator(),
            verticalSpacing(24),
            _buildCategoryGrid(),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: _buildActionButton(
            'الأسئلة المجاني عنها يعم',
            "assets/images/question_mark.png",
          ),
        ),
        horizontalSpacing(16),
        Expanded(
          child: _buildActionButton(
            'تقارير المتابعة',
            'assets/images/medical_reports_image.png',
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(
    String title,
    String iconPath,
  ) {
    return Container(
      height: 52.h,
      padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 14.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: AppColorsManager.mainDarkBlue,
          width: 2,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            iconPath,
            color: AppColorsManager.mainDarkBlue,
            width: 24,
            height: 24,
          ),
          horizontalSpacing(5.5),
          Flexible(
            child: Text(
              title,
              style: AppTextStyles.font14whiteWeight600.copyWith(
                color: AppColorsManager.mainDarkBlue,
                fontSize: 14.sp,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSeverityIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildSeverityItem('طبيعي', Colors.green),
        _buildSeverityItem('مراقبة', Colors.yellow),
        _buildSeverityItem('خطر جزئي', Colors.orange),
        _buildSeverityItem('خطر مؤكد', Colors.red),
      ],
    );
  }

  Widget _buildSeverityItem(String label, Color color) {
    return Row(
      children: [
        CircleAvatar(
          backgroundColor: color,
          radius: 10,
        ),
        horizontalSpacing(6),
        Text(
          label,
          style: AppTextStyles.font14whiteWeight600.copyWith(
            color: AppColorsManager.textColor,
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryGrid() {
    final categories = [
      CategoryItem(
        'الأفكار الوسواسية\nوالمعتقدات\nالمنحرفة',
        SeverityLevel.confirmedRisk,

        AppColorsManager.criticalRisk,

        Icons.psychology,
        45, // followUpCount
        45, // answeredQuestions
        45, // riskScores
        45, // cumulativeScores
      ),
      CategoryItem(
        'الأفكار السلبية\nوالاتجاهات\nالتدميرية',
        SeverityLevel.normal,
        AppColorsManager.safe,
        Icons.dangerous,
        45,
        45,
        45,
        45,
      ),
      CategoryItem(
        'الحالة المزاجية',
        SeverityLevel.partialRisk,
        AppColorsManager.elevatedRisk,
        Icons.mood,
        45,
        45,
        45,
        45,
      ),
      CategoryItem(
        'العلاقات الاجتماعية\nوالاندماج المجتمعي',
        SeverityLevel.monitoring,
        AppColorsManager.warning,
        Icons.people,
        45,
        45,
        45,
        45,
      ),
      CategoryItem(
        'الذكيرة والانتباه\nوالاضطرابات\nالتذكيرية والحسية',
        SeverityLevel.normal,
        AppColorsManager.safe,
        Icons.memory,
        45,
        45,
        45,
        45,
      ),
      CategoryItem(
        'الصورة الذاتية\nوالثقة بالنفس\nوتقدير الذات',
        SeverityLevel.normal,
        AppColorsManager.safe,
        Icons.self_improvement,
        45,
        45,
        45,
        45,
      ),
      CategoryItem(
        'التنظيم العاطفي\nوالتحكم في\nالانفعالات',
        SeverityLevel.normal,
        AppColorsManager.safe,
        Icons.emoji_emotions,
        45,
        45,
        45,
        45,
      ),
      CategoryItem(
        'السلوكيات لتعام\nوالانضباط الذاتي',
        SeverityLevel.monitoring,
        AppColorsManager.warning,
        Icons.abc_sharp,
        45,
        45,
        45,
        45,
      ),
      CategoryItem(
        'السلوك الغذائي\nوالمهامات',
        SeverityLevel.monitoring,
        AppColorsManager.warning,
        Icons.restaurant,
        45,
        45,
        45,
        45,
      ),
      CategoryItem(
        'الشهوية والأكل',
        SeverityLevel.confirmedRisk,
        AppColorsManager.criticalRisk,
        Icons.local_dining,
        45,
        45,
        45,
        45,
      ),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: expandedCards.isNotEmpty ? 0.8 : 2.2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        final isExpanded = expandedCards.contains(index);
        return _buildCategoryCard(category, index, isExpanded);
      },
    );
  }

  Widget _buildCategoryCard(CategoryItem category, int index, bool isExpanded) {
    final darkerColor = category.color
        .withRed((category.color.red * 0.8).toInt())
        .withGreen((category.color.green * 0.8).toInt())
        .withBlue((category.color.blue * 0.8).toInt());

    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        color: category.color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: category.color.withOpacity(0.3)),
      ),
      child: Material(
        // color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12.r),
          onTap: () {
            setState(() {
              if (isExpanded) {
                expandedCards.remove(index);
              } else {
                expandedCards.add(index);
              }
            });
          },
          child: Column(
            children: [
              // Header with arrow and icon
              Container(
                height: 67.h,
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                    color: category.color,
                    // color: category.color.withOpacity(0.1),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12.r),
                      topRight: Radius.circular(12.r),
                    )),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Category title
                    Text(
                      category.title,
                      style: AppTextStyles.font14whiteWeight600.copyWith(
                        color: Colors.black87,
                        fontSize: 11.sp,
                        height: 1.3,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    AnimatedRotation(
                      turns: isExpanded ? 0.5 : 0,
                      duration: Duration(milliseconds: 300),
                      child: Icon(
                        Icons.keyboard_arrow_down,
                        color: darkerColor,
                        size: 29.sp,
                      ),
                    ),
                  ],
                ),
              ),

              verticalSpacing(8),

              // Expanded content
              if (isExpanded) ...[
                _buildExpandedContent(category),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExpandedContent(CategoryItem category) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      spacing: 2,
      children: [
        if (category.severityLevel == SeverityLevel.confirmedRisk) ...[
          _buildContactItem(
            'تواصل مع مختص',
            'assets/images/support_team_member.png',
            category.followUpCount.toString(),
          ),
        ],
        // Contact specialist and support rooms
        if (category.severityLevel == SeverityLevel.partialRisk) ...[
          _buildContactItem(
            'تواصل مع مختص',
            'assets/images/support_team_member.png',
            category.followUpCount.toString(),
          ),
          _buildContactItem(
            'غرف الدعم',
            'assets/images/support_rooms_icon.png',
            category.answeredQuestions.toString(),
          ),
        ],

        // Statistics
        _buildStatRow('عدد أشهر المتابعة:', category.followUpCount.toString()),
        _buildStatRow(
            'عدد الأسئلة المجابة:', category.answeredQuestions.toString()),
        _buildStatRow('درجات أشهر الخطر:', category.riskScores.toString()),
        _buildStatRow(
            'الدرجات التراكمية:', category.cumulativeScores.toString()),
      ],
    ).paddingSymmetricHorizontal(4);
  }

  Widget _buildContactItem(String title, String iconPath, String count) {
    return Row(
      children: [
        Image.asset(
          iconPath,
          height: 26.h,
          width: 26.w,
        ),
        horizontalSpacing(10),
        Text(
          title,
          style: AppTextStyles.font14whiteWeight600.copyWith(
            color: AppColorsManager.textColor,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    ).paddingSymmetricHorizontal(4);
  }

  Widget _buildStatRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Text(
            label,
            style: AppTextStyles.font14whiteWeight600.copyWith(
              color: AppColorsManager.textColor,
              fontSize: 13.sp,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        Text(
          value,
          style: AppTextStyles.font14whiteWeight600.copyWith(
            color: AppColorsManager.textColor,
            fontSize: 13.sp,
          ),
        ),
      ],
    ).paddingSymmetricHorizontal(4);
  }
}

class CategoryItem {
  final String title;
  final Color color;
  final SeverityLevel severityLevel;
  final IconData icon;
  final int followUpCount;
  final int answeredQuestions;
  final int riskScores;
  final int cumulativeScores;

  CategoryItem(
    this.title,
    this.severityLevel,
    this.color,
    this.icon,
    this.followUpCount,
    this.answeredQuestions,
    this.riskScores,
    this.cumulativeScores,
  );
}

/// مستويات الخطورة المحتملة
enum SeverityLevel {
  normal, // طبيعي - لا توجد أي خطورة
  monitoring, // مراقبة - يتطلب المراقبة دون تدخل عاجل
  partialRisk, // خطر جزئي - يوجد مؤشرات خطر لكن ليست حرجة
  confirmedRisk, // خطر مؤكد - حالة حرجة تتطلب تدخل فوري
}
