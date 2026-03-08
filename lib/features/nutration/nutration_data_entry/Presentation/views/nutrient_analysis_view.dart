import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:share_plus/share_plus.dart';
import 'package:we_care/core/di/dependency_injection.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/custom_app_bar_with_centered_title_widget.dart';
import 'package:we_care/core/global/shared_repo.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/nutration/data/models/single_nutrient_model.dart';
import 'package:we_care/features/nutration/data/repos/nutration_data_entry_repo.dart';
import 'package:we_care/features/nutration/nutration_data_entry/logic/cubit/nutration_data_entry_cubit.dart';

class NutrientAnalysisView extends StatelessWidget {
  final String targetNutrient;
  final String date;

  const NutrientAnalysisView({
    super.key,
    required this.targetNutrient,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<NutrationDataEntryCubit>(
      create: (_) => NutrationDataEntryCubit(
          getIt<NutrationDataEntryRepo>(), context, getIt<AppSharedRepo>())
        ..analyzeSingleNutrient(
          elementName: targetNutrient,
          date: date,
        ),
      child: Scaffold(
        body: BlocBuilder<NutrationDataEntryCubit, NutrationDataEntryState>(
          builder: (context, state) {
            /// ---------- 🔄 Loading ----------
            if (state.submitNutrationDataStatus == RequestStatus.loading) {
              return _buildLoadingView();
            }

            /// ---------- ❌ Error ----------
            if (state.submitNutrationDataStatus == RequestStatus.failure) {
              return _buildErrorView(state.message, context);
            }

            /// ---------- 🎯 Success ----------
            if (state.submitNutrationDataStatus == RequestStatus.success &&
                state.singleNutrientModel != null) {
              return _buildResultTable(
                  state.singleNutrientModel!, targetNutrient, context);
            }

            /// ---------- Initial ----------
            return const Center(child: Text("جارِ التحليل..."));
          },
        ),
      ),
    );
  }

  // 🔥 UI COMPONENTS

  Widget _buildLoadingView() => const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 14),
            Text("جاري تحليل البيانات...", style: TextStyle(fontSize: 16)),
          ],
        ),
      );

  Widget _buildErrorView(String msg, BuildContext context) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, color: Colors.red, size: 48),
            SizedBox(height: 12),
            Text("حدث خطأ: $msg",
                style: TextStyle(fontSize: 16, color: Colors.red)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await context
                    .read<NutrationDataEntryCubit>()
                    .analyzeSingleNutrient(
                      elementName: targetNutrient,
                      date: date,
                    );
              }, // ممكن نعمل retry
              child: const Text(
                "إعادة المحاولة",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            )
          ],
        ),
      );

  Widget _buildResultTable(
      SingleNutrientModel model, String targetNutrient, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 48),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          AppBarWithCenteredTitle(
            title: "تحليل $targetNutrient",
            showShareButtonOnly: true,
            shareFunction: () async {
              await _shareNutrientAnalysis(model, targetNutrient);
            },
          ),
          verticalSpacing(20),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  headingRowColor:
                      WidgetStateProperty.all(AppColorsManager.mainDarkBlue),
                  columnSpacing: context.screenWidth * 0.09,
                  horizontalMargin: 10,
                  dividerThickness: 0.83,
                  headingTextStyle: _headingTextStyle(),
                  showBottomBorder: true,
                  dataRowMaxHeight: 111,
                  border: TableBorder.all(
                    style: BorderStyle.solid,
                    borderRadius: BorderRadius.circular(8.r),
                    color: const Color(0xff909090),
                    width: 0.15,
                  ),
                  columns: [
                    _column("الصنف"),
                    _column("الحصة"),
                    _column("الكمية"),
                    _column("المكون الأساسي"),
                    _column("المتناول"),
                    _column("Analysis Method"),
                    _column("Recipe Source"),
                    _column("USDA FDC ID"),
                    _column("USDA Description"),
                  ],
                  rows: model.items.map((item) {
                    return DataRow(
                      cells: [
                        _cell(item.name),
                        _cell(item.servingSize),
                        _cell(item.amount),
                        _cell(item.mainIngredient ?? "N/A"),
                        _cell(item.nutrientIntake.toStringAsFixed(2)),
                        _cell(item.analysisMethod ?? "N/A"),
                        _cell(item.recipeSource ?? "N/A"),
                        _cell(item.usdaFdcId ?? "N/A"),
                        _cell(item.usdaDescription ?? "N/A"),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            "الإجمالي اليومي لل $targetNutrient في وجباتك: ${model.totalNutrientIntake.toStringAsFixed(2)}",
            style: AppTextStyles.font14BlueWeight700,
            textAlign: TextAlign.start,
          ).paddingSymmetricHorizontal(
            16,
          ),
        ],
      ),
    );
  }

  Future<void> _shareNutrientAnalysis(
      SingleNutrientModel model, String targetNutrient) async {
    final buffer = StringBuffer();

    buffer.writeln("🍽 تحليل $targetNutrient في وجباتك");
    buffer.writeln("──────────────────────────");
    buffer.writeln("🔸 إجمالي المتناول من $targetNutrient: "
        "${model.totalNutrientIntake.toStringAsFixed(2)}");
    buffer.writeln("");

    for (var item in model.items) {
      buffer.writeln("📌 ${item.name}");
      buffer.writeln("• الحصة: ${item.servingSize}");
      buffer.writeln("• الكمية: ${item.amount}");
      buffer.writeln("• المتناول: ${item.nutrientIntake.toStringAsFixed(2)}");
      buffer.writeln("");
    }

    await Share.share(buffer.toString());
  }

  /// Column (Same UI/style as LabTestTable)
  DataColumn _column(String label) {
    return DataColumn(
      label: Expanded(
        child: Text(
          label,
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          maxLines: 3,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  /// Cell Style (matching LabTestTable)
  DataCell _cell(
    String value,
  ) {
    return DataCell(
      Center(
        child: SizedBox(
          width: 62.w,
          child: Text(
            value,
            textAlign: TextAlign.center,
            maxLines: 5,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  /// Table Header Style (same as LabTestTable)
  TextStyle _headingTextStyle() =>
      AppTextStyles.font16DarkGreyWeight400.copyWith(
        color: AppColorsManager.backGroundColor,
        fontWeight: FontWeight.w600,
        fontSize: 14,
      );
}
