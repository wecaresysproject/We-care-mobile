import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/di/dependency_injection.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
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
    return data.map((item) {
      return DataRow(
        cells: [
          _buildCell(item.date),
          _buildCell(item.day),
          _buildCell(item.exerciseMinutes.toString()),
          _buildCell(item.consumedCalories.toString()),
          _buildCell(item.burnedCalories.toString()),
          _buildCell(item.muscleBuildingUnits.toString()),
          _buildCell(item.muscleMaintenanceUnits.toString()),
          _buildCell("${item.muscleBuildingPercentage.toStringAsFixed(1)}%"),
          _buildCell("${item.muscleMaintenancePercentage.toStringAsFixed(1)}%"),
          _buildCell(item.currentWeight.toString()),
          _buildCell(item.targetWeightMax.toStringAsFixed(1)),
          _buildCell(item.targetWeightMin.toStringAsFixed(1)),
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
