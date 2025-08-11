import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/details_view_info_tile.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/chronic_disease/data/models/add_new_medicine_model.dart';

class MedicineDetailsTemplate extends StatelessWidget {
  const MedicineDetailsTemplate({
    super.key,
    required this.model,
  });

  final AddNewMedicineModel model;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(8.r),
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(color: AppColorsManager.mainDarkBlue, width: 1),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/medicine_icon.png',
                height: 16,
                width: 16,
                fit: BoxFit.cover,
              ),
              horizontalSpacing(4),
              Text(
                "الأدوية",
                style: AppTextStyles.font18blackWight500.copyWith(
                  color: AppColorsManager.mainDarkBlue,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          verticalSpacing(16),
          Row(
            children: [
              Expanded(
                child: DetailsViewInfoTile(
                  title: "اسم الدواء",
                  value: model.medicineName,
                  isExpanded: true,
                  icon: 'assets/images/t_icon.png',
                ),
              ),
              horizontalSpacing(8),
              Expanded(
                child: DetailsViewInfoTile(
                  title: "تاريخ بدء الدواء",
                  value: model.startDate!,
                  isExpanded: true,
                  icon: 'assets/images/date_icon.png',
                ),
              ),
            ],
          ),
          verticalSpacing(16),
          Row(
            children: [
              Expanded(
                child: DetailsViewInfoTile(
                  title: "الجرعة",
                  value: model.dose!,
                  icon: 'assets/images/hand_with_caution.png',
                ),
              ),
              horizontalSpacing(8),
              Expanded(
                child: DetailsViewInfoTile(
                  title: "عدد مرات الجرعة",
                  value: model.numberOfDoses!,
                  icon: 'assets/images/heart_rate_search_icon.png',
                ),
              ),
            ],
          ),
          verticalSpacing(16),
          DetailsViewInfoTile(
            title: "طريقة الاستخدام",
            value: model.medicalForm!,
            icon: 'assets/images/chat_question.png',
          ),
        ],
      ),
    );
  }
}
