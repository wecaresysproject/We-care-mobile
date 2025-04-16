import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/routing/routes.dart';
import 'package:we_care/features/emergency_complaints/emergency_complaints_data_entry/Presentation/views/widgets/emergency_complaints_data_entry_form_fields_widget.dart';
import 'package:we_care/features/emergency_complaints/emergency_complaints_data_entry/logic/cubit/emergency_complaints_data_entry_cubit.dart';

class MedicalComplaintsListBlocBuilder extends StatelessWidget {
  const MedicalComplaintsListBlocBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EmergencyComplaintsDataEntryCubit,
        EmergencyComplaintsDataEntryState>(
      buildWhen: (previous, current) =>
          previous.medicalComplaints != current.medicalComplaints,
      builder: (context, state) {
        if (state.medicalComplaints.isEmpty) {
          return const SizedBox.shrink();
        }

        return ListView.builder(
          itemCount: state.medicalComplaints.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            final complaint = state.medicalComplaints[index];
            return GestureDetector(
              onTap: () async {
                final bool? result = await context.pushNamed(
                  Routes.addNewComplaintDetails,
                  arguments: {
                    'id': index,
                    'complaint': complaint,
                  },
                );
                if (result != null && context.mounted) {
                  await context
                      .read<EmergencyComplaintsDataEntryCubit>()
                      .fetchAllAddedComplaints();
                }
              },
              child: SymptomContainer(
                medicalComplaint: complaint,
                isMainSymptom: true,
                onDelete: () async {
                  final cubit =
                      context.read<EmergencyComplaintsDataEntryCubit>();
                  await cubit.removeAddedMedicalComplaint(index);
                  await cubit.fetchAllAddedComplaints();
                },
              ).paddingBottom(16),
            );
          },
        );
      },
    );
  }
}
