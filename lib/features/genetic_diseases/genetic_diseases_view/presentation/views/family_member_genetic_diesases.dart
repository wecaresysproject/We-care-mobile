import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/font_weight_helper.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/details_view_app_bar.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/core/routing/routes.dart';

class FamilyMemberGeneticDiseases extends StatelessWidget {
  const FamilyMemberGeneticDiseases({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
      ),
      body: SingleChildScrollView
      (
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
             DetailsViewAppBar(title: 'مصطفي'),
              verticalSpacing(24),
              Text(
                "“عند الضغط على المرض الوراثى تظهر جميع التفاصيل ”",
                textAlign: TextAlign.center,
                maxLines: 2,
                style: AppTextStyles.font22MainBlueWeight700.copyWith(
                  color: AppColorsManager.textColor,
                  fontFamily: "Rubik",
                  fontSize: 20.sp,
                  fontWeight: FontWeightHelper.medium,
                ),
              ),
              verticalSpacing(20),
              Center(
                child: Text(
                 "الخال : مصطفي",
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  style: AppTextStyles.font20blackWeight600.copyWith(
                    color: AppColorsManager.mainDarkBlue,
                  
                    fontWeight: FontWeightHelper.medium,
                  ),
                ),
              ),
          
              verticalSpacing(20),
              GeneticDiseaseTable()
            ],
          ),
        ),
      )
    );
  }
}

class GeneticDiseaseTable extends StatelessWidget {
  final List<Map<String, String>> mockData = [
    {
      'disease': 'فقر الدم المنجلي',
      'inheritance': 'جسمي متنحي',
      'risk': 'مرتفع',
    },
    {
      'disease': 'التليف الكيسي',
      'inheritance': 'جسمي متنحي',
      'risk': 'متوسط',
    },
    {
      'disease': 'هيموفيليا أ',
      'inheritance': 'مرتبط بالجنس',
      'risk': 'مرتفع',
    },
  ];

  GeneticDiseaseTable({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: DataTable(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        headingRowColor: MaterialStateProperty.all(
            const Color(0xFF014C8A)), // Header Background Color
        headingTextStyle: TextStyle(
            color: Colors.white, fontWeight: FontWeight.bold), // Header Text
        columnSpacing: 9.5.w,
        dataRowHeight: 70.h,
        horizontalMargin: 10.w,
        showBottomBorder: true,
        border: TableBorder.all(
          borderRadius: BorderRadius.circular(16.r),
          color: const Color(0xff909090),
          width: 0.3,
        ),
        columns: [
          _buildDataColumn("المرض الوراثي"),
          _buildDataColumn("نوع الوراثة"),
          _buildDataColumn("مستوى المخاطرة"),
        ],
        rows: mockData.map((data) {
          return DataRow(
            cells: [
              _buildDataCellCenter(data['disease']!,context,isActive: true),
              _buildDataCellCenter(data['inheritance']!,context,isActive: false),
              DataCell(
                Center(
                  child: Text(
                    data['risk']!,
                    maxLines: 3,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.red, // Highlight risk level in red
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  DataColumn _buildDataColumn(String title) {
    return DataColumn(
      headingRowAlignment: MainAxisAlignment.center,
      label: Center(
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.white,
            fontSize: 16.sp,
          ),
        ),
      ),
    );
  }

  DataCell _buildDataCellCenter(String text,BuildContext context, {int maxLines = 3 ,required bool isActive}) {
    return DataCell(
      Center(
        child: Text(
          text,
          maxLines: maxLines,
          textAlign: TextAlign.center,
          style: TextStyle(
            color:isActive?AppColorsManager.mainDarkBlue: Colors.black87,
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            decoration: isActive?TextDecoration.underline:TextDecoration.none,
          ),
        ),
      ),
      onTap: () {
        Navigator.pushNamed(context, Routes.familyMemberGeneticDiseaseDetailsView,);
        },
    );
  }
}
