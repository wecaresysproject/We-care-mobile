import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/custom_app_bar_with_centered_title_widget.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/nutration/data/models/single_nutrient_model.dart';

class NutrientItemsView extends StatelessWidget {
  final List<NutrientItem> items;

  const NutrientItemsView({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SelectionArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 48),
          child: Column(
            children: [
              AppBarWithCenteredTitle(
                title: "Nutrient Details",
                showActionButtons: false,
                onbackArrowPress: () => Navigator.pop(context),
              ),
              verticalSpacing(20),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      headingRowColor: WidgetStateProperty.all(
                          AppColorsManager.mainDarkBlue),
                      columnSpacing: context.screenWidth * 0.09,
                      horizontalMargin: 10,
                      dividerThickness: 0.83,
                      headingTextStyle: _headingTextStyle(),
                      showBottomBorder: true,
                      dataRowMaxHeight: 85,
                      border: TableBorder.all(
                        style: BorderStyle.solid,
                        borderRadius: BorderRadius.circular(8.r),
                        color: const Color(0xff909090),
                        width: 0.15,
                      ),
                      columns: [
                        _column("Food Name"),
                        _column("Analysis Method"),
                        _column("Recipe Source"),
                        _column("USDA FDC ID"),
                        _column("USDA Description"),
                      ],
                      rows: items.map((item) {
                        return DataRow(
                          cells: [
                            _cell(item.name, context),
                            _cell(item.analysisMethod ?? "N/A", context),
                            _cell(item.recipeSource ?? "N/A", context),
                            _cell(item.usdaFdcId ?? "N/A", context),
                            _cell(item.usdaDescription ?? "N/A", context),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Column (Same UI/style as LabTestTable / NutrientAnalysisView)
  DataColumn _column(String label) {
    return DataColumn(
      label: Expanded(
        child: Text(
          label,
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          maxLines: 3,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  /// Cell Style (matching LabTestTable / NutrientAnalysisView)
  DataCell _cell(String value, BuildContext context) {
    return DataCell(
      GestureDetector(
        onTap: () {
          Clipboard.setData(ClipboardData(text: value));
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("تم النسخ: $value"),
              duration: const Duration(seconds: 1),
            ),
          );
        },
        child: Center(
          child: SizedBox(
            width: 80.w, // Slightly wider for potentially longer text
            child: Text(
              value,
              textAlign: TextAlign.center,
              maxLines: 5,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Table Header Style (same as LabTestTable / NutrientAnalysisView)
  TextStyle _headingTextStyle() =>
      AppTextStyles.font16DarkGreyWeight400.copyWith(
        color: AppColorsManager.backGroundColor,
        fontWeight: FontWeight.w600,
        fontSize: 14,
      );
}
