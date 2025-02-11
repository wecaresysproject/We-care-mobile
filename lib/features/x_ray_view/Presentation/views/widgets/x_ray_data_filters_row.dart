import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/x_ray_view/Presentation/views/widgets/search_filter_widget.dart';

class XRayDataViewFiltersRaw extends StatelessWidget {
  const XRayDataViewFiltersRaw({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SearchFilterWidget(
          filterTitle: 'السنة',
          isYearFilter: true,
          filterList: List.generate(20, (index) => (2010 + index).toString()),
        ),
        horizontalSpacing(16),
        SearchFilterWidget(
          filterTitle: 'نوع المنظار',
          filterList: [
            'الكل',
            'المنظار العادي',
            'المنظار الرقمي',
            'المنظار الجراحي',
            'منظار الأنف',
            'منظار الأذن',
            'منظار الحنجرة',
            'منظار القولون',
            'منظار المعدة',
            'منظار الرحم',
            'منظار الصدر',
            'منظار المفاصل',
            'منظار المثانة',
            'منظار الكلى',
            'منظار الأمعاء',
            'منظار البطن',
            'منظار الحنجرة',
            'منظار القلب'
          ],
        ),
        horizontalSpacing(16),
        SearchFilterWidget(
          filterTitle: 'نوع الاجراء',
          filterList: [
            'الكل',
            'الاشعة',
            'التحاليل',
            'المنظار',
            'الأشعة السينية',
            'تحليل الدم',
            'تحليل البول',
            'تحليل البراز',
            'فحص السكري',
            'اختبار الحساسية',
            'اختبار الحمل',
            'فحص القلب',
          ],
        ),
        Spacer(),
        FilterButton(title: 'عرض'),
      ],
    );
  }
}

class FilterButton extends StatelessWidget {
  final String title;

  const FilterButton({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // TODO: Handle button action
      },
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        width: 58.w, // Fixed width
        height: 40.h, // Fixed height
        padding: EdgeInsets.only(top: 8.h, bottom: 10.h), // Custom padding
        decoration: BoxDecoration(
          color: AppColorsManager.mainDarkBlue, // Updated Main Color
          borderRadius: BorderRadius.circular(12.r), // Rounded corners
        ),
        alignment: Alignment.center, // Center text
        child: Text(
          title, // Dynamic title
          style: AppTextStyles.font22WhiteWeight600
              .copyWith(fontSize: 14), // Updated text style
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
