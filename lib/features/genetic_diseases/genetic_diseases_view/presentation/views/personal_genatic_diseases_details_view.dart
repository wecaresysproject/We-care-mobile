import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/details_view_app_bar.dart';
import 'package:we_care/core/global/SharedWidgets/details_view_image_with_title.dart';
import 'package:we_care/core/global/SharedWidgets/details_view_info_tile.dart';

class PersonalGenaticDiseasesDetailsView extends StatelessWidget {
  const PersonalGenaticDiseasesDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DetailsViewAppBar(
              title: 'المرض الوراثى',
            ),
            SizedBox(height: 16),
            DefaultTabController(
                length: 2,
                child: Column(
                  children: [
                    TabBar(
                      tabs: [
                        Tab(text: 'المرض الوراثى'),
                        Tab(text: 'معلومات اضافية'),
                      ],
                    ),
                    SizedBox(
                      height:1500, // Adjust height as needed
                      child: TabBarView(
                        children: [
                          PersonalGenaticDiseaseTab(),

                          PersonalGenaticDiseaseExtraInfoTab()
                        ],
                      ),
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }
}

class PersonalGenaticDiseaseExtraInfoTab extends StatelessWidget {
  const PersonalGenaticDiseaseExtraInfoTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 16.h),
          Row(
            children: [
              DetailsViewInfoTile(
                title: "المرض الوراثى",
                value: "هذا النص مثال",
                icon: 'assets/images/tumor_icon.png',
              ),
              Spacer(),
              DetailsViewInfoTile(
                title: 'المرحلة العمرية للظهور',
                value: "هذا النص مثال",
                icon: 'assets/images/time_icon.png',
              ),
            ],
          ),

          SizedBox(height: 16.h),

          Row(
            children: [
              DetailsViewInfoTile(
                title: "التصنيف الطبي للمرض",
                value: "هذا النص مثال",
                icon: 'assets/images/file_icon.png',
              ),
              Spacer(),
              DetailsViewInfoTile(
                title: "نوع الوراثة",
                value: "هذا النص مثال",
                icon: 'assets/images/symptoms_icon.png',
              ),
            ],
          ),

          DetailsViewInfoTile(
            title: "الوصف التفصيلي",
            value: "هذا النص مثال",
            icon: 'assets/images/doctor_name.png',
            isExpanded: true,
          ),
          verticalSpacing(16),
          Row(
            children: [
              Expanded(
                child: DetailsViewInfoTile(
                  title: "الجين المسؤول",
                  value: "هذا النص مثال",
                  icon: 'assets/images/tumor_icon.png',
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: DetailsViewInfoTile(
                  title: "معدل الانتشار",
                  value: "هذا النص مثال",
                  icon: 'assets/images/doctor_icon.png',
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          // Age of Onset and Risk level
          Row(
            children: [
              DetailsViewInfoTile(
                title: "العمر النموذجي للظهور",
                value: "هذا النص مثال",
                icon: 'assets/images/tumor_icon.png',
              ),
              Spacer(),
              DetailsViewInfoTile(
                title: "الجنس المعني",
                value: "هذا النص مثال",
                icon: 'assets/images/symptoms_icon.png',
              ),
            ],
          ),
          SizedBox(height: 16.h),

          Row(
            children: [
              DetailsViewInfoTile(
                title: "الجين المسؤول",
                value: "هذا النص مثال",
                icon: 'assets/images/time_icon.png',
              ),
              Spacer(),
              DetailsViewInfoTile(
                title: 'معدل الانتشار الجغرافي',
                value: "هذا النص مثال",
                icon: 'assets/images/symptoms_icon.png',
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              DetailsViewInfoTile(
                title: "العمر النموذجي للظهور",
                value: "هذا النص مثال",
                icon: 'assets/images/need_icon.png',
              ),
              Spacer(),
              DetailsViewInfoTile(
                title: "الجنس المعني",
                value: "هذا النص مثال",
                icon: 'assets/images/data_search_icon.png',
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              DetailsViewInfoTile(
                title: "مستوى المخاطرة",
                value: "هذا النص مثال",
                icon: 'assets/images/symptoms_icon.png',
              ),
              Spacer(),
              DetailsViewInfoTile(
                title: "تفسير النطاق",
                value: "هذا النص مثال",
                icon: 'assets/images/time_icon.png',
              ),
            ],
          ),
          SizedBox(height: 16.h),
          // Main Symptoms
          DetailsViewInfoTile(
            title: "الأعراض الرئيسية",
            value: "هذا النص مثال",
            icon: 'assets/images/symptoms_icon.png',
            isExpanded: true,
          ),
          verticalSpacing(8),
          CustomContainer(
            value: "هذا النص مثال",
            isExpanded: true,
          ),
          verticalSpacing(8),
          CustomContainer(
            value: "هذا النص مثال",
            isExpanded: true,
          ),

          SizedBox(height: 16.h),

          // Diagnostic Tests
          DetailsViewInfoTile(
            title: "الفحوصات التشخيصية",
            value: "هذا النص مثال",
            icon: 'assets/images/data_search_icon.png',
            isExpanded: true,
          ),
          verticalSpacing(8),
          CustomContainer(
            value: "هذا النص مثال",
            isExpanded: true,
          ),
          verticalSpacing(8),
          CustomContainer(
            value: "هذا النص مثال",
            isExpanded: true,
          ),
          SizedBox(height: 16.h),

          // Available Treatments
          DetailsViewInfoTile(
            title: "العلاجات المتاحة",
            value: "هذا النص مثال",
            icon: 'assets/images/medicine_icon.png',
            isExpanded: true,
          ),
          verticalSpacing(8),
          CustomContainer(
            value: "هذا النص مثال",
            isExpanded: true,
          ),
          verticalSpacing(8),
          CustomContainer(
            value: "هذا النص مثال",
            isExpanded: true,
          ),
        ],
      ),
    );
  }
}

class PersonalGenaticDiseaseTab extends StatelessWidget {
  const PersonalGenaticDiseaseTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16.h),
                DetailsViewInfoTile(
              title: 'تاريخ التشخيص',
              value: "هذا النص مثال",
              icon: 'assets/images/date_icon.png',
              isExpanded: true,
            ),
            SizedBox(height: 16.h),

            DetailsViewInfoTile(
              title: "المرض الوراثى",
              value: "هذا النص مثال",
              icon: 'assets/images/tumor_icon.png',
              isExpanded: true,
            ),
            SizedBox(height: 16.h),
            DetailsViewInfoTile(
              title: "حالة المرض",
              value: "هذا النص مثال",
              icon: 'assets/images/tumor_icon.png',
              isExpanded: true,
            ),
            verticalSpacing(16),
            Row(
              children: [
                DetailsViewInfoTile(
                  title: 'الطبيب المعالج',
                  value: "هذا النص مثال",
                  icon: 'assets/images/doctor_icon.png',
                ),
                Spacer(),
                DetailsViewInfoTile(
                  title: 'المستشفي',
                  value: "هذا النص مثال",
                  icon: 'assets/images/hospital_icon.png',
                ),
              ],
            ),
            SizedBox(height: 16.h),
            DetailsViewInfoTile(
              title: 'الدولة',
              value: "هذا النص مثال",
              icon: 'assets/images/country_icon.png',
              isExpanded: true,
            ),
            verticalSpacing(16),
               DetailsViewImageWithTitleTile(
                  image: "assets/images/report.png", // Replace with actual image URL
                    title:"فحصات جينية",
                  isShareEnabled: true, // Enable sharing if needed
                  ),
            verticalSpacing(16),
               DetailsViewImageWithTitleTile(
                  image: "assets/images/report.png", // Replace with actual image URL
                    title:"فحوصات اخري",
                  isShareEnabled: true, // Enable sharing if needed
                  ),
            verticalSpacing(16),
             DetailsViewImageWithTitleTile(
                  image: "assets/images/report.png", // Replace with actual image URL
                    title: "التقرير الطبي",
                  isShareEnabled: true, 
                  ), 
          ],
        ),
 
    );
  }
}