import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/SharedWidgets/details_view_app_bar.dart';
import 'package:we_care/core/global/SharedWidgets/details_view_image_with_title.dart';
import 'package:we_care/core/global/SharedWidgets/details_view_info_tile.dart';

class PrescriptionDetailsView extends StatelessWidget {
  const PrescriptionDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0.h,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.w),
        child: Column(
          spacing: 16.h,
          children: [
            DetailsViewAppBar(title: 'الروشتة'),
            Row(children: [
              DetailsViewInfoTile(
                  title: "التاريخ",
                  value: "1 / 3 / 2025",
                  icon: 'assets/images/date_icon.png'),
              Spacer(),
              DetailsViewInfoTile(
                title: "المرض",
                value: " التهاب جيوب انفية",
                icon: 'assets/images/symptoms_icon.png',
              ),
            ]),
            Row(children: [
              DetailsViewInfoTile(
                title: "اسم الطبيب",
                value: " د/ احمد هاني",
                icon: 'assets/images/doctor_name.png',
              ),
              Spacer(),
              DetailsViewInfoTile(
                  title: "التخصص ",
                  value: "انف واذن وحنجره",
                  icon: 'assets/images/doctor_icon.png'),
            ]),
            DetailsViewImageWithTitleTile(
              image: '',
              title: "صورة الروشتة",
            ),
            DetailsViewInfoTile(
                title: "الأعراض",
                value: "ارتفاع درجة الحرارة / صداع مزمن",
                icon: 'assets/images/symptoms_icon.png',
                isExpanded: true),
            Row(children: [
              DetailsViewInfoTile(
                  title: "الدولة",
                  value: "مصر",
                  icon: 'assets/images/country_icon.png'),
              Spacer(),
              DetailsViewInfoTile(
                  title: "المدينة",
                  value: "القاهرة ",
                  icon: 'assets/images/hospital_icon.png'),
            ]),
            DetailsViewInfoTile(
                title: "ملاحظات",
                value:
                    'هذا النص هو مثال لنص يمكن أن يستبدل في نفس المساحة. لقد تم توليد هذا النص من مولد النص العربى، حيث يمكنك أن تولد مثل هذا النص أو العديد من النصوص الأخر',
                icon: 'assets/images/notes_icon.png',
                isExpanded: true),
          ],
        ),
      ),
    );
  }
}
