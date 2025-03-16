import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/surgeries/surgeries_view/views/surgeries_view.dart';
import 'package:we_care/features/vaccine/vaccine_view/Presention/vaccine_details_view.dart';
import 'package:we_care/features/x_ray/x_ray_view/Presentation/views/widgets/x_ray_data_filters_row.dart';
import 'package:we_care/features/x_ray/x_ray_view/Presentation/views/widgets/x_ray_data_view_app_bar.dart';

class VaccineView extends StatelessWidget {
  final List<Map<String, String>> vaccineData = [
    {
      "date": "4/7/2024",
      "name": "لقاح الجدري المائي",
      "disease": "الحصبة الالماني",
    },
    {
      "date": "4/7/2024",
      "name": "لقاح الجدري المائي",
      "disease": "الحصبة الالماني",
    },
    {
      "date": "4/7/2024",
      "name": "لقاح الجدري المائي",
      "disease": "الحصبة الالماني",
    },
    {
      "date": "4/7/2024",
      "name": "لقاح الجدري المائي",
      "disease": "الحصبة الالماني",
    },
    {
      "date": "4/7/2024",
      "name": "لقاح الجدري المائي",
      "disease": "الحصبة الالماني",
    },
    {
      "date": "4/7/2024",
      "name": "لقاح الجدري المائي",
      "disease": "الحصبة الالماني",
    },
  ];

  VaccineView({super.key});

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
            DataViewFiltersRow(
              filters: [
                FilterConfig(title: 'السنة', options: [], isYearFilter: true),
                FilterConfig(title: 'فئة اللقاح', options: []),
              ],
              onApply: (selectedFilters) {},
            ),
            verticalSpacing(32),
            Expanded(
              flex: 12,
              child: buildTable(context, vaccineData),
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

  Widget buildTable(
      BuildContext context, List<Map<String, String>> vaccinesData) {
    final ScrollController controller = ScrollController();
    return SingleChildScrollView(
      controller: controller,
      scrollDirection: Axis.vertical,
      child: DataTable(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        headingRowColor: WidgetStateProperty.all(
            Color(0xFF014C8A)), // Header Background Color
        headingTextStyle: TextStyle(
            color: Colors.white, fontWeight: FontWeight.bold), // Header Text
        columnSpacing: 9.5.w,
        dataRowHeight: 70.h,
        horizontalMargin: 10.w,
        showBottomBorder: true,
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
                    fontSize: 16.sp),
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
                    fontSize: 16.sp),
              ))),
          DataColumn(
              headingRowAlignment: MainAxisAlignment.center,
              label: Center(
                child: Text(
                  "المرض",
                  textAlign: TextAlign.center,
                  style: AppTextStyles.font16DarkGreyWeight400.copyWith(
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                      fontSize: 16.sp),
                ),
              )),
          DataColumn(
              headingRowAlignment: MainAxisAlignment.center,
              label: Center(
                  child: Text(
                "التفاصيل",
                textAlign: TextAlign.center,
                style: AppTextStyles.font16DarkGreyWeight400.copyWith(
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                    fontSize: 16.sp),
              ))),
        ],
        rows: vaccinesData.map((data) {
          return DataRow(cells: [
            DataCell(
              Center(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(data["date"]!,
                      maxLines: 3,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                      )),
                ),
              ),
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
                data["disease"]!,
                maxLines: 3,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            )),
            DataCell(
              Center(
                  child: Container(
                width: 58.w,
                height: 40.h,
                padding: EdgeInsets.only(top: 8.h, bottom: 10.h),
                decoration: BoxDecoration(
                  color: AppColorsManager.mainDarkBlue,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'عرض',
                      style: AppTextStyles.font22WhiteWeight600
                          .copyWith(fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                    horizontalSpacing(4),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.white,
                      size: 14,
                    ),
                  ],
                ),
              )),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => VaccineDetailsView()),
                );
              },
            ),
          ]);
        }).toList(),
      ),
    );
  }
}
