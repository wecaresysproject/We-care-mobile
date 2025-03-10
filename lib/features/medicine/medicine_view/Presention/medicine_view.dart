import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/medicine/medicine_view/Presention/medicine_details_view.dart';
import 'package:we_care/features/prescription/Presentation_view/views/prescription_view.dart';
import 'package:we_care/features/x_ray/x_ray_view/Presentation/views/widgets/x_ray_data_filters_row.dart';
import 'package:we_care/features/x_ray/x_ray_view/Presentation/views/widgets/x_ray_data_view_app_bar.dart';

class MedicinesView extends StatelessWidget {
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

  MedicinesView({super.key});

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
                FilterConfig(title: ' الاسم', options: []),
              ],
              onApply: (selectedFilters) {
                // Handle apply button action
              },
            ),
            verticalSpacing(24),
            Text(
              "“اضغط على اسم الدواء لعرض تفاصيله”",
              style: AppTextStyles.customTextStyle,
              textAlign: TextAlign.center,
            ),
            verticalSpacing(16),
            Expanded(flex: 9, child: MedicineTable()),
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
}

class MedicineTable extends StatelessWidget {
  const MedicineTable({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Medicine> tableData = [
      Medicine(
          date: '25/5/2025',
          name: 'Augmentin',
          duration: 'أسبوع',
          chronicDisease: 'لا'),
      Medicine(
          date: '25/5/2025',
          name: 'Clavulanic acid',
          duration: 'دائم',
          chronicDisease: 'نعم'),
      Medicine(
          date: '25/5/2025',
          name: 'Augmentin',
          duration: 'أسبوع',
          chronicDisease: 'لا'),
      Medicine(
          date: '25/5/2025',
          name: 'Amoclav',
          duration: '30 يوم',
          chronicDisease: 'لا'),
      Medicine(
          date: '25/5/2025',
          name: 'Augmentin',
          duration: 'أسبوع',
          chronicDisease: 'لا'),
      Medicine(
          date: '25/5/2025',
          name: 'Augmentin',
          duration: 'أسبوع',
          chronicDisease: 'لا'),
      Medicine(
          date: '25/5/2025',
          name: 'Augmentin',
          duration: 'أسبوع',
          chronicDisease: 'لا'),
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.vertical, // Allow scrolling if needed
      child: DataTable(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        headingRowColor: WidgetStateProperty.all(
            AppColorsManager.mainDarkBlue), // Header Background Color

        columnSpacing: 4.w,
        dataRowHeight: 60.h,
        horizontalMargin: 9,
        showBottomBorder: true,
        border: TableBorder.all(
          borderRadius: BorderRadius.circular(16.r),
          color: Color(0xff909090),
          width: .3,
        ),
        columns: [
          DataColumn(
              headingRowAlignment: MainAxisAlignment.center,
              label: Text(
                "التاريخ",
                textAlign: TextAlign.center,
                style: AppTextStyles.font14whiteWeight600,
              )),
          DataColumn(
              headingRowAlignment: MainAxisAlignment.center,
              label: FittedBox(
                fit: BoxFit.scaleDown,
                child: Center(
                    child: Text(
                  "اسم الدواء",
                  textAlign: TextAlign.center,
                  style: AppTextStyles.font14whiteWeight600,
                )),
              )),
          DataColumn(
              headingRowAlignment: MainAxisAlignment.center,
              label: FittedBox(
                fit: BoxFit.scaleDown,
                child: Center(
                  child: Text(
                    "مدة العلاج",
                    textAlign: TextAlign.center,
                    style: AppTextStyles.font14whiteWeight600,
                  ),
                ),
              )),
          DataColumn(
              headingRowAlignment: MainAxisAlignment.center,
              label: FittedBox(
                fit: BoxFit.scaleDown,
                child: Center(
                    child: Text(
                  "امراض مزمنة",
                  textAlign: TextAlign.center,
                  style: AppTextStyles.font14whiteWeight600,
                )),
              )),
        ],
        rows: tableData.map((data) {
          return DataRow(cells: [
            DataCell(
              Center(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(data.date,
                      maxLines: 1,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                      )),
                ),
              ),
            ),
            DataCell(
                Center(
                  child: Text(
                    data.name,
                    style: AppTextStyles.font14whiteWeight600.copyWith(
                        color: AppColorsManager.mainDarkBlue,
                        decoration: TextDecoration.underline),
                  ),
                ), onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return MedicineDetailsView();
              }));
            }),
            DataCell(Center(
              child: Text(data.duration,
                  style: AppTextStyles.font14whiteWeight600
                      .copyWith(color: AppColorsManager.textColor)),
            )),
            DataCell(Center(
              child: Text(
                data.chronicDisease,
                style: AppTextStyles.font14whiteWeight600
                    .copyWith(color: AppColorsManager.textColor),
              ),
            )),
          ]);
        }).toList(),
      ),
    );
  }
}

// class MedicineTable extends StatelessWidget {
//   const MedicineTable({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final List<Medicine> medicines = [
//       Medicine(
//           date: '25/5/2025',
//           name: 'Augmentin',
//           duration: 'أسبوع',
//           chronicDisease: 'لا'),
//       Medicine(
//           date: '25/5/2025',
//           name: 'Clavulanic acid',
//           duration: 'دائم',
//           chronicDisease: 'نعم'),
//       Medicine(
//           date: '25/5/2025',
//           name: 'Augmentin',
//           duration: 'أسبوع',
//           chronicDisease: 'لا'),
//       Medicine(
//           date: '25/5/2025',
//           name: 'Amoclav',
//           duration: '30 يوم',
//           chronicDisease: 'لا'),
//       Medicine(
//           date: '25/5/2025',
//           name: 'Augmentin',
//           duration: 'أسبوع',
//           chronicDisease: 'لا'),
//       Medicine(
//           date: '25/5/2025',
//           name: 'Augmentin',
//           duration: 'أسبوع',
//           chronicDisease: 'لا'),
//       Medicine(
//           date: '25/5/2025',
//           name: 'Augmentin',
//           duration: 'أسبوع',
//           chronicDisease: 'لا'),
//     ];

//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: Column(
//         children: [
//           _buildTableHeader(),
//           const SizedBox(height: 8),
//           Expanded(
//             child: ListView.builder(
//               itemCount: medicines.length,
//               itemBuilder: (context, index) {
//                 return _buildMedicineRow(medicines[index]);
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   /// Builds the table header
//   Widget _buildTableHeader() {
//     return Container(
//       padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 8.w),
//       decoration: BoxDecoration(
//         color: AppColorsManager.mainDarkBlue,
//         borderRadius: BorderRadius.circular(24.r),
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Center(
//               child:
//                   Text('التاريخ', style: AppTextStyles.font14whiteWeight600)),
//           Spacer(),
//           Center(
//               child: Text('اسم الدواء',
//                   style: AppTextStyles.font14whiteWeight600)),
//           Spacer(),
//           Center(
//               child: Text('مدة العلاج',
//                   style: AppTextStyles.font14whiteWeight600)),
//           Spacer(),
//           Center(
//               child: FittedBox(
//             fit: BoxFit.scaleDown,
//             child: Center(
//                 child: Text('أمراض مزمنة',
//                     style: AppTextStyles.font14whiteWeight600)),
//           )),
//         ],
//       ),
//     );
//   }

//   /// Builds each medicine row with rounded borders and spacing
//   Widget _buildMedicineRow(Medicine medicine) {
//     return Container(
//       margin: const EdgeInsets.symmetric(vertical: 4), // Space between rows
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(
//           color: Colors.black,
//           width: 0.34,
//         ),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
//         child: Row(
//           // mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Center(child: Text(medicine.date)),
//             Spacer(),
//             Center(
//               child: InkWell(
//                 onTap: () {
//                   // Navigate or show details
//                 },
//                 child: FittedBox(
//                   fit: BoxFit.scaleDown,
//                   child: Text(
//                     medicine.name,
//                     style: const TextStyle(
//                         color: AppColorsManager.mainDarkBlue,
//                         decoration: TextDecoration.underline),
//                   ),
//                 ),
//               ),
//             ),
//             Spacer(),
//             Center(child: Text(medicine.duration)),
//             Spacer(),
//             Center(child: Text(medicine.chronicDisease)),
//           ],
//         ),
//       ),
//     );
//   }
// }

class Medicine {
  final String date;
  final String name;
  final String duration;
  final String chronicDisease;

  Medicine({
    required this.date,
    required this.name,
    required this.duration,
    required this.chronicDisease,
  });
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
