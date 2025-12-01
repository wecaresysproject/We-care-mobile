import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_care/core/di/dependency_injection.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/nutration/data/models/single_nutrient_model.dart';
import 'package:we_care/features/nutration/data/repos/nutration_data_entry_repo.dart';
import 'package:we_care/features/nutration/nutration_data_entry/logic/cubit/nutration_data_entry_cubit.dart';

class NutrientAnalysisView extends StatelessWidget {
  final String targetNutrient;
  final String dietInput;

  const NutrientAnalysisView({
    super.key,
    required this.targetNutrient,
    required this.dietInput,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<NutrationDataEntryCubit>(
      create: (_) =>
          NutrationDataEntryCubit(getIt<NutrationDataEntryRepo>(), context)
            ..analyzeSingleNutrient(
              targetNutrient: targetNutrient,
              dietInput: dietInput,
            ),
      child: Scaffold(
        appBar: AppBar(
          title: Text("تحليل $targetNutrient"),
          backgroundColor: AppColorsManager.mainDarkBlue,
        ),
        body: BlocBuilder<NutrationDataEntryCubit, NutrationDataEntryState>(
          builder: (context, state) {
            /// ---------- 🔄 Loading ----------
            if (state.submitNutrationDataStatus == RequestStatus.loading) {
              return _buildLoadingView();
            }

            /// ---------- ❌ Error ----------
            if (state.submitNutrationDataStatus == RequestStatus.failure) {
              return _buildErrorView(state.message);
            }

            /// ---------- 🎯 Success ----------
            if (state.submitNutrationDataStatus == RequestStatus.success &&
                state.singleNutrientModel != null) {
              return _buildResultTable(
                  state.singleNutrientModel!, targetNutrient);
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

  Widget _buildErrorView(String msg) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, color: Colors.red, size: 48),
            SizedBox(height: 12),
            Text("حدث خطأ: $msg",
                style: TextStyle(fontSize: 16, color: Colors.red)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {}, // ممكن نعمل retry
              child: const Text("إعادة المحاولة"),
            )
          ],
        ),
      );

  /// 📊 جدول إظهار نتائج Single Nutrient Model
  Widget _buildResultTable(SingleNutrientModel model, String targetNutrient) {
    return Padding(
      padding: const EdgeInsets.all(14),
      child: Column(
        children: [
          Text(
            "الإجمالي اليومي: ${model.totalNutrientIntake.toStringAsFixed(2)}",
            style: AppTextStyles.font20blackWeight600,
          ),
          const SizedBox(height: 18),

          /// ---------- 📌 جدول البيانات ----------
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                headingRowColor:
                    WidgetStateProperty.all(AppColorsManager.mainDarkBlue),
                columns: [
                  DataColumn(label: Text("اسم الصنف الغذائي", style: _header)),
                  DataColumn(
                    label: Text(
                      "الكمية\n(جم/مل)",
                      textAlign: TextAlign.center,
                      style: _header,
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      "كمية $targetNutrient لكل\n100 جم",
                      style: _header,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      "كمية $targetNutrient\nالفعلية",
                      style: _header,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
                rows: model.items.map(
                  (item) {
                    return DataRow(
                      cells: [
                        _cell(item.name),
                        _cell("${item.quantityGrams.toStringAsFixed(1)} g"),
                        _cell("${item.nutrientPer100g}"),
                        _cell(item.nutrientIntake.toStringAsFixed(2)),
                      ],
                    );
                  },
                ).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ========= STYLES =========

  static const _header = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.bold,
    fontSize: 13,
  );

  DataCell _cell(String text) => DataCell(
        Center(
          child: Text(text, style: const TextStyle(fontSize: 13)),
        ),
      );
}
