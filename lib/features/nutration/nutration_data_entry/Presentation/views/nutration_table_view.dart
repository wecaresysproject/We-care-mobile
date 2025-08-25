import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/custom_app_bar_with_centered_title_widget.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';

class NutritionFollowUpReportView extends StatelessWidget {
  const NutritionFollowUpReportView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
        ),
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            AppBarWithCenteredTitle(
              title: "تقرير المتابعة",
              showActionButtons: false,
            ),
            verticalSpacing(24),
            DataTable(
              clipBehavior: Clip.antiAliasWithSaveLayer,
              headingRowColor: WidgetStateProperty.all(
                AppColorsManager.mainDarkBlue,
              ),
              columnSpacing: 10,
              dataRowMinHeight: 40,
              dataRowMaxHeight: 60,
              horizontalMargin: 8,
              headingTextStyle: _getHeadingTextStyle(),
              showBottomBorder: true,
              border: TableBorder.all(
                style: BorderStyle.solid,
                borderRadius: BorderRadius.circular(8),
                color: const Color(0xff909090),
                width: 0.19,
              ),
              columns: _buildColumns(),
              rows: _buildRows(),
            ),
          ],
        ),
      ),
    );
  }

  List<DataColumn> _buildColumns() {
    return [
      _buildColumn("العنصر"),
      _buildColumn("يومي\nفعلي", isNumeric: true),
      _buildColumn("يومي\nالمعيار", isNumeric: true),
      _buildColumn("تراكمي\nفعلي", isNumeric: true),
      _buildColumn("تراكمي\nالمعيار", isNumeric: true),
      _buildColumn("الفرق", isNumeric: true),
    ];
  }

  List<DataRow> _buildRows() {
    final data = [
      {
        "element": "الطاقة سعر حراري",
        "dailyActual": "520",
        "dailyStd": "550",
        "cumActual": "1000",
        "cumStd": "1200",
        "diff": "200",
        "diffColor": Colors.black,
      },
      {
        "element": "البروتين جم",
        "dailyActual": "520",
        "dailyStd": "550",
        "cumActual": "1000",
        "cumStd": "1200",
        "diff": "200",
        "diffColor": Colors.red,
      },
      {
        "element": "دهون مشبعة جم",
        "dailyActual": "520",
        "dailyStd": "550",
        "cumActual": "1000",
        "cumStd": "1200",
        "diff": "200",
        "diffColor": Colors.black,
      },
      {
        "element": "دهون أحادية جم",
        "dailyActual": "520",
        "dailyStd": "550",
        "cumActual": "1000",
        "cumStd": "1200",
        "diff": "200",
        "diffColor": Colors.black,
      },
      {
        "element": "دهون متعددة جم",
        "dailyActual": "520",
        "dailyStd": "550",
        "cumActual": "1000",
        "cumStd": "1200",
        "diff": "200",
        "diffColor": Colors.blue,
      },
      {
        "element": "الطاقة سعر حراري",
        "dailyActual": "520",
        "dailyStd": "550",
        "cumActual": "1000",
        "cumStd": "1200",
        "diff": "200",
        "diffColor": Colors.black,
      },
      {
        "element": "البروتين جم",
        "dailyActual": "520",
        "dailyStd": "550",
        "cumActual": "1000",
        "cumStd": "1200",
        "diff": "200",
        "diffColor": Colors.red,
      },
      {
        "element": "دهون مشبعة جم",
        "dailyActual": "520",
        "dailyStd": "550",
        "cumActual": "1000",
        "cumStd": "1200",
        "diff": "200",
        "diffColor": Colors.black,
      },
      {
        "element": "دهون أحادية جم",
        "dailyActual": "520",
        "dailyStd": "550",
        "cumActual": "1000",
        "cumStd": "1200",
        "diff": "200",
        "diffColor": Colors.black,
      },
      {
        "element": "دهون متعددة جم",
        "dailyActual": "520",
        "dailyStd": "550",
        "cumActual": "1000",
        "cumStd": "1200",
        "diff": "200",
        "diffColor": Colors.blue,
      },
      {
        "element": "دهون مشبعة جم",
        "dailyActual": "520",
        "dailyStd": "550",
        "cumActual": "1000",
        "cumStd": "1200",
        "diff": "200",
        "diffColor": Colors.black,
      },
      {
        "element": "دهون أحادية جم",
        "dailyActual": "520",
        "dailyStd": "550",
        "cumActual": "1000",
        "cumStd": "1200",
        "diff": "200",
        "diffColor": Colors.black,
      },
      {
        "element": "دهون متعددة جم",
        "dailyActual": "520",
        "dailyStd": "550",
        "cumActual": "1000",
        "cumStd": "1200",
        "diff": "200",
        "diffColor": Colors.blue,
      },
    ];

    return data.map((row) {
      return DataRow(
        cells: [
          _buildCell(row["element"] as String, isBold: true, isElement: true),
          _buildCell(row["dailyActual"] as String),
          _buildCell(row["dailyStd"] as String),
          _buildCell(row["cumActual"] as String),
          _buildCell(row["cumStd"] as String),
          _buildColoredDiff(row["diff"] as String, row["diffColor"] as Color),
        ],
      );
    }).toList();
  }

  DataColumn _buildColumn(String label, {bool isNumeric = false}) {
    return DataColumn(
      label: Text(label, textAlign: TextAlign.center),
      numeric: isNumeric,
    );
  }

  DataCell _buildCell(String text,
      {bool isBold = false, bool isElement = false}) {
    if (isElement) {
      // 👇 العنصر دايمًا في سطرين
      final parts = text.split(" "); // يقسم النص حسب المسافة
      return DataCell(
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                parts.isNotEmpty ? parts.first : "",
                style: _getCellTextStyle(isBold),
                textAlign: TextAlign.center,
              ),
              Text(
                parts.length > 1 ? parts.sublist(1).join(" ") : "",
                style: _getCellTextStyle(isBold),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return DataCell(
      Center(
        child: Text(
          text,
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: _getCellTextStyle(isBold),
        ),
      ),
    );
  }

  DataCell _buildColoredDiff(String text, Color color) {
    return DataCell(
      Center(
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: _getCellTextStyle(false).copyWith(
            color: color,
            decoration: color == Colors.black
                ? TextDecoration.none
                : TextDecoration
                    .underline, //! check if its from an specific nutrient underline it
          ),
        ),
      ),
    );
  }

  TextStyle _getHeadingTextStyle() {
    return AppTextStyles.font16DarkGreyWeight400.copyWith(
      color: AppColorsManager.backGroundColor,
      fontWeight: FontWeight.w600,
      fontSize: 15.sp,
    );
  }

  TextStyle _getCellTextStyle(bool isBold) {
    return AppTextStyles.font12blackWeight400.copyWith(
      fontWeight: FontWeight.w500,
      fontSize: isBold ? 14.sp : 16.sp,
      color: !isBold ? Colors.black : AppColorsManager.mainDarkBlue,
    );
  }
}
