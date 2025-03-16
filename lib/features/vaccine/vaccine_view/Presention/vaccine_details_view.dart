import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/SharedWidgets/details_view_app_bar.dart';
import 'package:we_care/core/global/SharedWidgets/details_view_info_tile.dart';

class VaccineDetailsView extends StatelessWidget {
  const VaccineDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 0.h,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.only(bottom: 16.h, left: 16.w, right: 16.w),
          child: Column(
            spacing: 16.h,
            children: [
              DetailsViewAppBar(title: 'الجدري المائي'),
              Row(children: [
                DetailsViewInfoTile(
                    title: "العمر عند التلقي",
                    value: "62 عام",
                    icon: 'assets/images/file_icon.png'),
                Spacer(),
                DetailsViewInfoTile(
                    title: "الطعم",
                    value: "سابين",
                    icon: 'assets/images/medicine_icon.png'),
              ]),
              Row(children: [
                DetailsViewInfoTile(
                    title: "تاريج الجرعة",
                    value: "1 / 3 / 2025",
                    icon: 'assets/images/date_icon.png'),
                Spacer(),
                DetailsViewInfoTile(
                  title: "ترتيب الجرعة",
                  value: " هذا النص مثال ",
                  icon: 'assets/images/times_icon.png',
                ),
              ]),
              Row(children: [
                DetailsViewInfoTile(
                    title: "الفئة العمرية",
                    value: " هذا النص مثال ",
                    icon: 'assets/images/head_question_icon.png'),
                Spacer(),
                DetailsViewInfoTile(
                    title: " الزامي / اختياري",
                    value: " اختياري",
                    icon: 'assets/images/chat_question_icon.png'),
              ]),
              Row(children: [
                DetailsViewInfoTile(
                    title: "طريقة الاعطاء",
                    value: "فموي",
                    icon: 'assets/images/hugeicons_medicine-01.png'),
                Spacer(),
                DetailsViewInfoTile(
                  title: "المرض المستهدف",
                  value: "هذا النص مثال",
                  icon: 'assets/images/tumor_icon.png',
                ),
              ]),
              Row(children: [
                DetailsViewInfoTile(
                    title: "حجم الجرعة",
                    value: "نص مثال",
                    icon: 'assets/images/hugeicons_medicine-01.png'),
                Spacer(),
                DetailsViewInfoTile(
                    title: "جهة التلقي",
                    value: "مستشفى الامير ",
                    icon: 'assets/images/hospital_icon.png'),
              ]),
              DetailsViewInfoTile(
                title: "الاعراض الجانبيه - المنطقة",
                value:
                    ' هذا النص هو مثال لنص يمكن أن يستبدل في نفس المساحة. لقد تم توليد هذا النص من مولد ',
                icon: 'assets/images/symptoms_icon.png',
                isExpanded: true,
              ),
              DetailsViewInfoTile(
                title: "الاعراض الجانبيه - الشكوي",
                value:
                    ' هذا النص هو مثال لنص يمكن أن يستبدل في نفس المساحة. لقد تم توليد هذا النص من مولد ',
                icon: 'assets/images/symptoms_icon.png',
                isExpanded: true,
              ),
              DetailsViewInfoTile(
                title: "الدولة",
                value: 'نص مثال',
                icon: 'assets/images/country_icon.png',
              ),
              DetailsViewInfoTile(
                title: "معلومات اضافية",
                value:
                    ' هذا النص هو مثال لنص يمكن أن يستبدل في نفس المساحة. لقد تم توليد هذا النص من مولد ',
                icon: 'assets/images/notes_icon.png',
                isExpanded: true,
              ),
            ],
          ),
        ));
  }
}
