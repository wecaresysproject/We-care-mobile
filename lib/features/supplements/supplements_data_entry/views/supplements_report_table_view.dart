import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/di/dependency_injection.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/app_toasts.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/custom_app_bar_with_centered_title_widget.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/supplements/data/models/supplement_follow_up_row_model.dart';
import 'package:we_care/features/supplements/data/repos/supplements_data_entry_repo.dart';
import 'package:we_care/features/supplements/supplements_data_entry/logic/supplements_data_entry_cubit.dart';
import 'package:we_care/features/supplements/supplements_data_entry/logic/supplements_data_entry_state.dart';

class SupplementsReportTableView extends StatelessWidget {
  final String date;
  const SupplementsReportTableView({super.key, required this.date});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SupplementsDataEntryCubit>(
      create: (context) =>
          SupplementsDataEntryCubit(getIt<SupplementsDataEntryRepo>())
            ..getSupplementTableData(date: date),
      child: Scaffold(
        appBar: AppBar(toolbarHeight: 0),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              const AppBarWithCenteredTitle(
                title: "تقرير المتابعة",
                showActionButtons: false,
              ),
              verticalSpacing(12),
              BlocConsumer<SupplementsDataEntryCubit,
                  SupplementsDataEntryState>(
                listener: (context, state) {
                  if (state.message.isNotEmpty &&
                      state.supplementTableStatus == RequestStatus.failure) {
                    showError(state.message);
                  }
                },
                builder: (context, state) {
                  return _buildDataTableByState(state, context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDataTableByState(
      SupplementsDataEntryState state, BuildContext context) {
    switch (state.supplementTableStatus) {
      case RequestStatus.loading:
        return _buildLoadingState();
      case RequestStatus.success:
        return _buildSuccessState(state.supplementTableRows, context);
      case RequestStatus.failure:
        return _buildErrorState(state.message, context);
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildLoadingState() {
    return Container(
      height: 300.h,
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xff909090), width: 0.19),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text(
              "جاري تحميل البيانات...",
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(String errorMessage, BuildContext context) {
    return Container(
      height: 300.h,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.red.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(8),
        color: Colors.red.withOpacity(0.05),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, color: Colors.red, size: 48.sp),
            SizedBox(height: 16.h),
            Text(
              "خطأ في تحميل البيانات",
              style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.red),
            ),
            SizedBox(height: 8.h),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                errorMessage,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
              ),
            ),
            SizedBox(height: 20.h),
            ElevatedButton(
              onPressed: () => context
                  .read<SupplementsDataEntryCubit>()
                  .getSupplementTableData(date: date),
              child: const Text(
                "إعادة المحاولة",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuccessState(
      List<SupplementFollowUpRowModel> data, BuildContext context) {
    if (data.isEmpty) {
      return _buildEmptyState();
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        headingRowColor: WidgetStateProperty.all(AppColorsManager.mainDarkBlue),
        columnSpacing: _getResponsiveColumnSpacing(context),
        dataRowMaxHeight: 70,
        horizontalMargin: _getResponsiveColumnSpacing(context),
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
          DataColumn(label: Text("العنصر")),
          DataColumn(label: Text("اليوم")),
          DataColumn(label: Text("متوسط احتياج يومي")),
          DataColumn(label: Text("متوسط احتياج تراكمي")),
          DataColumn(label: Text("الفرق التراكمي")),
        ],
        rows: data.map((item) {
          final diffColor = _getDifferenceColor(item.difference ?? 0);

          return DataRow(
            cells: [
              _cell(item.nutrient, isVitaminNameCell: true),
              _cell((item.value ?? 0).toStringAsFixed(1)),
              _cell((item.standard ?? 0).toStringAsFixed(1)),
              _cell((item.accumulativeStandard ?? 0).toStringAsFixed(1)),
              _cell((item.difference ?? 0).toStringAsFixed(1),
                  color: diffColor),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      height: 200.h,
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xff909090), width: 0.19),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Center(
        child: Text(
          "لا توجد فيتامينات أو بيانات تغذية لهذا التاريخ.",
        ),
      ),
    );
  }

  DataCell _cell(String text, {bool isVitaminNameCell = false, Color? color}) {
    return DataCell(
      Center(
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: AppTextStyles.font12blackWeight400.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: 13.sp,
            color: color ??
                (isVitaminNameCell
                    ? AppColorsManager.mainDarkBlue
                    : Colors.black),
          ),
        ),
      ),
    );
  }

  Color _getDifferenceColor(double difference) {
    if (difference > 0) {
      return const Color(0xff0D3FBE); // Blue for surplus
    } else if (difference < 0) {
      return Colors.red; // Red for deficit
    } else {
      return Colors.black;
    }
  }

  double _getResponsiveColumnSpacing(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    if (width <= 360) {
      return 8;
    } else if (width <= 480) {
      return 12;
    } else if (width <= 600) {
      return 16;
    } else if (width <= 800) {
      return 24;
    } else if (width <= 1200) {
      return 28;
    } else {
      return 32;
    }
  }

  TextStyle _getHeadingTextStyle() {
    return AppTextStyles.font16DarkGreyWeight400.copyWith(
      color: AppColorsManager.backGroundColor,
      fontWeight: FontWeight.w600,
      fontSize: 13.sp,
    );
  }
}
