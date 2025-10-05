import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/di/dependency_injection.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/app_logger.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/SharedWidgets/custom_app_bar_with_centered_title_widget.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/core/routing/routes.dart';
import 'package:we_care/features/nutration/data/models/nutration_element_table_row_model.dart';
import 'package:we_care/features/nutration/data/repos/nutration_data_entry_repo.dart';
import 'package:we_care/features/nutration/nutration_data_entry/Presentation/views/widgets/custom_gradient_button_widget.dart';
import 'package:we_care/features/nutration/nutration_data_entry/logic/cubit/nutration_data_entry_cubit.dart';

class NutritionFollowUpReportView extends StatelessWidget {
  const NutritionFollowUpReportView({super.key, required this.date});
  final String date;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<NutrationDataEntryCubit>(
      create: (context) =>
          NutrationDataEntryCubit(getIt<NutrationDataEntryRepo>(), context)
            ..getAllNutrationTableData(date: date),
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

              GradientButton(
                onPressed: () {
                  context.pushNamed(Routes.effectOnBodyOrgans);
                },
                text: "التأثير على أعضاء الجسم",
                icon: Icons.person,
              ).paddingFrom(right: 140, bottom: 5),
              // 🔥 BlocBuilder to handle different states
              BlocBuilder<NutrationDataEntryCubit, NutrationDataEntryState>(
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

  // 🎯 Main method to handle different states
  Widget _buildDataTableByState(NutrationDataEntryState state, context) {
    switch (state.dataTableStatus) {
      case RequestStatus.loading:
        return _buildLoadingState();

      case RequestStatus.success:
        return _buildSuccessState(state.nutrationElementsRows);

      case RequestStatus.failure:
        return _buildErrorState(state.message, context);

      default:
        return _buildInitialState();
    }
  }

  // 🔄 Loading State Widget
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

  // ❌ Error State Widget
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
            Icon(
              Icons.error_outline,
              color: Colors.red,
              size: 48.sp,
            ),
            SizedBox(height: 16.h),
            Text(
              "خطأ في تحميل البيانات",
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            SizedBox(height: 8.h),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                errorMessage,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.grey[600],
                ),
              ),
            ),
            SizedBox(height: 20.h),
            ElevatedButton(
              onPressed: () async {
                // Retry loading data
                await context
                    .read<NutrationDataEntryCubit>()
                    .getAllNutrationTableData(date: date);
              },
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

  // 📊 Success State Widget (Main Data Table)
  Widget _buildSuccessState(List<NutritionElement> nutritionData) {
    if (nutritionData.isEmpty) {
      return _buildEmptyState();
    }

    return DataTable(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      headingRowColor: WidgetStateProperty.all(AppColorsManager.mainDarkBlue),
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
      rows: _buildRowsFromData(nutritionData),
    );
  }

  // 📭 Empty State Widget
  Widget _buildEmptyState() {
    return Container(
      height: 200.h,
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xff909090), width: 0.19),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inbox_outlined,
              size: 48.sp,
              color: Colors.grey,
            ),
            SizedBox(height: 16.h),
            Text(
              "لا توجد بيانات تغذية لهذا التاريخ",
              style: TextStyle(
                fontSize: 16.sp,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 🔄 Initial State Widget (rarely used)
  Widget _buildInitialState() {
    return SizedBox(
      height: 100.h,
      child: const Center(
        child: Text("جاري التحضير..."),
      ),
    );
  }

  // 📋 Build table columns
  List<DataColumn> _buildColumns() {
    return [
      _buildColumn("العنصر"),
      _buildColumn("يومي\nفعلي"),
      _buildColumn("يومي\nالمعيار"),
      _buildColumn("تراكمي\nفعلي"),
      _buildColumn("تراكمي\nالمعيار"),
      _buildColumn("الفرق"),
    ];
  }

  // 🎯 Build table rows from actual API data
  List<DataRow> _buildRowsFromData(List<NutritionElement> nutritionData) {
    return nutritionData.map((element) {
      // 🔥 Determine difference color based on the value
      Color diffColor = _getDifferenceColor(
          element.accumulativeActual, element.accumulativeStandard);

      return DataRow(
        cells: [
          _buildCell(
            getRelativeNeededName(element.elementName),
            isBold: true,
            isElement: true,
            isNarrow: true,
          ),
          _buildCell(
            element.dailyActual?.toString() ?? "N/A",
          ), //! check it later

          DataCell(
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  element.dailyStandard?.toString() ?? "N/A",
                  style: _getCellTextStyle(false),
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        AppColorsManager.mainDarkBlue, // 🔵 لون الخلفية
                    foregroundColor: Colors.white, // ⚪ لون النص والأيقونة

                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                    minimumSize: const Size(0, 0), // يمنع الزر من أخذ حجم كبير
                    alignment: Alignment.center,
                    iconAlignment: IconAlignment.start,
                    tapTargetSize:
                        MaterialTapTargetSize.shrinkWrap, // يقلل المساحة
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        8.r,
                      ), // 👈 تحكم في درجة الاستدارة
                    ),
                  ),
                  onPressed: () {
                    AppLogger.debug("تعديل pressed for ${element.elementName}");
                    // ✨ هنا تحط Dialog أو أي أكشن للتعديل
                  },
                  icon: const Icon(
                    Icons.edit,
                    size: 14,
                    color: Colors.white,
                  ),
                  label: Text(
                    "تعديل",
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontStyle: FontStyle.normal,
                      fontFamily: 'Cairo',
                    ),
                  ),
                ),
              ],
            ),
          ),

          _buildCell(element.accumulativeActual?.toString() ??
              "N/A"), //! check it later
          _buildCell(
            element.accumulativeStandard?.toString() ?? "N/A",
          ), //! check it later
          _buildColoredDiff(element.difference?.toString() ?? "N/A",
              diffColor), //! check it later
        ],
      );
    }).toList();
  }

  String getRelativeNeededName(String elementName) {
    switch (elementName) {
      case "الطاقة (سعر حراري)":
        return "السعرات";
      case "البروتين":
        return " بروتين";
      case "الدهون الكلية":
        return "دهون";
      case "الدهون المشبعة":
        return "دهون مشبعة";
      case "الدهون الأحادية غير المشبعة":
        return "دهون أحادية";
      case "الدهون المتعددة غير المشبعة":
        return "دهون متعددة";
      case "الكوليسترول (ملجم)":
        return "كوليسترول";
      case "الكربوهيدرات (جم)":
        return "كربوهيدرات";
      case "الألياف (جم)":
        return "ألياف";
      case "السكريات (جم)":
        return "سكريات";
      case "الصوديوم (ملجم)":
        return "صوديوم";
      case "البوتاسيوم (ملجم)":
        return "بوتاسيوم";
      case "الكالسيوم (ملجم)":
        return "كالسيوم";
      case "الحديد (ملجم)":
        return "حديد";
      case "الماغنيسيوم (ملجم)":
        return "ماغنسيوم";
      case "الزنك (ملجم)":
        return "زنك";
      case "النحاس (ملجم)":
        return "نحاس";
      case "الفسفور (ملجم)":
        return "فسفور";
      case "المنجنيز (ملجم)":
        return "منجنيز";
      case "السيلينيوم (ميكروجم)":
        return "سيلينيوم";
      case "اليود (ميكروجم)":
        return "يود";
      case "فيتامين A (ميكروجم RAE)":
        return "Vit A";
      case "فيتامين D (ميكروجم)":
        return "Vit D";
      case "فيتامين E (ملجم α-TE)":
        return "Vit E";
      case "فيتامين K (ميكروجم)":
        return "Vit K";
      case "فيتامين C (ملجم)":
        return "Vit C";
      case "فيتامين B1 - الثيامين (ملجم)":
        return "Vit B1";
      case "فيتامين B2 - الريبوفلافين (ملجم)":
        return "Vit B2";
      case "فيتامين B3 - النياسين (ملجم)":
        return "Vit B3";
      case "فيتامين B6 (ملجم)":
        return "Vit B6";
      case "الفولات (ميكروجم DFE)":
        return "فولات";
      case "فيتامين B12 (ميكروجم)":
        return "Vit B12";
      case "الكولين (ملجم)":
        return "كولين";
      default:
        return elementName; // fallback لو مش موجود في الماب
    }
  }

  // 🎨 Determine color based on difference value
// 🎨 Determine color based on cumulative values
  Color _getDifferenceColor(
      int? accumulativeActual, int? accumulativeStandard) {
    if (accumulativeActual == null || accumulativeStandard == null) {
      return Colors.black; // fallback
    }

    if (accumulativeActual > accumulativeStandard) {
      return const Color(0xff0D3FBE); // Blue for surplus
    } else if (accumulativeActual < accumulativeStandard) {
      return Colors.red; // Red for deficit
    } else {
      return Colors.black; // Black for equal
    }
  }

  // 📊 Build individual column
  DataColumn _buildColumn(String label) {
    return DataColumn(
      headingRowAlignment: MainAxisAlignment.center, // قلل المسافة بين الأعمدة

      label: Text(
        label,
        textAlign: TextAlign.center,
        style: AppTextStyles.font18blackWight500.copyWith(
          fontSize: 11.5.sp,
          color: Colors.white,
          fontWeight: FontWeight.w700,
        ),
      ),
      numeric: true,
    );
  }

// // 🔤 Build individual cell
  DataCell _buildCell(String text,
      {bool isBold = false, bool isElement = false, bool isNarrow = false}) {
    final style = _getCellTextStyle(isBold);

    return DataCell(
      Center(
        child: SizedBox(
          width: isNarrow ? 62 : null, // 👈 نفس العرض للأعمدة الصغيرة
          child: Text(
            text,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: style,
          ),
        ),
      ),
    );
  }

  // 🎨 Build colored difference cell
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
                : TextDecoration.underline,
            decorationColor: color,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  // 📝 Header text style
  TextStyle _getHeadingTextStyle() {
    return AppTextStyles.font16DarkGreyWeight400.copyWith(
      color: AppColorsManager.backGroundColor,
      fontWeight: FontWeight.w600,
      fontSize: 15.sp,
    );
  }

  // 📝 Cell text style
  TextStyle _getCellTextStyle(bool isBold) {
    return AppTextStyles.font12blackWeight400.copyWith(
      fontWeight: FontWeight.w500,
      fontSize: isBold ? 14.sp : 15.sp,
      color: !isBold ? Colors.black : AppColorsManager.mainDarkBlue,
    );
  }
}
