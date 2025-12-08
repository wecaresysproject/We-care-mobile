import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/SharedWidgets/custom_app_bar_with_centered_title_widget.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';

class SupplementsReportTableView extends StatelessWidget {
  final String date;
  const SupplementsReportTableView({super.key, required this.date});

  @override
  Widget build(BuildContext context) {
    final mockData = [
      "حديد",
      "صوديوم",
      "فيتامين د",
      "فيتامين سي",
      "زنك",
      "ماغنسيوم",
      "كالسيوم",
      "صوديوم",
      "فوليك اسيد",
      "زنك",
      "فوليك اسيد",
      "حديد",
    ];

    return Scaffold(
      appBar: AppBar(toolbarHeight: 0),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            const AppBarWithCenteredTitle(
              title: "تقرير المتابعة",
              showActionButtons: false,
            ),
            SizedBox(height: 12.h),
            _buildTable(mockData, context),
          ],
        ),
      ),
    );
  }

  Widget _buildTable(List<String> elements, BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        headingRowColor: WidgetStateProperty.all(AppColorsManager.mainDarkBlue),
        columnSpacing: _getResponsiveColumnSpacing(
            context), //context.screenWidth * .02, //
        dataRowMaxHeight: 60,
        horizontalMargin: _getResponsiveColumnSpacing(context), //1.w,
        dividerThickness: 0.83,
        headingTextStyle: _getHeadingTextStyle(),
        headingRowHeight: 70,
        showBottomBorder: true,
        border: TableBorder.all(
          style: BorderStyle.solid,
          borderRadius: BorderRadius.circular(8),
          color: const Color(0xff909090),
          width: 0.19,
        ),
        columns: const [
          DataColumn(label: Center(child: Text("    العنصر    "))),
          DataColumn(label: Text("اليوم")),
          DataColumn(label: Text("متوسط\nاحتياج\n يومي")),
          DataColumn(label: Text("التراكمي\nالفعلي")),
          DataColumn(label: Text("متوسط\nاحتياج\n تراكمي")),
        ],
        rows: elements.map((item) {
          return DataRow(
            cells: [
              _cell(item, isVitaminNameCell: true),
              _cell("1200"),
              _cell("1200"),
              _cell("1200"),
              _cell("200"),
            ],
          );
        }).toList(),
      ),
    );
  }

  DataCell _cell(String text, {bool isVitaminNameCell = false}) {
    return DataCell(
      Center(
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: AppTextStyles.font12blackWeight400.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: 13.sp,
            color: isVitaminNameCell
                ? AppColorsManager.mainDarkBlue
                : Colors.black,
          ),
        ),
      ),
    );
  }
}

double _getResponsiveColumnSpacing(BuildContext context) {
  final width = MediaQuery.of(context).size.width;

  if (width <= 360) {
    return 8; // شاشات صغيرة جداً
  } else if (width <= 480) {
    return 12; // موبايلات صغيرة
  } else if (width <= 600) {
    return 16; // موبايلات متوسطة
  } else if (width <= 800) {
    return 24; // تابلت صغيرة
  } else if (width <= 1200) {
    return 28; // تابلت كبيرة
  } else {
    return 32; // شاشات كبيرة / Desktop
  }
}

// 📝 Header text style
TextStyle _getHeadingTextStyle() {
  return AppTextStyles.font16DarkGreyWeight400.copyWith(
    color: AppColorsManager.backGroundColor,
    fontWeight: FontWeight.w600,
    fontSize: 13.sp,
  );
}
