import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import '../widgets/quality_of_life_app_bar.dart';

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
                  Text(
                    "تفاصيل السجلات",
                    style: AppTextStyles.font18blackWight500,
                  ),
                  SizedBox(height: 16.h),
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
        headingRowColor: WidgetStateProperty.all(AppColorsManager.mainDarkBlue),
        columnSpacing: 20.w,
        headingTextStyle: AppTextStyles.font14whiteWeight600,
        dataTextStyle: AppTextStyles.font14blackWeight400,
        border: TableBorder.all(
          color: const Color(0xff909090),
          width: 0.19,
          borderRadius: BorderRadius.circular(8.r),
        ),
        columns: const [
          DataColumn(label: Text("السؤال")),
          DataColumn(label: Text("الإجابة")),
        ],
        rows: _buildDummyRows(),
      ),
    );
  }

  List<DataRow> _buildDummyRows() {
    final dummyData = [
      {"q": "كيف تقيم صحتك الجسدية العامة؟", "a": "جيدة"},
      {"q": "هل عانيت من صداع أو دوخة؟", "a": "لا"},
      {"q": "هل شعرت بتعب أو إرهاق؟", "a": "أحياناً"},
      {"q": "كيف تقيم جودة نومك؟", "a": "ممتازة"},
      {"q": "هل مارست نشاطاً بدنياً؟", "a": "نعم"},
    ];

    return dummyData
        .map((data) => DataRow(
              cells: [
                DataCell(
                  SizedBox(
                    width: 200.w,
                    child: Text(data["q"]!, maxLines: 2, overflow: TextOverflow.ellipsis),
                  ),
                ),
                DataCell(Text(data["a"]!)),
              ],
            ))
        .toList();
  }
}
