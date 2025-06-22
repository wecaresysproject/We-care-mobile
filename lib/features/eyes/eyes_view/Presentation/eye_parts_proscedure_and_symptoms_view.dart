import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/SharedWidgets/details_view_app_bar.dart';
import 'package:we_care/core/global/SharedWidgets/details_view_image_with_title.dart';
import 'package:we_care/core/global/SharedWidgets/details_view_info_tile.dart';

class EyePartsProcedureAndSymptomsDetailsView extends StatelessWidget {
  const EyePartsProcedureAndSymptomsDetailsView(
      {super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 0,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: SingleChildScrollView(
            child: Column(
              spacing: 16.h,
              children: [
                DetailsViewAppBar(title: title, showActionButtons: true),
                DetailsViewInfoTile(
                  title: 'تاريخ الاعراض',
                  value: '1 / 3 / 2025',
                  icon: 'assets/images/date_icon.png',
                  isExpanded: true,
                ),
                DetailsViewInfoTile(
                  title: 'الاعراض',
                  value: 'الم في العين',
                  icon: 'assets/images/symptoms_icon.png',
                  isExpanded: true,
                ),
                DetailsViewInfoTile(
                  title: 'مدة الاعراض',
                  value: '3 شهور',
                  icon: 'assets/images/symptoms_icon.png',
                  isExpanded: true,
                ),
                DetailsViewInfoTile(
                  title: 'تاريخ الاجراء الطبي',
                  value: '1 / 3 / 2025',
                  icon: 'assets/images/date_icon.png',
                  isExpanded: true,
                ),
                DetailsViewInfoTile(
                  title: 'الاجراء الطبي',
                  value: 'الم في العين',
                  icon: 'assets/images/doctor_icon.png',
                  isExpanded: true,
                ),
                DetailsViewImageWithTitleTile(
                  isShareEnabled: true,
                  image: "https://www.researchgate.net/publication/291346521/figure/fig1/AS:614299588386842@1523471843460/Medical-Report-Form.png",
                  title: 'الطبي التقرير',
                ),
                DetailsViewImageWithTitleTile(
                  isShareEnabled: true,
                  image: 'https://www.researchgate.net/publication/291346521/figure/fig1/AS:614299588386842@1523471843460/Medical-Report-Form.png',
                  title: 'صورة الفحص الطبي',
                ),
                Row(
                  children: [
                    DetailsViewInfoTile(
                      title: 'المستشفى',
                      value: 'المستشفى',
                      icon: 'assets/images/hospital_icon.png',
                    ),
                    Spacer(),
                    DetailsViewInfoTile(
                      title: 'الطبيب',
                      value: 'د / احمد اسامة',
                      icon: 'assets/images/doctor_name.png',
                    ),
                  ],
                ),
                DetailsViewInfoTile(
                  title: 'الدولة',
                  value: 'السعودية',
                  icon: 'assets/images/country_icon.png',
                ),
                DetailsViewInfoTile(
                  title: 'الملاحظات',
                  value: 'لا يوجد',
                  icon: 'assets/images/notes_icon.png',
                  isExpanded: true,
                ),
              ],
            ),
          ),
        ));
  }
}