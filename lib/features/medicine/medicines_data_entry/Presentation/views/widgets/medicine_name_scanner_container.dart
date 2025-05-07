import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_care/core/Database/cach_helper.dart';
import 'package:we_care/core/di/dependency_injection.dart';
import 'package:we_care/core/global/theming/color_manager.dart' as core_colors;
import 'package:we_care/features/medicine/medicine_view/Presention/medicine_ocr_scanner.dart';
import 'package:we_care/features/medicine/medicines_data_entry/logic/cubit/medicine_scanner_cubit.dart';
import 'package:we_care/features/medicine/medicines_data_entry/logic/cubit/medicines_data_entry_cubit.dart';
import 'package:we_care/features/medicine/medicines_data_entry/logic/cubit/medicines_data_entry_state.dart';

class MedicneNameScannerContainer extends StatelessWidget {
  const MedicneNameScannerContainer({
    super.key,
    required this.state,
  });

  final MedicinesDataEntryState state;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "مسح اسم الدواء",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              BlocProvider<MedicineScannerCubit>(
                            create: (context) => getIt<MedicineScannerCubit>(),
                            child: MedicineOCRScanner(
                              title: "ماسح الأدوية",
                            ),
                          ),
                        ),
                      );
                      final selectedMedicineName =
                          await CacheHelper.getString("medicineName");
                      if (context.mounted && selectedMedicineName != null) {
                        await context
                            .read<MedicinesDataEntryCubit>()
                            .updateSelectedMedicineName(selectedMedicineName);
                        await CacheHelper.removeData("medicineName");
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: core_colors.AppColorsManager.mainDarkBlue,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      "فتح الماسح",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Text(
                "برجاء توجيه الكاميرا على الاسم الإنجليزي للدواء المطبوع على العبوة",
                style: TextStyle(
                  color: core_colors.AppColorsManager.mainDarkBlue,
                  fontSize: 14,
                ),
                textAlign: TextAlign.right,
              ),
            ],
          ),
        ),
        if (state.selectedMedicineName != null &&
            state.selectedMedicineName!.isNotEmpty) ...[
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.green[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.green),
            ),
            child: FittedBox(
              child: Row(
                children: [
                  const Icon(Icons.check_circle, color: Colors.green),
                  const SizedBox(width: 8),
                  Text(
                    "تم التعرف على: ${state.selectedMedicineName}",
                    maxLines: 2,
                    style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }
}
