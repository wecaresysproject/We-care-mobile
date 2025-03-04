import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/SharedWidgets/details_view_app_bar.dart';
import 'package:we_care/core/global/SharedWidgets/details_view_info_tile.dart';

class MedicineDetailsView extends StatelessWidget {
  const MedicineDetailsView({super.key});

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
              DetailsViewAppBar(title: 'الدواء'),
              Row(children: [
                DetailsViewInfoTile(
                    title: "اسم الدواء",
                    value: "الدواء",
                    icon: 'assets/images/doctor_name.png'),
                Spacer(),
                DetailsViewInfoTile(
                  title: "مستمر/متوقف",
                  value: "مستمر",
                  icon: 'assets/images/doctor_name.png',
                ),
              ]),
              Row(children: [
                DetailsViewInfoTile(
                    title: "تاريخ بدء الدواء",
                    value: "1 / 3 / 2025",
                    icon: 'assets/images/date_icon.png'),
                Spacer(),
                DetailsViewInfoTile(
                  title: " دواء مرض مزمن",
                  value: " هذا النص مثال ",
                  icon: 'assets/images/medicine_icon.png',
                ),
              ]),
              Row(children: [
                DetailsViewInfoTile(
                    title: "طريقة الاستخدام",
                    value: "اقراص",
                    icon: 'assets/images/chat_question_icon.png'),
                Spacer(),
                DetailsViewInfoTile(
                  title: " الجرعه",
                  value: " مرتين",
                  icon: 'assets/images/hugeicons_medicine-01.png',
                ),
              ]),
              Row(children: [
                DetailsViewInfoTile(
                    title: "عدد مرات في اليوم",
                    value: "مرتين",
                    icon: 'assets/images/times_icon.png'),
                Spacer(),
                DetailsViewInfoTile(
                  title: " مدة الاستخدام",
                  value: " 3 اسابيع",
                  icon: 'assets/images/time_icon.png',
                ),
              ]),
              Row(children: [
                DetailsViewInfoTile(
                    title: "تاريخ انتهاء العلاح ",
                    value: "1 / 3 / 2025",
                    icon: 'assets/images/date_icon.png'),
                Spacer(),
                DetailsViewInfoTile(
                    title: "اسم الطبيب ",
                    value: "د/ أحمد هاني",
                    icon: 'assets/images/doctor_icon.png'),
              ]),
              DetailsViewInfoTile(
                title: 'الاعراض المرضية',
                value: 'هذا النص مثال',
                icon: 'assets/images/symptoms_icon.png',
                isExpanded: true,
              ),
              DetailsViewInfoTile(
                title: 'الملاحظات الشخصية ',
                value:
                    "هذا النص هو مثال لنص يمكن أن يستبدل في نفس المساحة. لقد تم توليد هذا النص من مولد النص العربى، حيث يمكنك أن تولد مثل هذا النص أو العديد من النصوص الأخر",
                icon: 'assets/images/pin_edit_icon.png',
                isExpanded: true,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  DetailsViewInfoTile(
                      title: "التنبيهات",
                      value: "مفعل",
                      icon: 'assets/images/date_icon.png'),
                  Spacer(),
                  CustomContainer(value: 'كل 8 ساعات')
                ],
              ),
            ],
          ),
        ));
  }
}
