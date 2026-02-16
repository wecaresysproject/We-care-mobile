import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/SharedWidgets/app_custom_button.dart';
import 'package:we_care/features/my_medical_reports/logic/medical_report_generation_cubit.dart';

class GenerateButtonBlocConsumer extends StatelessWidget {
  const GenerateButtonBlocConsumer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MedicalReportGenerationCubit,
        MedicalReportGenerationState>(
      listenWhen: (previous, current) =>
          previous.generateReportStatus != current.generateReportStatus,
      listener: (context, state) {
        if (state.generateReportStatus == RequestStatus.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Report generated successfully'),
              backgroundColor: Colors.green,
            ),
          );
        } else if (state.generateReportStatus == RequestStatus.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  state.message.isNotEmpty ? state.message : 'Unknown error'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      builder: (context, state) {
        return AppCustomButton(
          title: 'Generate Report',
          isEnabled: true,
          onPressed: () async {
            await context
                .read<MedicalReportGenerationCubit>()
                .emitGenerateReport();
          },
          isLoading: state.generateReportStatus == RequestStatus.loading,
        );
      },
    );
  }
}
