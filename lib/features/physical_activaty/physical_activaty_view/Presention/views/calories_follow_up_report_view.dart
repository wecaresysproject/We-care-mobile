import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/di/dependency_injection.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/custom_app_bar_with_centered_title_widget.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/physical_activaty/data/models/physical_activity_day_model.dart';
import 'package:we_care/features/physical_activaty/physical_activaty_view/logic/physical_activaty_view_cubit.dart';

class CaloriesFollowUpReportTableView extends StatelessWidget {
  const CaloriesFollowUpReportTableView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          getIt<PhysicalActivityViewCubit>()..getFollowUpReports(),
      child: Scaffold(
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
              BlocBuilder<PhysicalActivityViewCubit, PhysicalActivatyViewState>(
                builder: (context, state) {
                  if (state.requestStatus == RequestStatus.loading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state.requestStatus == RequestStatus.failure) {
                    return Center(
                      child: Text(
                        state.responseMessage,
                        style: AppTextStyles.font14BlackMedium,
                      ),
                    );
                  } else if (state.followUpReportsRows.isEmpty) {
                    return const Center(child: Text("لا توجد بيانات متاحة"));
                  }
                  return _buildDataTable(context, state.followUpReportsRows);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDataTable(
      BuildContext context, List<PhysicalActivityDayModel> data) {
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
        headingRowHeight: 85.h,
        border: TableBorder.all(
          style: BorderStyle.solid,
          borderRadius: BorderRadius.circular(8),
          color: const Color(0xff909090),
          width: 0.19,
        ),
        columns: _buildColumns(),
        rows: _buildRows(data),
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

  /// Build rows from API data
  List<DataRow> _buildRows(List<PhysicalActivityDayModel> data) {
    final rows = data.map((item) {
      return DataRow(
        cells: [
          _buildCell(item.date),
          _buildCell(item.day),
          _buildCell(formatNumber(item.exerciseMinutes)),
          _buildCell(formatNumber(item.consumedCalories)),
          _buildCell(formatNumber(item.burnedCalories)),
          _buildCell(formatNumber(item.muscleBuildingUnits)),
          _buildCell(formatNumber(item.muscleMaintenanceUnits)),
          _buildCell(formatNumber(item.muscleBuildingPercentage)),
          _buildCell(formatNumber(item.muscleMaintenancePercentage)),
          _buildCell(formatNumber(item.currentWeight)),
          _buildCell(formatNumber(item.targetWeightMax)),
          _buildCell(formatNumber(item.targetWeightMin)),
        ],
      );
    }).toList();

    // ⬇️ إضافة صف المجموع
    final totals = _calculateTotals(data);

    rows.add(
      DataRow(
        color: WidgetStateProperty.all(
          AppColorsManager.secondaryColor.withOpacity(0.25),
        ),
        cells: [
          _buildCell("—", isBold: true),
          _buildCell("الإجمالي", isBold: true),
          _buildCell(formatNumber(totals.exerciseMinutes), isBold: true),
          _buildCell(formatNumber(totals.consumedCalories), isBold: true),
          _buildCell(formatNumber(totals.burnedCalories), isBold: true),
          _buildCell(formatNumber(totals.muscleBuildingUnits), isBold: true),
          _buildCell(formatNumber(totals.muscleMaintenanceUnits), isBold: true),

          // ❌ لا مجموع للنِسَب
          _buildCell("—"),
          _buildCell("—"),

          _buildCell(formatNumber(totals.currentWeight), isBold: true),
          _buildCell(formatNumber(totals.targetWeightMax), isBold: true),
          _buildCell(formatNumber(totals.targetWeightMin), isBold: true),
        ],
      ),
    );

    return rows;
  }

  PhysicalActivityTotals _calculateTotals(List<PhysicalActivityDayModel> data) {
    return PhysicalActivityTotals(
      exerciseMinutes: data.fold(0, (sum, e) => sum + e.exerciseMinutes),
      consumedCalories: data.fold(0, (sum, e) => sum + e.consumedCalories),
      burnedCalories: data.fold(0, (sum, e) => sum + e.burnedCalories),
      muscleBuildingUnits:
          data.fold(0, (sum, e) => sum + e.muscleBuildingUnits),
      muscleMaintenanceUnits:
          data.fold(0, (sum, e) => sum + e.muscleMaintenanceUnits),

      // الوزن غالبًا لا يُجمع → آخر قيمة أو متوسط
      currentWeight: data.isNotEmpty ? data.last.currentWeight : 0,

      // المستهدفات لا تُجمع
      targetWeightMax: data.isNotEmpty ? data.last.targetWeightMax : 0,
      targetWeightMin: data.isNotEmpty ? data.last.targetWeightMin : 0,
    );
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
