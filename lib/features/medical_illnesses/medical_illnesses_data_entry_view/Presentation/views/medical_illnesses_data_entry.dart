import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/di/dependency_injection.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/custom_app_bar.dart';
import 'package:we_care/features/medical_illnesses/medical_illnesses_data_entry_view/Presentation/mental_illness_data_entry_form_fields_widget.dart';
import 'package:we_care/features/medical_illnesses/medical_illnesses_data_entry_view/logic/cubit/mental_illnesses_data_entry_cubit.dart';

class MentalIllnessDataEntry extends StatelessWidget {
  const MentalIllnessDataEntry({
    super.key,
    // this.pastEyeData,
    // this.editModelId,
  });

  // final EyeProceduresAndSymptomsDetailsModel? pastEyeData;
  // final String? editModelId;
  @override
  Widget build(BuildContext context) {
    return BlocProvider<MedicalIllnessesDataEntryCubit>(
      create: (context) {
        // if (pastEyeData != null) {
        //   return getIt<EyesDataEntryCubit>()
        //     ..loadPastEyeDataEnteredForEditing(
        //       pastEyeData: pastEyeData!,
        //       id: editModelId!,
        //     );
        // }
        return getIt<MedicalIllnessesDataEntryCubit>()..initialRequests();
      },
      child: Scaffold(
        appBar: AppBar(),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomAppBarWidget(
                  haveBackArrow: true,
                ),
                verticalSpacing(24),
                MentalIlnessesDataEntryFormFields(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
