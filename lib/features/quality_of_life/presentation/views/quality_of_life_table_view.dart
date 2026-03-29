import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/quality_of_life/logic/quality_of_life_cubit.dart';

import '../widgets/quality_of_life_app_bar.dart';
import '../widgets/quality_of_life_filters_row.dart';

class QualityOfLifeTableView extends StatelessWidget {
  const QualityOfLifeTableView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(toolbarHeight: 0),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: const QualityOfLifeAppBar(),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const QualityOfLifeFiltersRow(),
                  verticalSpacing(18),
                  _buildDataTable(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDataTable(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        headingRowColor: WidgetStateProperty.all(AppColorsManager.mainDarkBlue),
        columnSpacing: _getResponsiveColumnSpacing(context),
        dataRowMaxHeight: 78,
        horizontalMargin: _getResponsiveColumnSpacing(context),
        dividerThickness: 0.83,
        headingTextStyle: _getHeadingTextStyle(),
        showBottomBorder: true,
        headingRowHeight: 50.h,
        border: TableBorder.all(
          style: BorderStyle.solid,
          borderRadius: BorderRadius.circular(8.r),
          color: const Color(0xff909090),
          width: 0.19,
        ),
        columns: [
          _buildColumn("السؤال"),
          _buildColumn("الإجابة"),
        ],
        rows: _buildDummyRows(context),
      ),
    );
  }

  double _getResponsiveColumnSpacing(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width <= 360) return 6;
    if (width <= 480) return 10;
    if (width <= 600) return 14;
    return 20;
  }

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
    );
  }

  List<DataRow> _buildDummyRows(BuildContext context) {
    return QualityOfLifeCubit.questions.map((q) {
      return DataRow(
        cells: [
          DataCell(
            Container(
              alignment: Alignment.centerRight,
              width: 220.w,
              child: Text(
                q.question,
                style: _getCellTextStyle(false),
                maxLines: 3,
                overflow: TextOverflow.visible,
                textAlign: TextAlign.right,
                softWrap: true,
              ),
            ),
          ),
          _buildCell(q.answers.first),
        ],
      );
    }).toList();
  }

  DataCell _buildCell(String text, {bool isBold = false}) {
    return DataCell(
      Center(
        child: Text(
          text,
          textAlign: TextAlign.center,
          maxLines: 4,
          style: _getCellTextStyle(isBold),
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
      fontSize: isBold ? 13.sp : 13.5.sp, // 👈 كان 15
      color: !isBold ? Colors.black : AppColorsManager.mainDarkBlue,
    );
  }
}
