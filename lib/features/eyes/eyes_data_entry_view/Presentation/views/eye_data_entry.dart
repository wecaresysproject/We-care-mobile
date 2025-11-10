import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/di/dependency_injection.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/custom_app_bar.dart';
import 'package:we_care/features/eyes/data/models/eye_procedures_and_symptoms_details_model.dart';
import 'package:we_care/features/eyes/eyes_data_entry_view/Presentation/eye_data_entry_form_fields_widget.dart';
import 'package:we_care/features/eyes/eyes_data_entry_view/Presentation/views/eye_procedures_and_syptoms_data_entry.dart';
import 'package:we_care/features/eyes/eyes_data_entry_view/logic/cubit/eyes_data_entry_cubit.dart';

class EyeDataEntry extends StatelessWidget {
  const EyeDataEntry({
    super.key,
    required this.selectedSyptoms,
    required this.selectedProcedures,
    required this.affectedEyePart,
    this.pastEyeData,
    this.editModelId,
  });
  final List<SymptomAndProcedureItem> selectedSyptoms;
  final List<SymptomAndProcedureItem> selectedProcedures;
  final String affectedEyePart;
  final EyeProceduresAndSymptomsDetailsModel? pastEyeData;
  final String? editModelId;
  @override
  Widget build(BuildContext context) {
    return BlocProvider<EyesDataEntryCubit>(
      create: (context) {
        if (pastEyeData != null) {
          return getIt<EyesDataEntryCubit>()
            ..loadPastEyeDataEnteredForEditing(
              pastEyeData: pastEyeData!,
              id: editModelId!,
            );
        }
        return getIt<EyesDataEntryCubit>()..getInitialRequests();
      },
      child: Scaffold(
        appBar: AppBar(),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomAppBarWidget(
                haveBackArrow: true,
              ),
              verticalSpacing(24),
              EyeDataEntryFormFields(
                selectedSyptoms: selectedSyptoms,
                selectedProcedures: selectedProcedures,
                affectedEyePart: affectedEyePart,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
