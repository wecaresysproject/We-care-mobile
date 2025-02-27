import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/SharedWidgets/details_view_app_bar.dart';
import 'package:we_care/core/global/SharedWidgets/details_view_image_with_title.dart';
import 'package:we_care/core/global/SharedWidgets/details_view_info_tile.dart';

class SurgeryDetailsView extends StatelessWidget {
  const SurgeryDetailsView({super.key});

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
            DetailsViewAppBar(title: 'العمليات'),
            Row(children: [
              DetailsViewInfoTile(
                title: "كود ICHI",
                value: "1342",
                icon: 'assets/images/data_search_icon.png',
              ),
              Spacer(),
              DetailsViewInfoTile(
                  title: "التاريخ",
                  value: "1 / 3 / 2025",
                  icon: 'assets/images/date_icon.png'),
            ]),
            Row(children: [
              DetailsViewInfoTile(
                title: "العضو",
                value: "القدم ",
                icon: 'assets/images/body_icon.png',
              ),
              Spacer(),
              DetailsViewInfoTile(
                  title: "المنطقة الفرعية ",
                  value: "العظام",
                  icon: 'assets/images/body_icon.png'),
            ]),
            DetailsViewInfoTile(
              title: 'اسم العملية',
              value: 'تثبيت كسر',
              icon: 'assets/images/doctor_name.png',
              isExpanded: true,
            ),
            DetailsViewInfoTile(
              title: ' الهدف من الاجراء',
              value: 'تثبيت كسر',
              icon: 'assets/images/chat_question_icon.png',
              isExpanded: true,
            ),
            Row(children: [
              DetailsViewInfoTile(
                title: "التقنية المستخدمة",
                value: "جراحة مجهرية ",
                icon: 'assets/images/data_search_icon.png',
              ),
              Spacer(),
              DetailsViewInfoTile(
                  title: "حالة العملية",
                  value: "تمت بنجاح",
                  icon: 'assets/images/ratio.png'),
            ]),
            DetailsViewInfoTile(
                title: "وصف مفصل",
                value:
                    'هذا النص هو مثال لنص يمكن أن يستبدل في نفس المساحة. لقد تم توليد هذا النص من مولد النص العربى، حيث يمكنك أن تولد مثل هذا النص أو العديد من النصوص الأخر',
                icon: 'assets/images/notes_icon.png',
                isExpanded: true),
            Row(children: [
              DetailsViewInfoTile(
                title: "الجراح ",
                value: " د/ شريف هاني ",
                icon: 'assets/images/surgery_icon.png',
              ),
              Spacer(),
              DetailsViewInfoTile(
                title: "طبيب الباطنة ",
                value: " د/ شريف هاني ",
                icon: 'assets/images/doctor_icon.png',
              ),
            ]),
            Row(children: [
              DetailsViewInfoTile(
                  title: "الدولة",
                  value: "مصر",
                  icon: 'assets/images/country_icon.png'),
              Spacer(),
              DetailsViewInfoTile(
                  title: "المستشفي",
                  value: "دار الفؤاد ",
                  icon: 'assets/images/hospital_icon.png'),
            ]),
            DetailsViewInfoTile(
                title: " تعليمات بعد العملية",
                value:
                    'هذا النص هو مثال لنص يمكن أن يستبدل في نفس المساحة. لقد تم توليد هذا النص من مولد النص العربى، حيث يمكنك أن تولد مثل هذا النص أو العديد من النصوص الأخر',
                icon: 'assets/images/symptoms_icon.png',
                isExpanded: true),
            DetailsViewInfoTile(
                title: " توصيف العملية",
                value:
                    'هذا النص هو مثال لنص يمكن أن يستبدل في نفس المساحة. لقد تم توليد هذا النص من مولد النص العربى، حيث يمكنك أن تولد مثل هذا النص أو العديد من النصوص الأخر',
                icon: 'assets/images/file_date_icon.png',
                isExpanded: true),
            DetailsViewInfoTile(
                title: " ملاحظات شخصية",
                value:
                    'هذا النص هو مثال لنص يمكن أن يستبدل في نفس المساحة. لقد تم توليد هذا النص من مولد النص العربى، حيث يمكنك أن تولد مثل هذا النص أو العديد من النصوص الأخر',
                icon: 'assets/images/notes_icon.png',
                isExpanded: true),
            DetailsViewImageWithTitleTile(
              image: 'assets/images/report.png',
              title: "التقرير الطبي",
            ),
          ],
        ),
      ),
    );
  }
}
