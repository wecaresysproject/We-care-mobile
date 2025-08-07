import 'package:flutter/material.dart';
import 'package:we_care/core/Database/cach_helper.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/medicine/data/models/matched_medicines_model.dart';
import 'package:we_care/features/medicine/medicines_data_entry/logic/cubit/medicine_scanner_state.dart';

class SelectionMedicineListViewItem extends StatelessWidget {
  const SelectionMedicineListViewItem({
    super.key,
    required this.medicine,
    required this.index,
    required this.state,
  });

  final MatchedMedicineModel medicine;
  final int index;
  final MedicineScannerState state;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: () async {
              await CacheHelper.setData(
                "medicineName",
                medicine.medicineName,
              );
              Navigator.pop(context);
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
              child: Row(
                children: [
                  // Medicine icon with colored background
                  Container(
                    width: 45,
                    height: 45,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColorsManager.mainDarkBlue,
                          AppColorsManager.mainDarkBlue.withOpacity(0.7),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.medication_outlined,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  // Medicine info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          medicine.medicineName,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "${index % 3 == 0 ? 'أقراص' : index % 2 == 0 ? 'شراب' : 'كبسولات'} • ${10 + index * 5} ${index % 3 == 0 ? 'مجم' : 'مل'}",
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Selection icon
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: EdgeInsets.all(6),
                    child: Icon(
                      Icons.chevron_right,
                      color: AppColorsManager.mainDarkBlue,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        // Divider except for last item
        if (index < state.matchedMedicines.length - 1)
          Divider(height: 1, thickness: 1, color: Colors.grey[200]),
      ],
    );
  }
}
