import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/SharedWidgets/details_view_app_bar.dart';
import 'package:we_care/core/global/SharedWidgets/details_view_image_with_title.dart';
import 'package:we_care/core/global/SharedWidgets/details_view_info_tile.dart';

class XRayDetailsView extends StatelessWidget {
  const XRayDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0.h,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          spacing: 16.h,
          children: [
            DetailsViewAppBar(title: 'الاشعة'),
            Row(children: [
              DetailsViewInfoTile(
                  title: "التاريخ",
                  value: "1 / 3 / 2025",
                  icon: 'assets/images/date_icon.png'),
              Spacer(),
              DetailsViewInfoTile(
                title: "المنطقة",
                value: "الرأس والدماغ",
                icon: 'assets/images/body_icon.png',
              ),
            ]),
            Row(children: [
              DetailsViewInfoTile(
                  title: "النوع",
                  value: "الرنين المغناطيسي",
                  icon: 'assets/images/type_icon.png'),
              Spacer(),
              DetailsViewInfoTile(
                  title: "نوعية الاحتياج",
                  value: "دورية",
                  icon: 'assets/images/need_icon.png'),
            ]),
            DetailsViewInfoTile(
                title: "الأعراض",
                value: "ارتفاع درجة الحرارة / صداع مزمن",
                icon: 'assets/images/symptoms_icon.png',
                isExpanded: true),
            Row(children: [
              DetailsViewInfoTile(
                  title: "الطبيب المعالج",
                  value: "د/ أحمد هاني",
                  icon: 'assets/images/doctor_icon.png'),
              Spacer(),
              DetailsViewInfoTile(
                  title: "طبيب الأشعة",
                  value: "د/ أسامة محمد",
                  icon: 'assets/images/doctor_icon.png'),
            ]),
            Row(children: [
              DetailsViewInfoTile(
                  title: "المستشفى",
                  value: "دار الفؤاد",
                  icon: 'assets/images/hospital_icon.png'),
              Spacer(),
              DetailsViewInfoTile(
                  title: "الدولة",
                  value: "مصر",
                  icon: 'assets/images/country_icon.png'),
            ]),
            DetailsViewInfoTile(
                title: "ملاحظات",
                value:
                    'هذا النص هو مثال لنص يمكن أن يستبدل في نفس المساحة. لقد تم توليد هذا النص من مولد النص العربى، حيث يمكنك أن تولد مثل هذا النص أو العديد من النصوص الأخر',
                icon: 'assets/images/notes_icon.png',
                isExpanded: true),
            DetailsViewImageWithTitleTile(
                image: 'assets/images/x_ray_sample.png', title: "صورة الأشعة"),
            DetailsViewImageWithTitleTile(
                image: 'assets/images/report.png', title: "صورة التقرير"),
          ],
        ),
      ),
    );
  }
}
