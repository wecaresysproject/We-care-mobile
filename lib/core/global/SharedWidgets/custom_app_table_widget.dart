import 'package:flutter/material.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';

class LabTestTable extends StatelessWidget {
  const LabTestTable({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        headingRowColor: WidgetStateProperty.all(
          AppColorsManager.mainDarkBlue,
        ),
        columnSpacing: 16.8,
        dataRowMaxHeight: 44.5,
        horizontalMargin: 7,
        dividerThickness: 0.83,
        headingTextStyle: _getHeadingTextStyle(),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(0),
        ),
        showBottomBorder: true,
        border: TableBorder.all(
          style: BorderStyle.solid,
          borderRadius: BorderRadius.circular(8),
          color: const Color(0xff909090),
          width: 0.15,
        ),
        columns: _buildColumns(),
        rows: _buildRows(),
      ),
    );
  }

  List<DataColumn> _buildColumns() {
    return [
      _buildColumn("الاسم"),
      _buildColumn("الرمز"),
      _buildColumn("المعيار", isNumeric: true),
      _buildColumn("النتيجة"),
    ];
  }

  List<DataRow> _buildRows() {
    return [].map((test) {
      return DataRow(
        cells: [
          _buildCell(test.name, isBold: true),
          _buildCell(test.code),
          _buildCell(test.standard),
          DataCell(test.resultWidget),
        ],
      );
    }).toList();
  }

  DataColumn _buildColumn(String label, {bool isNumeric = false}) {
    return DataColumn(
      label: Text(label),
      numeric: isNumeric,
    );
  }

  DataCell _buildCell(String text, {bool isBold = false}) {
    return DataCell(
      Text(
        text,
        textAlign: TextAlign.center,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: _getCellTextStyle(isBold),
      ),
    );
  }

  TextStyle _getHeadingTextStyle() {
    return AppTextStyles.font16DarkGreyWeight400.copyWith(
      color: AppColorsManager.backGroundColor,
      fontWeight: FontWeight.w600,
    );
  }

  TextStyle _getCellTextStyle(bool isBold) {
    return AppTextStyles.font12blackWeight400.copyWith(
      fontWeight: isBold ? FontWeight.w700 : FontWeight.w600,
      fontSize: 12,
    );
  }
}
