import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/custom_app_bar.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';

class MentalIllnessesUmbrellRecordsView extends StatefulWidget {
  const MentalIllnessesUmbrellRecordsView({super.key});

  @override
  MentalHealthScreenUmbrellaState createState() =>
      MentalHealthScreenUmbrellaState();
}

class MentalHealthScreenUmbrellaState
    extends State<MentalIllnessesUmbrellRecordsView> {
  OverlayEntry? _overlayEntry;

  void _showOverlay(RenderBox renderBox, CategoryItem category) {
    _removeOverlay();
    final position = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        left: position.dx,
        top: position.dy,
        width: size.width,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                    color: Colors.black26, blurRadius: 6, offset: Offset(0, 3))
              ],
              border: Border.all(color: category.color.withOpacity(0.4)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        category.title,
                        style: AppTextStyles.font14whiteWeight600
                            .copyWith(color: Colors.black87),
                      ),
                    ),
                    IconButton(
                      icon:
                          Icon(Icons.keyboard_arrow_up, color: Colors.black87),
                      onPressed: _removeOverlay,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                _buildExpandedContent(category),
              ],
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  void dispose() {
    _removeOverlay();
    super.dispose();
  }

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

  Widget _buildActionButton(String title, String iconPath) {
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
          45,
          45,
          45,
          45),
      CategoryItem(
          'الأفكار السلبية\nوالاتجاهات\nالتدميرية',
          SeverityLevel.normal,
          AppColorsManager.safe,
          Icons.dangerous,
          45,
          45,
          45,
          45),
      CategoryItem('الحالة المزاجية', SeverityLevel.partialRisk,
          AppColorsManager.elevatedRisk, Icons.mood, 45, 45, 45, 45),
      CategoryItem(
          'العلاقات الاجتماعية\nوالاندماج المجتمعي',
          SeverityLevel.monitoring,
          AppColorsManager.warning,
          Icons.people,
          45,
          45,
          45,
          45),
      CategoryItem(
          'الذكيرة والانتباه\nوالاضطرابات\nالتذكيرية والحسية',
          SeverityLevel.normal,
          AppColorsManager.safe,
          Icons.memory,
          45,
          45,
          45,
          45),
      CategoryItem(
          'الصورة الذاتية\nوالثقة بالنفس\nوتقدير الذات',
          SeverityLevel.normal,
          AppColorsManager.safe,
          Icons.self_improvement,
          45,
          45,
          45,
          45),
      CategoryItem(
          'التنظيم العاطفي\nوالتحكم في\nالانفعالات',
          SeverityLevel.normal,
          AppColorsManager.safe,
          Icons.emoji_emotions,
          45,
          45,
          45,
          45),
      CategoryItem(
          'السلوكيات لتعام\nوالانضباط الذاتي',
          SeverityLevel.monitoring,
          AppColorsManager.warning,
          Icons.abc_sharp,
          45,
          45,
          45,
          45),
      CategoryItem('السلوك الغذائي\nوالمهامات', SeverityLevel.monitoring,
          AppColorsManager.warning, Icons.restaurant, 45, 45, 45, 45),
      CategoryItem('الشهوية والأكل', SeverityLevel.confirmedRisk,
          AppColorsManager.criticalRisk, Icons.local_dining, 45, 45, 45, 45),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 2.2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        return Builder(
          builder: (ctx) {
            return GestureDetector(
              onTap: () {
                final renderBox = ctx.findRenderObject() as RenderBox;
                _showOverlay(renderBox, category);
              },
              child: Container(
                decoration: BoxDecoration(
                  color: category.color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: category.color.withOpacity(0.3)),
                ),
                child: Column(
                  children: [
                    Container(
                      height: 67.h,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: category.color,
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(12.r)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              category.title,
                              style:
                                  AppTextStyles.font14whiteWeight600.copyWith(
                                color: Colors.black87,
                                fontSize: 11.sp,
                                height: 1.3,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const Icon(Icons.keyboard_arrow_down,
                              color: Colors.black),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildExpandedContent(CategoryItem category) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (category.severityLevel == SeverityLevel.confirmedRisk)
          _buildContactItem(
              'تواصل مع مختص', 'assets/images/support_team_member.png'),
        if (category.severityLevel == SeverityLevel.partialRisk) ...[
          _buildContactItem(
              'تواصل مع مختص', 'assets/images/support_team_member.png'),
          _buildContactItem(
              'غرف الدعم', 'assets/images/support_rooms_icon.png'),
        ],
        _buildStatRow('عدد أشهر المتابعة:', category.followUpCount.toString()),
        _buildStatRow(
            'عدد الأسئلة المجابة:', category.answeredQuestions.toString()),
        _buildStatRow('درجات أشهر الخطر:', category.riskScores.toString()),
        _buildStatRow(
            'الدرجات التراكمية:', category.cumulativeScores.toString()),
      ],
    );
  }

  Widget _buildContactItem(String title, String iconPath) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Image.asset(iconPath, height: 26, width: 26),
          const SizedBox(width: 10),
          Text(title,
              style: AppTextStyles.font14whiteWeight600
                  .copyWith(color: AppColorsManager.textColor)),
        ],
      ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(label,
                style: AppTextStyles.font14whiteWeight600
                    .copyWith(color: AppColorsManager.textColor, fontSize: 13)),
          ),
          Text(value,
              style: AppTextStyles.font14whiteWeight600
                  .copyWith(color: AppColorsManager.textColor, fontSize: 13)),
        ],
      ),
    );
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
  normal,
  monitoring,
  partialRisk,
  confirmedRisk,
}
