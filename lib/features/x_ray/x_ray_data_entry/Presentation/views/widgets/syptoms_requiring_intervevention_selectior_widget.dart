import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/searchable_user_selector_container.dart'
    show SearchableUserSelectorContainer;
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/emergency_complaints/emergency_complaints_data_entry/logic/cubit/emergency_complaint_details_cubit.dart';
import 'package:we_care/features/x_ray/x_ray_data_entry/logic/cubit/x_ray_data_entry_cubit.dart';

class SymptomsRequiringInterventionSelector extends StatelessWidget {
  const SymptomsRequiringInterventionSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EmergencyComplaintDataEntryDetailsCubit,
        MedicalComplaintDataEntryDetailsState>(
      buildWhen: (previous, current) =>
          previous.medicalSymptomsIssue != current.medicalSymptomsIssue,
      builder: (context, emergencyState) {
        final cubit = context.read<XRayDataEntryCubit>();

        return BlocBuilder<XRayDataEntryCubit, XRayDataEntryState>(
          buildWhen: (previous, current) =>
              previous.symptomsRequiringIntervention !=
              current.symptomsRequiringIntervention,
          builder: (context, xrayState) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SearchableUserSelectorContainer(
                  allowManualEntry: true,
                  categoryLabel: "الأعراض المستدعية للإجراء",

                  /// لو مفيش ولا عرض مختار → هينزل hint
                  /// لو فيه → يظهر عددها
                  containerHintText:
                      emergencyState.medicalSymptomsIssue.isEmptyOrNull
                          ? "اختر الأعراض المستدعية"
                          : "${emergencyState.medicalSymptomsIssue}",

                  bottomSheetTitle: "اختر الأعراض المستدعية",
                  searchHintText: "ابحث عن الأعراض",

                  onOptionSelected: (value) {
                    cubit.updateSymptomsRequiringIntervention(value);
                  },
                ),

                /// لو المستخدم اختار أعراض → اعرضهم بشكل Chips
                if (xrayState.symptomsRequiringIntervention.isNotEmpty) ...[
                  verticalSpacing(12),
                  Text(
                    "الأعراض المحددة:",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.start,
                  ),
                  verticalSpacing(6),
                  Wrap(
                    spacing: 8.0,
                    runSpacing: 4.0,
                    children: xrayState.symptomsRequiringIntervention.map(
                      (symptom) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color:
                                  AppColorsManager.mainDarkBlue.withAlpha(100),
                              width: 2,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Expanded(
                                child: Text(
                                  symptom,
                                  style: const TextStyle(
                                    fontSize: 14,
                                  ),
                                  maxLines: 10,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              verticalSpacing(4),
                              GestureDetector(
                                onTap: () {
                                  cubit.removeSymptomRequiringIntervention(
                                      symptom);
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
      },
    );
  }
}
