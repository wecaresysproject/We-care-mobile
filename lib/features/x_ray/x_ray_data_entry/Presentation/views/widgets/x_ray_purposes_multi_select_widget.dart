import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_care/core/global/SharedWidgets/user_selection_container_shared_widget.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/x_ray/x_ray_data_entry/logic/cubit/x_ray_data_entry_cubit.dart';

class XRayPurposeMultiSelect extends StatelessWidget {
  const XRayPurposeMultiSelect({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<XRayDataEntryCubit, XRayDataEntryState>(
      buildWhen: (previous, current) =>
          previous.selectedPuposes != current.selectedPuposes ||
          previous.puposesOfSelectedXRayType !=
              current.puposesOfSelectedXRayType,
      builder: (context, state) {
        final cubit = context.read<XRayDataEntryCubit>();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            UserSelectionContainer(
              allowManualEntry: true,
              categoryLabel:
                  "نوعية الاحتياج للأشعة", // Another Dropdown Example
              containerHintText: state.selectedPuposes.isEmpty
                  ? "اختر نوعية احتياجك للأشعة"
                  : "${state.selectedPuposes.length} تم اختيارهم",
              options: state.puposesOfSelectedXRayType,
              onOptionSelected: (selectedPupose) {
                context
                    .read<XRayDataEntryCubit>()
                    .updateXRaySelectedPupose(selectedPupose);
              },
              bottomSheetTitle: "اختر نوعية احتياجك للأشعة",
              searchHintText: "ابحث عن نوعية احتياجك للأشعة",
            ),

            /// --------------------------
            /// عرض العناصر المختارة
            /// --------------------------
            if (state.selectedPuposes.isNotEmpty) ...[
              const SizedBox(height: 12),
              const Text(
                "الاحتياجات المحددة:",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 6),
              Wrap(
                spacing: 8.0,
                runSpacing: 4.0,
                children: state.selectedPuposes.map(
                  (purpose) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: AppColorsManager.mainDarkBlue.withAlpha(120),
                          width: 2,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Expanded(
                            child: Text(
                              purpose,
                              style: const TextStyle(fontSize: 14),
                              maxLines: 10,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 6),
                          GestureDetector(
                            onTap: () {
                              cubit.removeSelectedPurpose(purpose);
                            },
                            child: const Icon(
                              Icons.close,
                              size: 16,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ).toList(),
              ),
            ],
          ],
        );
      },
    );
  }
}
