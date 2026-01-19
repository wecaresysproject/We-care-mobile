import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/SharedWidgets/custom_app_bar_with_centered_title_widget.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';

class CaloriesTableView extends StatelessWidget {
  const CaloriesTableView({super.key, required this.date});
  final String? date;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(toolbarHeight: 0),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            AppBarWithCenteredTitle(
              title: "تقرير المتابعة",
              showActionButtons: false,
            ),
            SizedBox(height: 16.h),
            // TODO: Add BlocProvider and data fetching logic here
            _buildDataTable(context),
          ],
        ),
      ),
    );
  }

  Widget _buildDataTable(BuildContext context) {
    // Placeholder data - replace with actual API data
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        headingRowColor: WidgetStateProperty.all(AppColorsManager.mainDarkBlue),
        columnSpacing: _getResponsiveColumnSpacing(context),
        dataRowMaxHeight: 80,
        horizontalMargin: _getResponsiveColumnSpacing(context),
        dividerThickness: 0.83,
        headingTextStyle: _getHeadingTextStyle(),
        showBottomBorder: true,
        border: TableBorder.all(
          style: BorderStyle.solid,
          borderRadius: BorderRadius.circular(8),
          color: const Color(0xff909090),
          width: 0.19,
        ),
        columns: _buildColumns(),
        rows: _buildPlaceholderRows(),
      ),
    );
  }

  double _getResponsiveColumnSpacing(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    if (width <= 360) {
      return 6;
    } else if (width <= 480) {
      return 10;
    } else if (width <= 600) {
      return 14;
    } else if (width <= 800) {
      return 18;
    } else if (width <= 1200) {
      return 22;
    } else {
      return 28;
    }
  }

  /// 📋 Build table columns based on the provided image
  List<DataColumn> _buildColumns() {
    return [
      _buildColumn("التاريخ"),
      _buildColumn("اليوم"),
      _buildColumn("عدد دقائق\nممارسة\nالرياضة"),
      _buildColumn("السعرات\nالمكتسبة"),
      _buildColumn("السعرات\nالمحروقة"),
      _buildColumn("وحدات\nالبناء\nالعضلي"),
      _buildColumn("وحدات\nالصيانة\nالعضلية"),
      _buildColumn("نسبة البناء\nالعضلي\nالتراكمية"),
      _buildColumn("نسبة\nالصيانة\nالعضلية\nالتراكمية"),
      _buildColumn("وزن الجسم"),
      _buildColumn("وزن الجسم\nالمستهدف\nحد أعلى"),
      _buildColumn("وزن الجسم\nالمستهدف\nحد أدنى"),
    ];
  }

  /// 📊 Build individual column
  DataColumn _buildColumn(String label) {
    return DataColumn(
      headingRowAlignment: MainAxisAlignment.center,
      label: Text(
        label,
        textAlign: TextAlign.center,
        style: AppTextStyles.font18blackWight500.copyWith(
          fontSize: 11.5.sp,
          color: Colors.white,
          fontWeight: FontWeight.w700,
        ),
      ),
      numeric: false,
    );
  }

  /// Placeholder rows - replace with actual data
  List<DataRow> _buildPlaceholderRows() {
    final List<Map<String, String>> mockData = [
      {
        "date": "2024-01-19",
        "day": "الاثنين",
        "exercise": "45",
        "gained": "2100",
        "burned": "450",
        "build": "1.2",
        "maint": "0.8",
        "cumBuild": "82%",
        "cumMaint": "88%",
        "weight": "75.5",
        "targetMax": "78.0",
        "targetMin": "72.0"
      },
      {
        "date": "2024-01-18",
        "day": "الأحد",
        "exercise": "30",
        "gained": "1950",
        "burned": "300",
        "build": "0.9",
        "maint": "0.7",
        "cumBuild": "80%",
        "cumMaint": "86%",
        "weight": "75.8",
        "targetMax": "78.0",
        "targetMin": "72.0"
      },
      {
        "date": "2024-01-17",
        "day": "السبت",
        "exercise": "0",
        "gained": "2300",
        "burned": "100",
        "build": "0.2",
        "maint": "0.5",
        "cumBuild": "78%",
        "cumMaint": "84%",
        "weight": "76.2",
        "targetMax": "78.0",
        "targetMin": "72.0"
      },
      {
        "date": "2024-01-16",
        "day": "الجمعة",
        "exercise": "60",
        "gained": "2000",
        "burned": "600",
        "build": "1.5",
        "maint": "1.0",
        "cumBuild": "84%",
        "cumMaint": "90%",
        "weight": "75.2",
        "targetMax": "78.0",
        "targetMin": "72.0"
      },
      {
        "date": "2024-01-15",
        "day": "الخميس",
        "exercise": "40",
        "gained": "2150",
        "burned": "400",
        "build": "1.1",
        "maint": "0.8",
        "cumBuild": "81%",
        "cumMaint": "87%",
        "weight": "75.6",
        "targetMax": "78.0",
        "targetMin": "72.0"
      },
      {
        "date": "2024-01-14",
        "day": "الأربعاء",
        "exercise": "25",
        "gained": "1800",
        "burned": "250",
        "build": "0.7",
        "maint": "0.6",
        "cumBuild": "79%",
        "cumMaint": "85%",
        "weight": "75.9",
        "targetMax": "78.0",
        "targetMin": "72.0"
      },
      {
        "date": "2024-01-13",
        "day": "الثلاثاء",
        "exercise": "50",
        "gained": "2250",
        "burned": "500",
        "build": "1.3",
        "maint": "0.9",
        "cumBuild": "83%",
        "cumMaint": "89%",
        "weight": "75.4",
        "targetMax": "78.0",
        "targetMin": "72.0"
      },
    ];

    return mockData.map((data) {
      return DataRow(
        cells: [
          _buildCell(data["date"]!),
          _buildCell(data["day"]!),
          _buildCell(data["exercise"]!),
          _buildCell(data["gained"]!),
          _buildCell(data["burned"]!),
          _buildCell(data["build"]!),
          _buildCell(data["maint"]!),
          _buildCell(data["cumBuild"]!),
          _buildCell(data["cumMaint"]!),
          _buildCell(data["weight"]!),
          _buildCell(data["targetMax"]!),
          _buildCell(data["targetMin"]!),
        ],
      );
    }).toList();
  }

  /// 🔤 Build individual cell
  DataCell _buildCell(String text, {bool isBold = false}) {
    return DataCell(
      Center(
        child: Text(
          text,
          textAlign: TextAlign.center,
          maxLines: 3,
          style: _getCellTextStyle(isBold),
        ),
      ),
    );
  }

  /// 📝 Header text style
  TextStyle _getHeadingTextStyle() {
    return AppTextStyles.font16DarkGreyWeight400.copyWith(
      color: AppColorsManager.backGroundColor,
      fontWeight: FontWeight.w600,
      fontSize: 15.sp,
    );
  }

  /// 📝 Cell text style
  TextStyle _getCellTextStyle(bool isBold) {
    return AppTextStyles.font12blackWeight400.copyWith(
      fontWeight: FontWeight.w500,
      fontSize: isBold ? 14.sp : 15.sp,
      color: !isBold ? Colors.black : AppColorsManager.mainDarkBlue,
    );
  }
}
