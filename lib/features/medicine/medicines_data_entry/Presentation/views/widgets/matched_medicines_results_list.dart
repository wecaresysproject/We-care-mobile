
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_care/core/global/Helpers/app_toasts.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/medicine/medicines_data_entry/Presentation/views/widgets/selection_medicine_list_view_item.dart';
import 'package:we_care/features/medicine/medicines_data_entry/logic/cubit/medicine_scanner_cubit.dart';
import 'package:we_care/features/medicine/medicines_data_entry/logic/cubit/medicine_scanner_state';

class MatchedMedicineResultsList extends StatelessWidget {
  const MatchedMedicineResultsList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MedicineScannerCubit, MedicineScannerState>(
      listener: (context, state) async {
        if (state.matchedMedicines.isEmpty &&
            state.message.isNotEmpty) {
          await showError(state.message);
        }
      },
      builder: (context, state) {
        if (state.matchedMedicines.isNotEmpty) {
          return Expanded(
            flex: 4,
            child: Container(
              margin: EdgeInsets.only(top: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                    BorderRadius.vertical(top: Radius.circular(20)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10,
                    spreadRadius: 1,
                    offset: Offset(0, -2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Header with drag handle
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Column(
                      children: [
                        // Drag handle
                        Container(
                          width: 40,
                          height: 4,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        SizedBox(height: 12),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.medication_liquid,
                                    color:
                                        AppColorsManager.mainDarkBlue,
                                    size: 20,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    'الأدوية المتطابقة',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppColorsManager.mainDarkBlue
                                      .withOpacity(0.1),
                                  borderRadius:
                                      BorderRadius.circular(12),
                                ),
                                child: Text(
                                  '${state.matchedMedicines.length} نتيجة',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color:
                                        AppColorsManager.mainDarkBlue,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(
                      height: 1, thickness: 1, color: Colors.grey[200]),
    
                  // Results list
                  Expanded(
                    child: ListView.builder(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      itemCount: state.matchedMedicines.length,
                      itemBuilder: (context, index) {
                        final medicine = state.matchedMedicines[index];
                        return SelectionMedicineListViewItem(medicine: medicine,
                            index: index,
                            state: state);
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        return SizedBox.shrink();
      },
    );
  }
}
