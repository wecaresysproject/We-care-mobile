import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/SharedWidgets/details_view_app_bar.dart';
import 'package:we_care/core/global/SharedWidgets/details_view_info_tile.dart';

class EyePartsProcedureAndSymptomsDetailsView extends StatelessWidget {
  const EyePartsProcedureAndSymptomsDetailsView({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          spacing: 16.h,
          children: [
            DetailsViewAppBar(title: title, showActionButtons: true),
            DetailsViewInfoTile(
              title: 'تاريخ الاعراض', value: '1 / 3 / 2025', icon: 'assets/images/date.png',
              isExpanded: true ,
              ),
            DetailsViewInfoTile(
              title: 'الاعراض', value: 'الم في العين', icon: 'assets/images/symptoms.png',
              isExpanded: true ,
              ),
            DetailsViewInfoTile(
              title: 'مدة الاعراض', value: '3 شهور', icon: 'assets/images/symptoms.png',
              isExpanded: true ,
              ),

          ],
        ),
      )
    );
  }
}