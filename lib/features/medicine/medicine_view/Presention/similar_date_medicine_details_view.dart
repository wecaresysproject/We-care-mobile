import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:share_plus/share_plus.dart';
import 'package:we_care/core/global/SharedWidgets/custom_app_bar_with_centered_title_widget.dart';
import 'package:we_care/core/global/SharedWidgets/details_view_info_tile.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/medicine/data/models/get_all_user_medicines_responce_model.dart';

class SameDateMedicineDetailsView extends StatelessWidget {
  final String date;
  final List<MedicineModel> medicines;

  const SameDateMedicineDetailsView({
    super.key,
    required this.date,
    required this.medicines,
  });
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            AppBarWithCenteredTitle(
              title: 'الأدوية في تاريخ $date',
              showShareButtonOnly: true,
              shareFunction: () => shareDetails(date, medicines),
            ),
            ListView.builder(
              padding: EdgeInsets.all(16.r),
              itemCount: medicines.length,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index) {
                final medicine = medicines[index];
                return Card(
                  color: Colors.white,
                  margin: EdgeInsets.only(bottom: 12.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.r),
                    side: BorderSide(
                      color: AppColorsManager.mainDarkBlue,
                      width: 1,
                    ),
                  ),
                  elevation: 4,
                  child: Padding(
                    padding: EdgeInsets.all(16.r),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DetailsViewInfoTile(
                          title: "اسم الدواء",
                          value: medicine.medicineName,
                          isExpanded: true,
                          icon: 'assets/images/doctor_name.png',
                        ),
                        SizedBox(height: 8.h),
                        Row(children: [
                          Expanded(
                            child: DetailsViewInfoTile(
                              title: "الجرعة",
                              value: medicine.dosage,
                              icon: 'assets/images/hugeicons_medicine-01.png',
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Expanded(
                            child: DetailsViewInfoTile(
                              title: "عدد مرات الجرعة",
                              value: medicine.dosageFrequency,
                              icon: 'assets/images/times_icon.png',
                            ),
                          ),
                        ]),
                        DetailsViewInfoTile(
                          title: "مدة العلاج",
                          value: medicine.timeDuration,
                          icon: 'assets/images/time_icon.png',
                          isExpanded: true,
                        ),
                        DetailsViewInfoTile(
                          title: "اسم الطبيب",
                          value: medicine.doctorName,
                          icon: 'assets/images/doctor_icon.png',
                          isExpanded: true,
                        ),
                        DetailsViewInfoTile(
                          title: "الشكل الدوائي",
                          value: " اقراص",
                          icon: 'assets/images/symptoms_icon.png',
                          isExpanded: true,
                        ),
                        SizedBox(height: 8.h),
                        DetailsViewInfoTile(
                          title: 'الملاحظات الشخصية ',
                          value: medicine.personalNotes,
                          icon: 'assets/images/pin_edit_icon.png',
                          isExpanded: true,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: DetailsViewInfoTile(
                                title: "التنبيهات",
                                value: medicine.reminderStatus
                                    ? 'مفعل'
                                    : 'غير مفعل',
                                icon: 'assets/images/date_icon.png',
                              ),
                            ),
                            SizedBox(width: 8.w),
                            Flexible(
                              child: CustomContainer(value: medicine.reminder),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

void shareDetails(String date, List<MedicineModel> medicines) {
  final buffer = StringBuffer();
  buffer.writeln('🗓️ الأدوية في تاريخ $date\n');
  for (int i = 0; i < medicines.length; i++) {
    final medicine = medicines[i];
    buffer.writeln('🔹 اسم الدواء: ${medicine.medicineName}');
    buffer.writeln('   - الجرعة: ${medicine.dosage}');
    buffer.writeln('   - عدد مرات الجرعة: ${medicine.dosageFrequency}');
    buffer.writeln('   - مدة العلاج: ${medicine.timeDuration}');
    buffer.writeln('   - اسم الطبيب: ${medicine.doctorName}');
    buffer.writeln('   - الشكل الدوائي: أقراص');
    buffer.writeln('   - الملاحظات: ${medicine.personalNotes}');
    buffer.writeln(
        '   - التنبيهات: ${medicine.reminderStatus ? 'مفعل' : 'غير مفعل'}');
    buffer.writeln('   - وقت التنبيه: ${medicine.reminder}');
    buffer.writeln('');
  }
  Share.share(buffer.toString());
}
