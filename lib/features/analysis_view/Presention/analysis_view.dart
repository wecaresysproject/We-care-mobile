import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/analysis_view/Presention/analysis_details_view.dart';
import 'package:we_care/features/x_ray_view/Presentation/views/widgets/search_filter_widget.dart';
import 'package:we_care/features/x_ray_view/Presentation/views/widgets/x_ray_data_view_app_bar.dart';
import 'package:we_care/features/x_ray_view/Presentation/views/x_ray_view.dart';

class MedicalAnalysisView extends StatelessWidget {
  final List<Map<String, String>> tableData = [
    {
      "date": "4/7/2024",
      "name": "صوديوم",
      "code": "NA",
      "standard": "39",
      "result": "1307"
    },
    {
      "date": "4/7/2024",
      "name": "صوديوم",
      "code": "CBC",
      "standard": "39",
      "result": "1307"
    },
    {
      "date": "4/7/2024",
      "name": "سرعة ترسيب كرات الدم الحمراء",
      "code": "CBC",
      "standard": "39",
      "result": "1307"
    },
    {
      "date": "4/7/2024",
      "name": "صوديوم",
      "code": "NA",
      "standard": "39",
      "result": "1307"
    },
    {
      "date": "4/7/2024",
      "name": "صوديوم",
      "code": "NA",
      "standard": "39",
      "result": "1307"
    },
    {
      "date": "4/7/2024",
      "name": "الهرمون المحفز للغدة الدرقية",
      "code": "NA",
      "standard": "39",
      "result": "1307"
    },
    {
      "date": "4/7/2024",
      "name": "صوديوم",
      "code": "NA",
      "standard": "39",
      "result": "1307"
    },
  ];

  MedicalAnalysisView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            ViewAppBar(),
            Row(
              children: [
                SearchFilterWidget(
                  filterTitle: 'السنة',
                  isYearFilter: true,
                  filterList:
                      List.generate(20, (index) => (2010 + index).toString()),
                ),
                Spacer(),
                CustomAppContainer(label: 'العدد', value: 10)
              ],
            ),
            verticalSpacing(8),
            Text(
              "اضغط على التاريخ لعرض التحليل\nاضغط على النتيجة لعرض تحاليك المماثلة",
              style: AppTextStyles.customTextStyle,
              textAlign: TextAlign.center,
            ),
            verticalSpacing(16),
            Expanded(
              flex: 12,
              child: buildTable(context),
            ),
            verticalSpacing(16),
            XRayDataViewFooterRow(),
            Spacer(
              flex: 1,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTable(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical, // Allow scrolling if needed
      child: DataTable(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        headingRowColor: WidgetStateProperty.all(
            Color(0xFF014C8A)), // Header Background Color
        headingTextStyle: TextStyle(
            color: Colors.white, fontWeight: FontWeight.bold), // Header Text
        columnSpacing: 23.w,
        dataRowHeight: 60,
        border: TableBorder.all(
          borderRadius: BorderRadius.circular(16.r),
          color: Color(0xff909090),
          width: .3,
        ),
        columns: [
          DataColumn(
              headingRowAlignment: MainAxisAlignment.center,
              label: Center(
                  child: Text(
                "التاريخ",
                textAlign: TextAlign.center,
                style: AppTextStyles.font16DarkGreyWeight400.copyWith(
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                    fontSize: 15.sp),
              ))),
          DataColumn(
              headingRowAlignment: MainAxisAlignment.center,
              label: Center(
                  child: Text(
                "الاسم",
                textAlign: TextAlign.center,
                style: AppTextStyles.font16DarkGreyWeight400.copyWith(
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                    fontSize: 15.sp),
              ))),
          DataColumn(
              headingRowAlignment: MainAxisAlignment.center,
              label: Center(
                child: Text(
                  "الرمز",
                  textAlign: TextAlign.center,
                  style: AppTextStyles.font16DarkGreyWeight400.copyWith(
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                      fontSize: 15.sp),
                ),
              )),
          DataColumn(
              headingRowAlignment: MainAxisAlignment.center,
              label: Center(
                  child: Text(
                "المعيار",
                textAlign: TextAlign.center,
                style: AppTextStyles.font16DarkGreyWeight400.copyWith(
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                    fontSize: 15.sp),
              ))),
          DataColumn(
              headingRowAlignment: MainAxisAlignment.center,
              label: Center(
                  child: Text(
                "النتيجة",
                textAlign: TextAlign.center,
                style: AppTextStyles.font16DarkGreyWeight400.copyWith(
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                    fontSize: 15.sp),
              ))),
        ],
        rows: tableData.map((data) {
          return DataRow(cells: [
            DataCell(
              Center(
                child: Text(data["date"]!,
                    maxLines: 3,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColorsManager.mainDarkBlue,
                      decoration: TextDecoration.underline,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    )),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AnalysisDetailsView(),
                  ),
                );
              },
            ),
            DataCell(Center(
              child: Text(
                data["name"]!,
                maxLines: 2,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            )),
            DataCell(Center(
              child: Text(
                data["code"]!,
                maxLines: 3,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            )),
            DataCell(Center(
              child: Text(
                data["standard"]!,
                maxLines: 3,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            )),
            DataCell(
              Center(
                child: Text(data["result"]!,
                    maxLines: 3,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: AppColorsManager.mainDarkBlue,
                        decoration: TextDecoration.underline,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600)),
              ),
            ),
          ]);
        }).toList(),
      ),
    );
  }
}

class CustomAppContainer extends StatelessWidget {
  const CustomAppContainer({
    super.key,
    required this.label,
    required this.value,
  });

  final String label;
  final int value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColorsManager.secondaryColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: AppTextStyles.font12blackWeight400
                .copyWith(fontWeight: FontWeight.w500),
          ),
          horizontalSpacing(8),
          Text(
            value.toString(),
            style: AppTextStyles.font16DarkGreyWeight400
                .copyWith(color: AppColorsManager.mainDarkBlue),
          ),
        ],
      ),
    );
  }
}
